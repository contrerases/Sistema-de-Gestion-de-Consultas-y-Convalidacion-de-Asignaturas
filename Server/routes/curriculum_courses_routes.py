from fastapi import HTTPException, status, APIRouter
from models import curriculum_courses_model
from database import get_db_connection
from typing import List
import mariadb as mdb

router = APIRouter()

BASE_MODEL = curriculum_courses_model.CurriculumCourseBase
POST_MODEL = curriculum_courses_model.CurriculumCoursePost


@router.get("/", response_model=List[BASE_MODEL])
async def get_all_curriculum_courses():
    try:
        conn = get_db_connection()  #
        cursor = conn.cursor(dictionary=True)
        cursor.callproc("GetAllCurriculumCourses")
        curriculum_courses = cursor.fetchall()
        cursor.close()
        conn.close()
        return curriculum_courses
    except mdb.Error as e:
        raise HTTPException(status_code=status.HTTP_500_INTERNAL_SERVER_ERROR, detail=str(e))
    


#post 
@router.post("/")
async def add_curriculum_course(curriculum_course: POST_MODEL):
    try:
        conn = get_db_connection()
        cursor = conn.cursor(dictionary=True)
        cursor.callproc("InsertCurriculumCourse", (curriculum_course.name,))
        conn.commit()
        cursor.close()
        conn.close()
        return { "message": "Curriculum Course has been added successfully."}
    except mdb.Error as e:
        raise HTTPException(status_code=status.HTTP_500_INTERNAL_SERVER_ERROR, detail=str(e))
    
