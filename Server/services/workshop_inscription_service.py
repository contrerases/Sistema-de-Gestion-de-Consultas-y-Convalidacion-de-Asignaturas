from fastapi import HTTPException
import mariadb
from crud.workshop_inscription import (
    get_workshop_inscriptions,
    get_workshop_inscriptions_by_workshop,
    get_workshop_inscriptions_by_student,
    get_workshop_inscriptions_by_student_rut,
    get_workshop_inscriptions_by_student_name,
    get_workshop_inscriptions_by_student_rol,
    get_workshop_inscriptions_by_curriculum_course,
    get_workshop_inscription_by_id,
    create_workshop_inscription,
    cancel_workshop_inscription,
    unregister_workshop_after_start
)
from schemas.workshop_inscription.workshop_inscription_in import WorkshopInscriptionIn
from schemas.workshop_inscription.workshop_inscription_out import WorkshopInscriptionOut
from typing import Optional

# =============================================================================
# SERVICIOS DE INSCRIPCIONES
# =============================================================================

def get_all_workshop_inscriptions_service():
    """Obtiene lista de inscripciones con datos mínimos para preview"""
    try:
        rows = get_workshop_inscriptions()
        return [WorkshopInscriptionOut(**row) for row in rows]
    except mariadb.Error as e:
        raise HTTPException(status_code=500, detail=str(e))

def get_workshop_inscriptions_by_workshop_service(id_workshop: int):
    """Obtiene inscripciones de un taller específico con datos mínimos"""
    try:
        rows = get_workshop_inscriptions_by_workshop(id_workshop)
        return [WorkshopInscriptionOut(**row) for row in rows]
    except mariadb.Error as e:
        raise HTTPException(status_code=500, detail=str(e))

def get_workshop_inscriptions_by_student_service(id_student: int):
    """Obtiene inscripciones de un estudiante con datos mínimos"""
    try:
        rows = get_workshop_inscriptions_by_student(id_student)
        return [WorkshopInscriptionOut(**row) for row in rows]
    except mariadb.Error as e:
        raise HTTPException(status_code=500, detail=str(e))

def get_workshop_inscriptions_by_student_rut_service(student_rut: str):
    """Obtiene inscripciones por RUT del estudiante con datos mínimos"""
    try:
        rows = get_workshop_inscriptions_by_student_rut(student_rut)
        return [WorkshopInscriptionOut(**row) for row in rows]
    except mariadb.Error as e:
        raise HTTPException(status_code=500, detail=str(e))

def get_workshop_inscriptions_by_student_name_service(student_name: str):
    """Obtiene inscripciones por nombre del estudiante con datos mínimos"""
    try:
        rows = get_workshop_inscriptions_by_student_name(student_name)
        return [WorkshopInscriptionOut(**row) for row in rows]
    except mariadb.Error as e:
        raise HTTPException(status_code=500, detail=str(e))

def get_workshop_inscriptions_by_student_rol_service(student_rol: str):
    """Obtiene inscripciones por ROL del estudiante con datos mínimos"""
    try:
        rows = get_workshop_inscriptions_by_student_rol(student_rol)
        return [WorkshopInscriptionOut(**row) for row in rows]
    except mariadb.Error as e:
        raise HTTPException(status_code=500, detail=str(e))

def get_workshop_inscriptions_by_curriculum_course_service(id_curriculum_course: int):
    """Obtiene inscripciones por curso curricular con datos mínimos"""
    try:
        rows = get_workshop_inscriptions_by_curriculum_course(id_curriculum_course)
        return [WorkshopInscriptionOut(**row) for row in rows]
    except mariadb.Error as e:
        raise HTTPException(status_code=500, detail=str(e))

def get_workshop_inscription_by_id_service(id_inscription: int):
    """Obtiene una inscripción específica con datos completos"""
    try:
        result = get_workshop_inscription_by_id(id_inscription)
        return WorkshopInscriptionOut(**result) if result else None
    except mariadb.Error as e:
        raise HTTPException(status_code=500, detail=str(e))

def create_workshop_inscription_service(inscription: WorkshopInscriptionIn):
    """Crea una nueva inscripción a taller"""
    try:
        return create_workshop_inscription(
            inscription.id_student,
            inscription.id_workshop,
            inscription.is_convalidated,
            inscription.id_curriculum_course
        )
    except mariadb.Error as e:
        raise HTTPException(status_code=400, detail=str(e))

def cancel_workshop_inscription_service(id_inscription: int):
    """Cancela una inscripción a taller"""
    try:
        return cancel_workshop_inscription(id_inscription)
    except mariadb.Error as e:
        raise HTTPException(status_code=400, detail=str(e))

def unregister_workshop_after_start_service(id_inscription: int):
    """Da de baja una inscripción después del inicio del taller"""
    try:
        return unregister_workshop_after_start(id_inscription)
    except mariadb.Error as e:
        raise HTTPException(status_code=400, detail=str(e)) 