from fastapi import HTTPException, status, APIRouter
from models import subject_model
from database import get_db_connection
from typing import List
import mariadb as mdb

router = APIRouter()

MODEL = subject_model.Subject



# Endpoint para obtener todos los sujetos
@router.get("/", response_model=List[subject_model.Subject])
async def get_all_subjects():
    try:
        conn = get_db_connection()  # Abrir la conexión
        cursor = conn.cursor(dictionary=True)
        cursor.execute("CALL get_all_subjects()")
        subjects = cursor.fetchall()
        cursor.close()
        conn.close()  # Cerrar la conexión
        print (subjects)
        return subjects
    except mdb.Error as e:
        raise HTTPException(status_code=status.HTTP_500_INTERNAL_SERVER_ERROR, detail=str(e))

