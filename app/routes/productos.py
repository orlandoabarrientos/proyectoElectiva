from fastapi import APIRouter, HTTPException, Depends
from pydantic import BaseModel
from app.config import obtener_db
import mysql.connector as mysql
import os
import glob

router = APIRouter()

BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))  
UPLOADS_PATH = os.path.join(BASE_DIR, "uploads", "images")  
DEFAULT_IMG = "/uploads/images/DEFAULT.png"
IMG_EXTENSIONS = ["jpg", "jpeg", "png", "webp"]  

class Producto(BaseModel):
    codigo: str 
    nombre: str
    descripcion: str
    cantidad: int
    precio: float
    impuesto: float

@router.post("/productos_post")
def crear_producto(producto: Producto, db=Depends(obtener_db)):
 
    cursor = db.cursor()

    try:
        query = "INSERT INTO productos (codigo, nombre, descripcion, cantidad, precio, impuesto) VALUES (%s, %s, %s, %s, %s, %s)"
        cursor.execute(query, (producto.codigo, producto.nombre, producto.descripcion, producto.cantidad, producto.precio, producto.impuesto))

        db.commit()
        return {"mensaje": "Producto creado"}

    except mysql.dbector.Error as err:
        db.rollback()
        raise HTTPException(status_code=500, detail=f"Error en la consulta: {err}")

    finally:
        cursor.close()
        db.close()

@router.get("/productos_get")
def obtener_productos(db=Depends(obtener_db)):
    cursor = db.cursor(dictionary=True)

    try:
        cursor.execute("SELECT * FROM productos")
        productos = cursor.fetchall()

        for producto in productos:
            codigo = str(producto["codigo"]).strip()  

            imagen_path = None
            if codigo:  
                posibles_imagenes = glob.glob(os.path.join(UPLOADS_PATH, f"{codigo}.*"))  
                if posibles_imagenes:
                    imagen_path = posibles_imagenes[0] 
                    imagen_path = os.path.relpath(imagen_path, BASE_DIR)  
                    imagen_path = imagen_path.replace("\\", "/")  

            producto["imagen_url"] = f"/{imagen_path}" if imagen_path else DEFAULT_IMG

        return productos

    except mysql.dbector.Error as err:
        raise HTTPException(status_code=500, detail=f"Error en la consulta: {err}")

    finally:
        cursor.close()
        db.close()