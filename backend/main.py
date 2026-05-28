from fastapi import FastAPI
import sqlite3
from modele_ia import main
from pydantic import BaseModel
from fastapi.middleware.cors import CORSMiddleware
from fastapi_mail import MessageSchema , ConnectionConfig , FastMail

app = FastAPI()
DB = "avia.db"

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"], 
    allow_credentials=True,
    allow_methods=["*"], 
    allow_headers=["*"],
)


@app.get("/")
def home():
    return {"message": "Avia API is running"}

@app.post("/")
def execute_query(data: dict):

    sql = data.get("sql")

    conn = sqlite3.connect(DB)
    cursor = conn.cursor()

    try:
        cursor.execute(sql)
        conn.commit()

        sql_upper = sql.strip().upper()

        if sql_upper.startswith("SELECT"):
            rows = cursor.fetchall()

            return {
                "success": True,
                "type": "SELECT",
                "sql": sql,
                "result": rows,
                "error": None
            }

        return {
            "success": True,
            "type": "WRITE",
            "sql": sql,
            "result": None,
            "error": None
        }

    except Exception as e:
        return {
            "success": False,
            "type": "ERROR",
            "sql": sql,
            "result": None,
            "error": str(e)
        }

    finally:
        conn.close()

class Message(BaseModel):
    message: str

@app.post("/flutter/")
def Flutter_model(data: Message):
    message_user = data.message
    
    reponse = main(message_user)
    
    return {
        "reponse": reponse
    }
    

class User(BaseModel):
    name: str
    email: str
    password: str

@app.on_event("startup")
def init_db():
    conn = sqlite3.connect(DB)
    conn.execute("""
        CREATE TABLE IF NOT EXISTS utilisateur (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            email TEXT UNIQUE,
            password TEXT
        )
    """)
    conn.commit()
    conn.close()

#  Récupérer tous les utilisateurs (GET)
@app.get("/users/")
def get_users():
    conn = sqlite3.connect(DB)
    cursor = conn.cursor()
    cursor.execute("SELECT id, name, email FROM utilisateur")
    rows = cursor.fetchall()
    conn.close()
    return {"users": [{"id": r[0], "name": r[1], "email": r[2]} for r in rows]}

#  Créer un utilisateur (POST)
@app.post("/users/")
def create_user(user: User):
    try:
        conn = sqlite3.connect(DB)
        cursor = conn.cursor()
        cursor.execute(
            "INSERT INTO utilisateur (name, email, password) VALUES (?, ?, ?)",
            (user.name, user.email, user.password)
        )
        conn.commit()
        conn.close()
        return {"message": "Utilisateur créé avec succès"}
    except Exception as e:
        return {"error": str(e)}
    
    
config = ConnectionConfig(
    MAIL_USERNAME="adzoulap@gmail.com",
   MAIL_PASSWORD="ebxqntuukreoqkmr",
    MAIL_FROM="adzoulap@gmail.com",
    MAIL_PORT=587,
    MAIL_SERVER="smtp.gmail.com",
    MAIL_STARTTLS=True,
    MAIL_SSL_TLS=False,
    USE_CREDENTIALS=True
        
)
    
class Entreprise(BaseModel):
    nameEntreprise : str
    secteurEntreprise : str
    villeEntreprise : str
    tailleEntrprise : str
    logoEntreprise : str
    namePDG : str
    firstNamePDG : str
    emailPDG : str
    pwdPDG : str
    confirPwdPDG : str
    telPDG : str
    nbServices : int
    serviceEntreprise : str


@app.post("/mail/")
async def send_mail(entreprise : Entreprise):
    print(entreprise)
    
    message = MessageSchema(
        subject = "Bienvenu sur AVIA ",
        recipients = [entreprise.emailPDG],
        body = f"""
            <h2>Bienvenu {entreprise.nameEntreprise} </h2>
            
            <p>
            Votre entreprise a été créée avec succès.
            Bonne gestion à vous !!!
            </p>
        """,
        subtype = "html",
        
    )
    
    fm = FastMail(config)
    
    await fm.send_message(message)
    
    return {
        "message": "Entreprise créée et email envoyé"
    }