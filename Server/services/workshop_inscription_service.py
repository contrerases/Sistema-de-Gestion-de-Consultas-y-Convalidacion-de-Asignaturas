from fastapi import HTTPException
import mariadb
from crud.workshop_inscription import get_workshops_inscriptions, create_workshop_inscription, update_workshop_inscription, cancel_workshop_inscription
from schemas.workshop_inscription.workshop_inscription_in import WorkshopInscriptionIn
from schemas.workshop_inscription.workshop_inscription_out import WorkshopInscriptionOut
from typing import Optional

def get_all_workshops_inscriptions_service():
    try:
        rows = get_workshops_inscriptions()
        return [WorkshopInscriptionOut(**row) for row in rows]
    except mariadb.Error as e:
        raise HTTPException(status_code=500, detail=str(e))

def get_workshop_inscription_by_id_service(id_inscription: int):
    try:
        rows = get_workshops_inscriptions()
        row = next((r for r in rows if r.get('id_inscription') == id_inscription), None)
        return WorkshopInscriptionOut(**row) if row else None
    except mariadb.Error as e:
        raise HTTPException(status_code=500, detail=str(e))

def get_workshops_inscriptions_by_workshop_service(id_workshop: int):
    try:
        rows = get_workshops_inscriptions(id_workshop=id_workshop)
        return [WorkshopInscriptionOut(**row) for row in rows]
    except mariadb.Error as e:
        raise HTTPException(status_code=500, detail=str(e))

def get_workshops_inscriptions_by_student_service(id_student: int):
    try:
        rows = get_workshops_inscriptions(id_student=id_student)
        return [WorkshopInscriptionOut(**row) for row in rows]
    except mariadb.Error as e:
        raise HTTPException(status_code=500, detail=str(e))

def get_workshops_inscriptions_by_student_rut_service(student_rut: str):
    try:
        rows = get_workshops_inscriptions(student_rut=student_rut)
        return [WorkshopInscriptionOut(**row) for row in rows]
    except mariadb.Error as e:
        raise HTTPException(status_code=500, detail=str(e))

def get_workshops_inscriptions_by_student_name_service(student_name: str):
    try:
        rows = get_workshops_inscriptions(student_name=student_name)
        return [WorkshopInscriptionOut(**row) for row in rows]
    except mariadb.Error as e:
        raise HTTPException(status_code=500, detail=str(e))

def get_workshops_inscriptions_by_student_rol_service(student_rol: str):
    try:
        rows = get_workshops_inscriptions(student_rol=student_rol)
        return [WorkshopInscriptionOut(**row) for row in rows]
    except mariadb.Error as e:
        raise HTTPException(status_code=500, detail=str(e))

def get_workshops_inscriptions_by_curriculum_course_service(id_curriculum_course: int):
    try:
        rows = get_workshops_inscriptions(id_curriculum_course=id_curriculum_course)
        return [WorkshopInscriptionOut(**row) for row in rows]
    except mariadb.Error as e:
        raise HTTPException(status_code=500, detail=str(e))

def create_workshop_inscription_service(inscription: WorkshopInscriptionIn):
    try:
        return create_workshop_inscription(
            inscription.id_student,
            inscription.id_workshop,
            inscription.id_curriculum_course,
            inscription.is_convalidated
        )
    except mariadb.Error as e:
        raise HTTPException(status_code=400, detail=str(e))

def update_workshop_inscription_service(id_inscription: int, inscription: WorkshopInscriptionIn):
    try:
        return update_workshop_inscription(
            id_inscription,
            inscription.id_student,
            inscription.id_workshop,
            inscription.id_curriculum_course,
            inscription.is_convalidated
        )
    except mariadb.Error as e:
        raise HTTPException(status_code=400, detail=str(e))

def cancel_workshop_inscription_service(id_inscription: int):
    try:
        return cancel_workshop_inscription(id_inscription)
    except mariadb.Error as e:
        raise HTTPException(status_code=400, detail=str(e)) 