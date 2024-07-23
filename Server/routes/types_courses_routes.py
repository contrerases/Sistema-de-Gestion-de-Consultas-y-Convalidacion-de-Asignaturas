from fastapi import HTTPException, status, APIRouter
from models import types_courses_model
from database import get_db_connection
from typing import List
import mariadb as mdb

router = APIRouter()

BASE_MODEL = types_courses_model.TypeCourseBase
POST_MODEL = types_courses_model.TypeCourseInsert

@router.get("/", response_model=List[BASE_MODEL])
async def get_all_types_courses():
    try:
        conn = get_db_connection()  #
        cursor = conn.cursor(dictionary=True)
        cursor.callproc("GetAllTypeCourses")
        types_courses = cursor.fetchall()
        cursor.close()
        conn.close()
        return types_courses
    except mdb.Error as e:
        raise HTTPException(status_code=status.HTTP_500_INTERNAL_SERVER_ERROR, detail=str(e))
    

#post 
@router.post("/")
async def insert_type_course(type_course: POST_MODEL):
    try:
        conn = get_db_connection()
        cursor = conn.cursor()
        cursor.callproc("InsertTypeCourse", (type_course.name,))
        conn.commit()
        cursor.close()
        conn.close()
    except mdb.Error as e:
        raise HTTPException(status_code=status.HTTP_500_INTERNAL_SERVER_ERROR, detail=str(e))
    return {"message": "Type Course has been inserted successfully."}