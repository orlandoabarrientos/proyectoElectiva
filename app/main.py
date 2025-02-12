from fastapi import FastAPI
from fastapi.staticfiles import StaticFiles
from app.routes import router
import os

app = FastAPI(title="API de Productos")

app.include_router(router)

UPLOADS_PATH = os.path.join(os.path.dirname(__file__), "uploads")

app.mount("/uploads", StaticFiles(directory=UPLOADS_PATH), name="uploads")

@app.get("/")
def home():
    return {"message": "La API funcionando"}

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)
