import random


SALUTATIONS = {
    "salut": [
        "Salut ",
        "Hello ",
        "Salut, comment puis-je t'aider ?"
    ],

    "bonjour": [
        "Bonjour ",
        "Bonjour ",
        "Bonjour, que puis-je faire pour toi ?"
    ],

    "ça va": [
        "Oui ça va bien ",
        "Je vais très bien  Et toi ?"
    ]
}


# ──────────────────────────────────────────────
# Détection des messages simples
# ──────────────────────────────────────────────

def detect_simple_message(message: str):

    msg = message.lower().strip()

    for key in SALUTATIONS:
        if key in msg:
            return random.choice(SALUTATIONS[key])

    return None


# ──────────────────────────────────────────────
# Vérification SQL dangereuse
# ──────────────────────────────────────────────

DANGEROUS_SQL = [
    "DROP TABLE",
    "DELETE FROM",
    "TRUNCATE",
]


def is_dangerous_sql(query: str):

    upper = query.upper()

    for danger in DANGEROUS_SQL:
        if danger in upper:
            return True

    return False


# ──────────────────────────────────────────────
# Humanisation des résultats SQL
# ──────────────────────────────────────────────

def humanize_sql_result(question: str, result: dict):

    if not result.get("success"):

        return "Une erreur empêche l'exécution de cette action."

    data = result.get("result")

    if not data:
        return "Aucune donnée trouvée."

    question_lower = question.lower()


    if isinstance(data, list):

        first = data[0]

        if "total" in first:

            total = first["total"]

            if "table" in question_lower:
                return f"Tu as actuellement {total} tables dans la base "

            if "utilisateur" in question_lower:
                return f"Tu as actuellement {total} utilisateurs enregistrés "

            return f"Le total est de {total}."


    if "sqlite_master" in question_lower:

        tables = [x["name"] for x in data if "name" in x]

        return "Voici les tables disponibles : " + ", ".join(tables)


    if "utilisateur" in question_lower:

        users = []

        for row in data:

            nom = row.get("username") or row.get("nom")

            if nom:
                users.append(nom)

        if users:
            return "Utilisateurs trouvés : " + ", ".join(users)


    return "Action exécutée avec succès "