from fastapi import HTTPException, status, APIRouter
from models import course_model
from database import get_db_connection
from typing import List
import mariadb as mdb

router = APIRouter()

MODEL = course_model.Course

# Endpoint para obtener todos los cursos
@router.get("/", response_model=List[MODEL])
async def get_all_courses():
    try:
        conn = get_db_connection()  # Abrir la conexión
        cursor = conn.cursor(dictionary=True)
        cursor.execute("CALL get_all_courses()")
        courses = cursor.fetchall()
        cursor.close()
        conn.close()  # Cerrar la conexión
        return courses
    except mdb.Error as e:
        raise HTTPException(status_code=status.HTTP_500_INTERNAL_SERVER_ERROR, detail=str(e))

