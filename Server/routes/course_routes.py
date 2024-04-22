from fastapi import HTTPException, status, APIRouter
from models import course_model
from database import get_db_connection
from typing import List
import mariadb as mdb

router = APIRouter()

RESPONSE_MODEL = course_model.Course
QUERY_MODEL = course_model.CourseQuery

# Endpoint para obtener todos los cursos
@router.get("/", response_model=List[RESPONSE_MODEL])
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

@router.post("/new_course", response_model=QUERY_MODEL)
async def create_course(course: QUERY_MODEL):
    try:
        conn = get_db_connection()
        cursor = conn.cursor(dictionary=True)
        cursor.execute("CALL add_course(?, ?)", (course.acronym, course.name))
        conn.commit()
        cursor.close()
        conn.close()
        return course
    except mdb.Error as e:
        raise HTTPException(status_code=status.HTTP_500_INTERNAL_SERVER_ERROR, detail=str(e))
    
@router.put("/update_course/{acronym}")
async def update_course(acronym: str, course: QUERY_MODEL):
    try:
        conn = get_db_connection()
        cursor = conn.cursor(dictionary=True)
        cursor.execute("CALL update_course(?,?,?)", (acronym, course.acronym, course.name))
        conn.commit()
        cursor.close()
        conn.close()
        return {"message": "Curso actualizado"}
    except mdb.Error as e:
        raise HTTPException(status_code=status.HTTP_500_INTERNAL_SERVER_ERROR, detail=str(e))
    
@router.delete("/delete_course/{acronym}")
async def delete_course(acronym: str):
    try:
        conn = get_db_connection()
        cursor = conn.cursor(dictionary=True)
        cursor.execute("CALL delete_course(?)", (acronym,))
        conn.commit()
        cursor.close()
        conn.close()
        return {"message": "Curso eliminado"}
    except mdb.Error as e:
        raise HTTPException(status_code=status.HTTP_500_INTERNAL_SERVER_ERROR, detail=str(e))