"""
Endpoints de salud y monitoreo del sistema
"""
from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from src.database.sessions import get_db

router = APIRouter(prefix="/health", tags=["health"])


@router.get("/")
async def health_check():
    """
    Health check básico del API
    """
    return {
        "status": "healthy",
        "service": "SGSCT API",
        "version": "1.0.0"
    }


@router.get("/db")
async def database_health_check(db: Session = Depends(get_db)):
    """
    Verifica la conexión a la base de datos
    """
    try:
        # Query simple para verificar conexión
        db.execute("SELECT 1")
        return {
            "status": "healthy",
            "database": "connected"
        }
    except Exception as e:
        return {
            "status": "unhealthy",
            "database": "disconnected",
            "error": str(e)
        }
