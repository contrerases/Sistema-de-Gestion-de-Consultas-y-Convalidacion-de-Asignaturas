from fastapi import HTTPException, status, APIRouter
from models import types_curriculum_courses_model
from database import get_db_connection
from typing import List
import mariadb as mdb


router = APIRouter()

RESPONSE_MODEL = types_curriculum_courses_model.TypeCurriculumCourseResponse

@router.get("/", response_model=List[RESPONSE_MODEL])
async def get_all_types_curriculum_courses():
    try:
        conn = get_db_connection()
        cursor = conn.cursor(dictionary=True)
        cursor.callproc("GetAllTypesCurriculumCourses")
        types_curriculum_courses = cursor.fetchall()
        cursor.close()
        conn.close()
        return types_curriculum_courses
    except mdb.Error as e:
        raise HTTPException(status_code=status.HTTP_500_INTERNAL_SERVER_ERROR, detail=str(e))