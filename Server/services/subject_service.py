from fastapi import HTTPException
import mariadb
from crud.subject import get_subjects, create_subject, update_subject, delete_subject
from schemas.subject.subject_response import SubjectOut
from schemas.subject.subject_create_in import SubjectCreateIn

def get_all_subjects_service():
    try:
        rows = get_subjects()
        return [SubjectOut(**row) for row in rows]
    except mariadb.Error as e:
        raise HTTPException(status_code=500, detail=str(e))

def get_subject_by_id_service(subject_id: int):
    try:
        rows = get_subjects(subject_id)
        if not rows:
            raise HTTPException(status_code=404, detail="Asignatura no encontrada")
        return SubjectOut(**rows[0])
    except mariadb.Error as e:
        raise HTTPException(status_code=500, detail=str(e))

def create_subject_service(subject: SubjectCreateIn):
    try:
        return create_subject(subject.acronym, subject.name, subject.id_department, subject.credits)
    except mariadb.Error as e:
        raise HTTPException(status_code=400, detail=str(e))

def update_subject_service(subject_id: int, subject: SubjectCreateIn):
    try:
        return update_subject(subject_id, subject.acronym, subject.name, subject.id_department, subject.credits)
    except mariadb.Error as e:
        raise HTTPException(status_code=400, detail=str(e))

def delete_subject_service(subject_id: int):
    try:
        return delete_subject(subject_id)
    except mariadb.Error as e:
        raise HTTPException(status_code=400, detail=str(e)) 