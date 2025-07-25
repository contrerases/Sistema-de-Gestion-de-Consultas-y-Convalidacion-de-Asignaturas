from fastapi import HTTPException
import mariadb
from crud.workshop_grade import get_workshop_grades, create_workshop_grade, update_workshop_grade, delete_workshop_grade
from schemas.workshop_grade.workshop_grade_in import WorkshopGradeIn
from schemas.workshop_grade.workshop_grade_out import WorkshopGradeOut
from typing import Optional

def get_all_workshop_grades_service():
    try:
        rows = get_workshop_grades()
        return [WorkshopGradeOut(**row) for row in rows]
    except mariadb.Error as e:
        raise HTTPException(status_code=500, detail=str(e))

def get_workshop_grade_by_id_service(id_grade: int):
    try:
        rows = get_workshop_grades()
        row = next((r for r in rows if r.get('id_grade') == id_grade), None)
        return WorkshopGradeOut(**row) if row else None
    except mariadb.Error as e:
        raise HTTPException(status_code=500, detail=str(e))

def get_workshop_grades_by_workshop_service(id_workshop: int):
    try:
        rows = get_workshop_grades(id_workshop=id_workshop)
        return [WorkshopGradeOut(**row) for row in rows]
    except mariadb.Error as e:
        raise HTTPException(status_code=500, detail=str(e))

def get_workshop_grades_by_student_service(id_student: int):
    try:
        rows = get_workshop_grades(id_student=id_student)
        return [WorkshopGradeOut(**row) for row in rows]
    except mariadb.Error as e:
        raise HTTPException(status_code=500, detail=str(e))

def create_workshop_grade_service(grade: WorkshopGradeIn):
    try:
        return create_workshop_grade(grade.id_workshop, grade.id_student, grade.grade)
    except mariadb.Error as e:
        raise HTTPException(status_code=400, detail=str(e))

def update_workshop_grade_service(id_grade: int, grade: WorkshopGradeIn):
    try:
        return update_workshop_grade(id_grade, grade.id_workshop, grade.id_student, grade.grade)
    except mariadb.Error as e:
        raise HTTPException(status_code=400, detail=str(e))

def delete_workshop_grade_service(id_grade: int):
    try:
        return delete_workshop_grade(id_grade)
    except mariadb.Error as e:
        raise HTTPException(status_code=400, detail=str(e)) 