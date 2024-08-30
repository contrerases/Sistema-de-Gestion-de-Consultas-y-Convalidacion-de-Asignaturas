from fastapi import HTTPException, status, APIRouter
from models import workshops_grades_models
from database import get_db_connection
from typing import List
import mariadb as mdb

router = APIRouter()

BASE_MODEL = workshops_grades_models.WorkshopsGradesBase
POST_MODEL = workshops_grades_models.WorkshopsGradesPost
RESPONSE_MODEL = workshops_grades_models.WorkshopsGradesResponse

#GetWorkshopGradeByStudentID
@router.get("/student/{id_student}", response_model=List[RESPONSE_MODEL])
async def get_workshop_grades_by_student(id_student: int):
    try:
        conn = get_db_connection()
        cursor = conn.cursor(dictionary=True)
        cursor.callproc("GetWorkshopGradesByStudent", (id_student,))
        workshop_grades = cursor.fetchall()
        cursor.close()
        conn.close()
        return workshop_grades
    except mdb.Error as e:
        raise HTTPException(status_code=status.HTTP_500_INTERNAL_SERVER_ERROR, detail=str(e))
    

#GetWorkshopGradeByWorkshopID
@router.get("/workshop/{id_workshop}", response_model=List[RESPONSE_MODEL])
async def get_workshop_grades_by_workshop(id_workshop: int):
    try:
        conn = get_db_connection()
        cursor = conn.cursor(dictionary=True)
        cursor.callproc("GetWorkshopGradesByWorkshop", (id_workshop,))
        workshop_grades = cursor.fetchall()
        cursor.close()
        conn.close()
        return workshop_grades
    except mdb.Error as e:
        raise HTTPException(status_code=status.HTTP_500_INTERNAL_SERVER_ERROR, detail=str(e))
    
#InsertWorkshopGrade

@router.post("/")
async def insert_workshop_grade(workshop_grade: POST_MODEL):
    try:
        conn = get_db_connection()
        cursor = conn.cursor(dictionary=True)
        cursor.callproc("InsertWorkshopGrade", (workshop_grade.id_student, workshop_grade.id_workshop, workshop_grade.grade))
        conn.commit()
        cursor.close()
        conn.close()
    except mdb.Error as e:
        raise HTTPException(status_code=status.HTTP_500_INTERNAL_SERVER_ERROR, detail=str(e))