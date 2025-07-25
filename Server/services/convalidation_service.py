from fastapi import HTTPException
import mariadb
from crud.convalidation import get_convalidations, create_convalidation, review_convalidation, drop_convalidation_while_no_reviewed_by
from schemas.convalidation.convalidation_in import ConvalidationIn
from schemas.convalidation.convalidation_out import ConvalidationOut
from schemas.convalidation.convalidation_subject_out import ConvalidationSubjectOut
from schemas.convalidation.convalidation_workshop_out import ConvalidationWorkshopOut
from schemas.convalidation.convalidation_external_activity_out import ConvalidationExternalActivityOut
from schemas.convalidation.convalidation_search import ConvalidationSearch
from typing import Optional

def build_convalidation_out(row):
    if row.get('id_subject'):
        return ConvalidationOut(subject=ConvalidationSubjectOut(**row), workshop=None, external=None)
    elif row.get('id_workshop'):
        return ConvalidationOut(subject=None, workshop=ConvalidationWorkshopOut(**row), external=None)
    elif row.get('id_activity_name'):
        return ConvalidationOut(subject=None, workshop=None, external=ConvalidationExternalActivityOut(**row))
    else:
        return ConvalidationOut(subject=None, workshop=None, external=None)

def get_all_convalidations_service():
    try:
        rows = get_convalidations()
        return [build_convalidation_out(row) for row in rows]
    except mariadb.Error as e:
        raise HTTPException(status_code=500, detail=str(e))

def get_convalidation_by_id_service(id_convalidation: int):
    try:
        rows = get_convalidations(id_convalidation=id_convalidation)
        return build_convalidation_out(rows[0]) if rows else None
    except mariadb.Error as e:
        raise HTTPException(status_code=500, detail=str(e))

def get_convalidations_by_student_service(id_student: int):
    try:
        rows = get_convalidations(id_student=id_student)
        return [build_convalidation_out(row) for row in rows]
    except mariadb.Error as e:
        raise HTTPException(status_code=500, detail=str(e))

def get_convalidations_by_student_rut_service(student_rut: str):
    try:
        rows = get_convalidations(student_rut=student_rut)
        return [build_convalidation_out(row) for row in rows]
    except mariadb.Error as e:
        raise HTTPException(status_code=500, detail=str(e))

def get_convalidations_by_student_rol_service(student_rol: str):
    try:
        rows = get_convalidations(student_rol=student_rol)
        return [build_convalidation_out(row) for row in rows]
    except mariadb.Error as e:
        raise HTTPException(status_code=500, detail=str(e))

def get_convalidations_by_student_name_service(student_name: str):
    try:
        rows = get_convalidations(student_name=student_name)
        return [build_convalidation_out(row) for row in rows]
    except mariadb.Error as e:
        raise HTTPException(status_code=500, detail=str(e))

def get_convalidations_by_reviewed_by_service(id_reviewed_by: int):
    try:
        rows = get_convalidations(id_reviewed_by=id_reviewed_by)
        return [build_convalidation_out(row) for row in rows]
    except mariadb.Error as e:
        raise HTTPException(status_code=500, detail=str(e))

def get_convalidations_by_curriculum_course_service(id_curriculum_course: int):
    try:
        rows = get_convalidations(id_curriculum_course=id_curriculum_course)
        return [build_convalidation_out(row) for row in rows]
    except mariadb.Error as e:
        raise HTTPException(status_code=500, detail=str(e))

def get_convalidations_by_workshop_service(id_workshop: int):
    try:
        rows = get_convalidations(id_workshop=id_workshop)
        return [build_convalidation_out(row) for row in rows]
    except mariadb.Error as e:
        raise HTTPException(status_code=500, detail=str(e))

def get_convalidations_by_activity_service(id_activity: int):
    try:
        rows = get_convalidations(id_activity=id_activity)
        return [build_convalidation_out(row) for row in rows]
    except mariadb.Error as e:
        raise HTTPException(status_code=500, detail=str(e))

def get_convalidations_by_type_service(id_convalidation_type: int):
    try:
        rows = get_convalidations(id_convalidation_type=id_convalidation_type)
        return [build_convalidation_out(row) for row in rows]
    except mariadb.Error as e:
        raise HTTPException(status_code=500, detail=str(e))

def get_convalidations_by_state_service(id_convalidation_state: int):
    try:
        rows = get_convalidations(id_convalidation_state=id_convalidation_state)
        return [build_convalidation_out(row) for row in rows]
    except mariadb.Error as e:
        raise HTTPException(status_code=500, detail=str(e))

def filter_convalidations_service(filters: ConvalidationSearch):
    try:
        rows = get_convalidations(**filters.dict())
        return [build_convalidation_out(row) for row in rows]
    except mariadb.Error as e:
        raise HTTPException(status_code=500, detail=str(e))

def create_convalidation_service(convalidation: ConvalidationIn):
    try:
        return create_convalidation(
            convalidation.id_student,
            convalidation.id_convalidation_type,
            convalidation.id_curriculum_course,
            getattr(convalidation, 'id_workshop', None),
            getattr(convalidation, 'activity_name', None),
            getattr(convalidation, 'description', None),
            getattr(convalidation, 'file_name', None),
            getattr(convalidation, 'file_data', None),
            getattr(convalidation, 'id_subject', None),
            getattr(convalidation, 'id_department', None)
        )
    except mariadb.Error as e:
        raise HTTPException(status_code=400, detail=str(e))

def review_convalidation_service(id_convalidation: int, id_convalidation_state: int, review_comments: str, id_reviewed_by: int):
    try:
        return review_convalidation(id_convalidation, id_convalidation_state, review_comments, id_reviewed_by)
    except mariadb.Error as e:
        raise HTTPException(status_code=400, detail=str(e))

def drop_convalidation_while_no_reviewed_by_service(id_convalidation: int):
    try:
        return drop_convalidation_while_no_reviewed_by(id_convalidation)
    except mariadb.Error as e:
        raise HTTPException(status_code=400, detail=str(e)) 