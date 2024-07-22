from fastapi import HTTPException, status, APIRouter

router = APIRouter()

@router.get("/")
async def home():
    response = {
    "message": "Bienvenido a la API de Sistema de Convalidaciones",
    "version": "1.0.0",
    "status": "La API esta corriendo",
}

    return response
