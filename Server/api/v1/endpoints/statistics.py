from fastapi import APIRouter
from services.dashboard_service import get_statistics_service

router = APIRouter(prefix="/statistics", tags=["statistics"])
 
@router.get("/")
def get_statistics():
    return get_statistics_service() 