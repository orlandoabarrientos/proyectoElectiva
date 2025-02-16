import base64
from fastapi import APIRouter, HTTPException, Depends
from pydantic import BaseModel
from typing import Optional
from app.config import obtener_db
import mysql.connector as mysql
import os
import glob

router = APIRouter()

BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))  
UPLOADS_PATH = os.path.join(BASE_DIR, "uploads", "images")  
IMG_EXTENSIONS = ["jpg", "jpeg", "png", "webp"]  

class Producto(BaseModel):
    codigo: str
    nombre: Optional[str] = None
    descripcion: Optional[str] = None
    cantidad: Optional[int] = None
    precio: Optional[float] = None
    impuesto: Optional[float] = None
    imagen_base64: Optional[str] = None  # Se agregará la imagen en base64

def GuardarImagen(codigo: str, imagen_base64: str):
    try:
        # Decodificar la imagen base64
        imagen_data = base64.b64decode(imagen_base64)
        
        file_extension = "png"  # Por defecto, usa PNG (ajustable según necesidad)

        # Eliminar imágenes del mismo código
        posibles_imagenes = glob.glob(os.path.join(UPLOADS_PATH, f"{codigo}.*"))
        for imagen_path in posibles_imagenes:
            if os.path.exists(imagen_path):
                os.remove(imagen_path)

        # Guardar la nueva imagen
        file_path = os.path.join(UPLOADS_PATH, f"{codigo}.{file_extension}")
        with open(file_path, "wb") as buffer:
            buffer.write(imagen_data)

        return file_path
    except Exception as e:
        raise HTTPException(status_code=400, detail=f"Error al guardar la imagen: {str(e)}")

@router.post("/productos_post")
def crear_producto(producto: Producto, db=Depends(obtener_db)):
    cursor = db.cursor()

    try:
        query = "INSERT INTO productos (codigo, nombre, descripcion, cantidad, precio, impuesto) VALUES (%s, %s, %s, %s, %s, %s)"
        cursor.execute(query, (producto.codigo, producto.nombre, producto.descripcion, producto.cantidad, producto.precio, producto.impuesto))

        # Guardar la imagen si se proporciona en Base64
        if producto.imagen_base64:
            GuardarImagen(producto.codigo, producto.imagen_base64)

        db.commit()
        return {"mensaje": "Producto creado"}

    except mysql.connector.Error as err:
        db.rollback()
        raise HTTPException(status_code=500, detail=f"Error en la consulta: {err}")

    finally:
        cursor.close()
        db.close()
        
@router.delete("/productos_eliminar")
def eliminar_products(producto: Producto, db=Depends(obtener_db)):
    cursor = db.cursor()

    try:
        query = "DELETE FROM productos WHERE codigo = %s"
        cursor.execute(query, (producto.codigo,))
        
        posibles_imagenes = glob.glob(os.path.join(UPLOADS_PATH, f"{producto.codigo}.*"))
        for imagen_path in posibles_imagenes:
            if os.path.exists(imagen_path):
                os.remove(imagen_path)
                
        db.commit()
        return {"mensaje": "Producto eliminado"}

    except mysql.connector.Error as err:
        db.rollback()
        raise HTTPException(status_code=500, detail=f"Error en la consulta: {err}")

    finally:
        cursor.close()
        db.close()

# GET = obtiene los productos de la base de datos y asigna un URL a la imagen 
#       de cada producto (si existe un producto con esa imagen)
@router.get("/productos_get")
def obtener_productos(db=Depends(obtener_db)):
    cursor = db.cursor(dictionary=True)

    try:
        cursor.execute("SELECT * FROM productos")
        productos = cursor.fetchall()
        # recorrer la lista de productos y asignar la URL de la imagen
        for producto in productos:
            codigo = str(producto["codigo"]).strip()  
            imagen_path = None
            # condicional para verificar si la imagen existe en la carpeta uploads
            if codigo:  
                posibles_imagenes = glob.glob(os.path.join(UPLOADS_PATH, f"{codigo}.*"))  
                if posibles_imagenes:
                    imagen_path = posibles_imagenes[0] 
                    imagen_path = os.path.relpath(imagen_path, BASE_DIR)  
                    imagen_path = imagen_path.replace("\\", "/")  
                    producto["imagen_url"] = f"/{imagen_path}" #if imagen_path else DEFAULT_IMG

        return productos

    except mysql.connector.Error as err:
        raise HTTPException(status_code=500, detail=f"Error en la consulta: {err}")

    finally:
        cursor.close()
        db.close()

@router.post("/productos_actualizar")
def actualizar_producto(producto: Producto, db=Depends(obtener_db)):
    cursor = db.cursor()

    try:
        query = "UPDATE productos SET nombre = %s, descripcion = %s, cantidad = %s, precio = %s, impuesto = %s WHERE codigo = %s"
        cursor.execute(query, (producto.nombre, producto.descripcion, producto.cantidad, producto.precio, producto.impuesto, producto.codigo))

        # Subir la nueva imagen 
        if producto.imagen_base64:
            GuardarImagen(producto.codigo, producto.imagen_base64)

        db.commit()
        return {"mensaje": "Producto actualizado"}

    except mysql.connector.Error as err:
        db.rollback()
        raise HTTPException(status_code=500, detail=f"Error en la consulta: {err}")

    finally:
        cursor.close()
        db.close()
