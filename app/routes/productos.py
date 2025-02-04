from fastapi import APIRouter, HTTPException
from pydantic import BaseModel
from app.config import conectar_bd
import mysql.connector

router = APIRouter()

class Producto(BaseModel):
    nombre: str
    descripcion: str
    cantidad: int
    precio: float
    impuesto: float

@router.post("/productos_post")
def crear_producto(producto: Producto):
    conexion = conectar_bd()
    cursor = conexion.cursor()

    try:
        cursor.execute("""
            CREATE TABLE IF NOT EXISTS productos (
                codigo INT AUTO_INCREMENT PRIMARY KEY,
                nombre VARCHAR(50) NOT NULL,
                descripcion TEXT NOT NULL,
                cantidad INT NOT NULL,
                precio DECIMAL(10, 2) NOT NULL,
                impuesto DECIMAL(10, 2) NOT NULL
            )
        """)

        query = "INSERT INTO productos (nombre, descripcion, cantidad, precio, impuesto) VALUES (%s, %s, %s, %s, %s)"
        cursor.execute(query, (producto.nombre, producto.descripcion, producto.cantidad, producto.precio, producto.impuesto))

        conexion.commit()
        return {"mensaje": "Producto creado"}

    except mysql.connector.Error as err:
        conexion.rollback()
        raise HTTPException(status_code=500, detail=f"Error en la consulta: {err}")

    finally:
        cursor.close()
        conexion.close()

@router.get("/productos_get")
def obtener_productos():
    conexion = conectar_bd()
    cursor = conexion.cursor(dictionary=True)

    try:
        cursor.execute("SELECT * FROM productos")
        productos = cursor.fetchall()
        return productos

    except mysql.connector.Error as err:
        raise HTTPException(status_code=500, detail=f"Error en la consulta: {err}")

    finally:
        cursor.close()
        conexion.close()
