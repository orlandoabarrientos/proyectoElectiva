from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
from config import config
import mysql.connector

class Usuario(BaseModel):
    nombre: str
    apellido: str

app = FastAPI()

def conectar_bd():
    try:
        return mysql.connector.connect(**config)
    except mysql.connector.Error as err:
        raise HTTPException(status_code=500, detail=f"Error de conexión: {err}")

@app.post("/usuario/")
def crear_usuario(usuario: Usuario):
    conexion = conectar_bd()
    cursor = conexion.cursor()

    try:
        cursor.execute("""
            CREATE TABLE IF NOT EXISTS usuario (
                id INT AUTO_INCREMENT PRIMARY KEY,
                nombre VARCHAR(50) NOT NULL,
                apellido VARCHAR(50) NOT NULL
            )
        """)

        query = "INSERT INTO usuario (nombre, apellido) VALUES (%s, %s)"
        cursor.execute(query, (usuario.nombre, usuario.apellido))

        
        conexion.commit()
        return {"mensaje": "Usuario creado"}

    except mysql.connector.Error as err:
        conexion.rollback()
        raise HTTPException(status_code=500, detail=f"Error en la consulta: {err}")

    finally:
        cursor.close()
        conexion.close()

@app.get("/usuario/")
def obtener_usuarios():
    conexion = conectar_bd()
    cursor = conexion.cursor(dictionary=True)

    try:
        cursor.execute("SELECT * FROM usuario")
        usuario = cursor.fetchall()
        return {"usuario": usuario}

    except mysql.connector.Error as err:
        raise HTTPException(status_code=500, detail=f"Error en la consulta: {err}")

    finally:
        cursor.close()
        conexion.close()