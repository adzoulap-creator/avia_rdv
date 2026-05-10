from groq import Groq
import requests
import json
import os


modele = os.environ.get("GROQ_API_KEY")

MEMORY_FILE = "memoire.json"
CONFIG_FILE = "config.json"


def open_config():
    with open(CONFIG_FILE, "r", encoding="utf-8") as f:
        return json.load(f)


def open_memory():
    if not os.path.exists(MEMORY_FILE):
        return []
    with open(MEMORY_FILE, "r", encoding="utf-8") as f:
        return json.load(f)

def save_memory(memory):
    with open(MEMORY_FILE, "w", encoding="utf-8") as f:
        json.dump(memory, f, indent=4, ensure_ascii=False)

def build_context(memory, max_history):
    return "\n".join(
        f"User: {m['question']}\nIA: {m['reponse']}"
        for m in memory[-max_history:]
    )


def call_ai(question, config, memory):

    context = build_context(memory, config["max_history"])

    res = modele.chat.completions.create(
        model=config["model"],
        messages=[
            {"role": "system", "content": config["system_prompt"]},
            {"role": "user", "content": context + "\nQuestion: " + question}
        ],
        temperature=config["temperature"]
    )

    return res.choices[0].message.content


def looks_like_db_question(q):
    keywords = ["utilisateur", "email", "nom", "liste", "nombre", "combien", "table"]
    return any(k in q.lower() for k in keywords)


def send_api(sql):
    try:
        r = requests.post("http://127.0.0.1:8000/", json={"sql": sql})
        return r.json()
    except Exception as e:
        return {"error": str(e)}


def main(message_user):

    config = open_config()
    memory = open_memory()
    
    question = message_user

    if question.lower() == "exit":
        return "Fin de la conversation"

    raw_response = call_ai(question, config, memory)

    response = raw_response


    try:
        data = json.loads(raw_response)

        if data.get("type") == "SQL":

            sql = data["query"]

            result = send_api(sql)

            if "error" in result:
                    response = "Erreur base de données : " + result["error"]


            else:
                result_data = result["result"]

                response = modele.chat.completions.create(
                    model=config["model"],
                    messages=[
                        {
                            "role": "system",
                            "content": "Tu transformes des résultats SQL en phrases naturelles simples et courtes en français."
                        },
                        {
                            "role": "user",
                            "content": f"""
                                Question : {question}
                                Résultat SQL : {result_data}

                                Réponds simplement :

                                - si 1 → "Tu as 1 résultat"
                                - si 5 → "Tu as 5 résultats"
                                - sinon explique clairement en français
                                """
                        }
                    ]
                ).choices[0].message.content

    except json.JSONDecodeError:
        response = raw_response

    print("IA :", response)

    memory.append({
        "question": question,
        "reponse": response
    })

    save_memory(memory)
    return response  