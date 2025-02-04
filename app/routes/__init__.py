from fastapi import APIRouter
from .productos import router as productos_router

router = APIRouter()
router.include_router(productos_router, tags=["Productos"])
