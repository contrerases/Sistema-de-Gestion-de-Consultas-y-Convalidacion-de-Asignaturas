from fastapi import HTTPException
import mariadb
from crud.convalidation import (
    create_convalidation,
    get_convalidations,
    get_convalidation_by_student,
    get_convalidation_pending,
    review_convalidation
)
from schemas.convalidation.convalidation_create_in import ConvalidationCreateIn
from schemas.convalidation.convalidation_on import ConvalidationOn
from schemas.convalidation.convalidation_subject_out import ConvalidationSubjectOut
from schemas.convalidation.convalidation_workshop_out import ConvalidationWorkshopOut
from schemas.convalidation.convalidation_external_activity_out import ConvalidationExternalActivityOut
from typing import List, Dict, Any

def create_convalidation_service(data: ConvalidationCreateIn) -> bool:
    try:
        return create_convalidation(data.dict())
    except mariadb.Error as e:
        raise HTTPException(status_code=500, detail=str(e))

def get_convalidations_service(filters: ConvalidationOn) -> Dict[str, List[Any]]:
    try:
        rows = get_convalidations(filters.dict())
        # Separar por tipo de convalidación
        subjects = [ConvalidationSubjectOut(**row) for row in rows if row.get('id_subject')]
        workshops = [ConvalidationWorkshopOut(**row) for row in rows if row.get('id_workshop')]
        externals = [ConvalidationExternalActivityOut(**row) for row in rows if row.get('activity_name')]
        return {
            'subjects': subjects,
            'workshops': workshops,
            'externals': externals
        }
    except mariadb.Error as e:
        raise HTTPException(status_code=500, detail=str(e))

def get_convalidation_by_student_service(id_student: int = None, student_rol: str = None, student_rut: str = None) -> Dict[str, List[Any]]:
    try:
        rows = get_convalidation_by_student(id_student, student_rol, student_rut)
        subjects = [ConvalidationSubjectOut(**row) for row in rows if row.get('id_subject')]
        workshops = [ConvalidationWorkshopOut(**row) for row in rows if row.get('id_workshop')]
        externals = [ConvalidationExternalActivityOut(**row) for row in rows if row.get('activity_name')]
        return {
            'subjects': subjects,
            'workshops': workshops,
            'externals': externals
        }
    except mariadb.Error as e:
        raise HTTPException(status_code=500, detail=str(e))

def get_convalidation_pending_service() -> Dict[str, List[Any]]:
    try:
        rows = get_convalidation_pending()
        subjects = [ConvalidationSubjectOut(**row) for row in rows if row.get('id_subject')]
        workshops = [ConvalidationWorkshopOut(**row) for row in rows if row.get('id_workshop')]
        externals = [ConvalidationExternalActivityOut(**row) for row in rows if row.get('activity_name')]
        return {
            'subjects': subjects,
            'workshops': workshops,
            'externals': externals
        }
    except mariadb.Error as e:
        raise HTTPException(status_code=500, detail=str(e))

def review_convalidation_service(id_convalidation: int, id_convalidation_state: int, review_comments: str, id_reviewed_by: int) -> bool:
    try:
        return review_convalidation(id_convalidation, id_convalidation_state, review_comments, id_reviewed_by)
    except mariadb.Error as e:
        raise HTTPException(status_code=500, detail=str(e)) 