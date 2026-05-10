from fastapi import FastAPI
import sqlite3
from modele_ia import main
from pydantic import BaseModel
from fastapi.middleware.cors import CORSMiddleware

app = FastAPI()
DB = "avia.db"

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"], 
    allow_credentials=True,
    allow_methods=["*"], 
    allow_headers=["*"],
)



@app.post("/")
def execute_query(data: dict):

    sql = data.get("sql")

    conn = sqlite3.connect(DB)
    cursor = conn.cursor()

    try:
        cursor.execute(sql)
        result = cursor.fetchall()
        conn.commit()
        return {"result": result}

    except Exception as e:
        return {"error": str(e)}

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