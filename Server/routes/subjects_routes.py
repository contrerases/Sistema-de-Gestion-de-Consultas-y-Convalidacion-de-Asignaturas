from fastapi import HTTPException, status, APIRouter
from models import subjects_model
from database import get_db_connection
from typing import List
import mariadb as mdb

router = APIRouter()

BASE_MODEL = subjects_model.SubjectBase
RESPONSE_MODEL = subjects_model.SubjectResponse

@router.get("/", response_model=List[RESPONSE_MODEL])
async def get_all_subjects():
    try:
        conn = get_db_connection() 
        cursor = conn.cursor(dictionary=True)
        cursor.execute("CALL GetAllSubjectsProcessedData")
        subjects = cursor.fetchall()
        cursor.close()
        conn.close()
        return subjects
    except mdb.Error as e:
        raise HTTPException(status_code=status.HTTP_500_INTERNAL_SERVER_ERROR, detail=str(e))