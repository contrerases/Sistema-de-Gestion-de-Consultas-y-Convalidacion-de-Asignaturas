from fastapi import HTTPException
import mariadb
from crud.workshop_grade import get_workshop_grades, create_workshop_grade
from schemas.workshop_grade.workshop_grade_in import WorkshopGradeIn
from schemas.workshop_grade.workshop_grade_out import WorkshopGradeOut

def get_all_workshop_grades_service(workshop_id=None, student_id=None, min_grade=None, max_grade=None):
    try:
        rows = get_workshop_grades(workshop_id, student_id, min_grade, max_grade)
        return [WorkshopGradeOut(**row) for row in rows]
    except mariadb.Error as e:
        raise HTTPException(status_code=500, detail=str(e))

def create_workshop_grade_service(grade: WorkshopGradeIn):
    try:
        return create_workshop_grade(grade.dict())
    except mariadb.Error as e:
        raise HTTPException(status_code=400, detail=str(e)) 