from fastapi import HTTPException
import mariadb
from crud.workshop_grade import (
    get_workshop_grades,
    get_workshop_grades_by_workshop,
    get_workshop_grades_by_student,
    get_workshop_grade_by_id,
    create_workshop_grade
)
from schemas.workshop_grade.workshop_grade_in import WorkshopGradeIn
from schemas.workshop_grade.workshop_grade_out import WorkshopGradeOut
from typing import Optional

# =============================================================================
# SERVICIOS DE CALIFICACIONES
# =============================================================================

def get_all_workshop_grades_service():
    """Obtiene lista de calificaciones con datos mínimos para preview"""
    try:
        rows = get_workshop_grades()
        return [WorkshopGradeOut(**row) for row in rows]
    except mariadb.Error as e:
        raise HTTPException(status_code=500, detail=str(e))

def get_workshop_grades_by_workshop_service(id_workshop: int):
    """Obtiene calificaciones de un taller específico con datos mínimos"""
    try:
        rows = get_workshop_grades_by_workshop(id_workshop)
        return [WorkshopGradeOut(**row) for row in rows]
    except mariadb.Error as e:
        raise HTTPException(status_code=500, detail=str(e))

def get_workshop_grades_by_student_service(id_student: int):
    """Obtiene calificaciones de un estudiante con datos mínimos"""
    try:
        rows = get_workshop_grades_by_student(id_student)
        return [WorkshopGradeOut(**row) for row in rows]
    except mariadb.Error as e:
        raise HTTPException(status_code=500, detail=str(e))

def get_workshop_grade_by_id_service(id_grade: int):
    """Obtiene una calificación específica con datos completos"""
    try:
        result = get_workshop_grade_by_id(id_grade)
        return WorkshopGradeOut(**result) if result else None
    except mariadb.Error as e:
        raise HTTPException(status_code=500, detail=str(e))

def create_workshop_grade_service(grade: WorkshopGradeIn):
    """Crea una nueva calificación"""
    try:
        return create_workshop_grade(grade.id_student, grade.id_workshop, grade.grade)
    except mariadb.Error as e:
        raise HTTPException(status_code=400, detail=str(e)) 