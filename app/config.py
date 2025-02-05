from app.database import db
import mysql.connector

from fastapi import HTTPException

def conectar_bd():
    try:
        return mysql.connector.connect(**db)
    except mysql.connector.Error as err:
        raise HTTPException(status_code=500, detail=f"Error de conexión: {err}")
    
def obtener_db():
    conn = conectar_bd()
    try:
        yield conn
    finally:
        conn.close()