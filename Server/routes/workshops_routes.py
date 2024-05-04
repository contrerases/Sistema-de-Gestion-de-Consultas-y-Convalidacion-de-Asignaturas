from fastapi import HTTPException, status, APIRouter
from models import workshops_model
from database import get_db_connection
from typing import List
import mariadb as mdb

router = APIRouter()

BASE_MODEL = workshops_model.WorkshopBase

@router.get("/", response_model=List[BASE_MODEL])
async def get_all_workshops():
    try:
        conn = get_db_connection()  #
        cursor = conn.cursor(dictionary=True)
        cursor.execute("CALL GetAllWorkshops")
        workshops = cursor.fetchall()
        cursor.close()
        conn.close()
        return workshops
    except mdb.Error as e:
        raise HTTPException(status_code=status.HTTP_500_INTERNAL_SERVER_ERROR, detail=str(e))