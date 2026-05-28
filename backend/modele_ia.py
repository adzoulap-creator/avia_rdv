from google import genai   
import requests
import json
import os
import re
from dotenv import load_dotenv
from setting import (
    detect_simple_message,
    humanize_sql_result,
    is_dangerous_sql
)

load_dotenv()

client = genai.Client(api_key=os.environ.get("GEMINI_API_KEY"))

MEMORY_FILE = "memoire.json"
CONFIG_FILE = "config.json"


# ──────────────────────────────────────────────
# Chargement config et mémoire
# ──────────────────────────────────────────────

def open_config() -> dict:
    with open(CONFIG_FILE, "r", encoding="utf-8") as f:
        return json.load(f)


def open_memory() -> list:
    if not os.path.exists(MEMORY_FILE):
        return []
    with open(MEMORY_FILE, "r", encoding="utf-8") as f:
        try:
            data = json.load(f)
            return data if isinstance(data, list) else []
        except json.JSONDecodeError:
            return []


def save_memory(memory: list) -> None:
    with open(MEMORY_FILE, "w", encoding="utf-8") as f:
        json.dump(memory, f, indent=4, ensure_ascii=False)


# ──────────────────────────────────────────────
# Construction du contexte conversationnel
# ──────────────────────────────────────────────

def build_context(memory: list, max_history: int) -> str:
    """Retourne les N derniers échanges formatés pour le prompt."""
    recent = memory[-max_history:]
    if not recent:
        return "Aucun historique disponible."
    return "\n".join(
        f"User: {m['question']}\nAvia: {m['reponse']}"
        for m in recent
    )



def extract_sql_json(text: str) -> dict | None:

    cleaned = re.sub(r"```(?:json)?", "", text).replace("```", "").strip()

    try:
        data = json.loads(cleaned)
        if isinstance(data, dict) and data.get("type") == "SQL" and "query" in data:
            return data
    except json.JSONDecodeError:
        pass

    match = re.search(r'\{[^{}]*"type"\s*:\s*"SQL"[^{}]*"query"\s*:\s*"[^"]*"[^{}]*\}', text, re.DOTALL)
    if match:
        try:
            data = json.loads(match.group())
            if data.get("type") == "SQL" and "query" in data:
                return data
        except json.JSONDecodeError:
            pass

    return None


# ──────────────────────────────────────────────
# Appels au modèle Gemini
# ──────────────────────────────────────────────

def call_ai(question: str, config: dict, memory: list) -> str:

    context = build_context(memory, config["max_history"])

    prompt = f"""{config["system_prompt"]}

=== HISTORIQUE ===
{context}

=== QUESTION ===
{question}
"""

    response = client.models.generate_content(
        model=config["model"],
        contents=prompt
    )

    return response.text.strip()


def explain_sql_result(result: dict, question: str, config: dict) -> str:

    modele = genai.GenerativeModel(config["model"])


    result_str = json.dumps(result, ensure_ascii=False, indent=2)

    prompt = f"""{config["result_prompt"]}

=== DEMANDE ORIGINALE DE L'UTILISATEUR ===
{question}

=== RÉSULTAT RETOURNÉ PAR L'API ===
{result_str}

Formule maintenant une réponse naturelle et élégante en français pour l'utilisateur."""

    response = modele.generate_content(
        prompt,
        generation_config={"temperature": 0.3}
    )
    return response.text.strip()


# ──────────────────────────────────────────────
# Envoi de la requête SQL à l'API FastAPI
# ──────────────────────────────────────────────

def send_api(sql: str) -> dict:
    """Envoie la requête SQL à l'API et retourne le résultat."""
    try:
        r = requests.post(
            "http://127.0.0.1:8000/",
            json={"sql": sql},
            timeout=10
        )
        r.raise_for_status()
        return r.json()
    except requests.exceptions.ConnectionError:
        return {
            "success": False,
            "error": "Impossible de se connecter à l'API. Vérifiez que le serveur est démarré.",
            "type": "CONNECTION_ERROR"
        }
    except requests.exceptions.Timeout:
        return {
            "success": False,
            "error": "La requête a pris trop de temps.",
            "type": "TIMEOUT_ERROR"
        }
    except Exception as e:
        return {
            "success": False,
            "error": str(e),
            "type": "UNKNOWN_ERROR"
        }


# ──────────────────────────────────────────────
# Fonction principale
# ──────────────────────────────────────────────

def main(message_user: str) -> str:
    """
    Orchestration complète :
    1. Charger config et mémoire
    2. Appeler le LLM
    3. Si SQL détecté → exécuter via API → interpréter le résultat
    4. Sinon → retourner la réponse directe
    5. Sauvegarder dans la mémoire
    """
    config = open_config()
    memory = open_memory()

    question = message_user.strip()

    simple_response = detect_simple_message(question)

    if simple_response:
        return simple_response

    if not question:
        return "Je n'ai pas reçu de message."

    if question.lower() in ("exit", "quit", "au revoir"):
        return "Au revoir ! N'hésitez pas à revenir si vous avez besoin de moi."


    raw_response = call_ai(question, config, memory)

    sql_data = extract_sql_json(raw_response)

    if sql_data:
        sql_query = sql_data["query"]
        if is_dangerous_sql(sql_query):
            return " Cette opération est sensible. Confirmation requise."

        api_result = send_api(sql_query)

        final_response = humanize_sql_result(question, api_result)
    else:
        try:
            leftover = json.loads(raw_response)
            if isinstance(leftover, dict):
                final_response = "Je n'ai pas pu traiter votre demande correctement. Pourriez-vous reformuler ?"
            else:
                final_response = raw_response
        except (json.JSONDecodeError, ValueError):
            final_response = raw_response

    memory.append({
        "question": question,
        "reponse": final_response
    })

    max_total = config.get("max_history", 10) * 10
    if len(memory) > max_total:
        memory = memory[-max_total:]

    save_memory(memory)

    return final_response