from fastapi import HTTPException
import mariadb
from crud.subject import get_subjects, get_subjects_by_department, create_subject, update_subject, delete_subject
from schemas.subject.subject_in import SubjectIn
from schemas.subject.subject_out import SubjectOut

def get_all_subjects_service():
    """Obtiene lista de asignaturas"""
    try:
        rows = get_subjects()
        return [SubjectOut(**row) for row in rows]
    except mariadb.Error as e:
        raise HTTPException(status_code=500, detail=str(e))

def get_subject_by_id_service(subject_id: int):
    try:
        rows = get_subjects(id_subject=subject_id)
        return SubjectOut(**rows[0]) if rows else None
    except mariadb.Error as e:
        raise HTTPException(status_code=500, detail=str(e))

def create_subject_service(subject: SubjectIn):
    """Crea una nueva asignatura"""
    try:
        return create_subject(subject.acronym, subject.name, subject.credits, subject.id_department)
    except mariadb.Error as e:
        raise HTTPException(status_code=400, detail=str(e))

def update_subject_service(subject_id: int, subject: SubjectIn):
    """Actualiza una asignatura existente"""
    try:
        return update_subject(subject_id, subject.acronym, subject.name, subject.credits, subject.id_department)
    except mariadb.Error as e:
        raise HTTPException(status_code=400, detail=str(e))

def delete_subject_service(subject_id: int):
    """Elimina una asignatura"""
    try:
        return delete_subject(subject_id)
    except mariadb.Error as e:
        raise HTTPException(status_code=400, detail=str(e))

def get_subjects_by_department_service(id_department: int):
    """Obtiene asignaturas por departamento"""
    try:
        rows = get_subjects_by_department(id_department)
        return [SubjectOut(**row) for row in rows]
    except mariadb.Error as e:
        raise HTTPException(status_code=500, detail=str(e)) 