from fastapi import HTTPException
import mariadb
from crud.convalidation import (
    get_convalidations,
    get_convalidations_pending,
    get_convalidations_by_student,
    get_convalidations_by_student_rut,
    get_convalidations_by_student_rol,
    get_convalidations_by_student_name,
    get_convalidations_by_reviewed_by,
    get_convalidations_by_curriculum_course,
    get_convalidations_by_workshop,
    get_convalidations_by_activity,
    get_convalidations_by_type,
    get_convalidations_by_state,
    get_convalidation_by_id,
    create_convalidation,
    review_convalidation,
    drop_convalidation_while_no_reviewed_by,
    filter_convalidations
)
from schemas.convalidation.convalidation_in import ConvalidationIn
from schemas.convalidation.convalidation_search import ConvalidationSearch

from utils.helpers import build_convalidation_out


# =============================================================================
# SERVICIOS DE CONVALIDACIONES
# =============================================================================

def get_all_convalidations_service():
    """Obtiene lista de convalidaciones con datos mínimos para preview"""
    try:
        rows = get_convalidations()
        return [build_convalidation_out(row) for row in rows]
    except mariadb.Error as e:
        raise HTTPException(status_code=500, detail=str(e))

def get_convalidations_pending_service():
    """Obtiene convalidaciones pendientes con datos mínimos"""
    try:
        rows = get_convalidations_pending()
        return [build_convalidation_out(row) for row in rows]
    except mariadb.Error as e:
        raise HTTPException(status_code=500, detail=str(e))

def get_convalidations_by_student_service(id_student: int):
    """Obtiene convalidaciones de un estudiante con datos mínimos"""
    try:
        rows = get_convalidations_by_student(id_student)
        return [build_convalidation_out(row) for row in rows]
    except mariadb.Error as e:
        raise HTTPException(status_code=500, detail=str(e))

def get_convalidations_by_student_rut_service(student_rut: str):
    """Obtiene convalidaciones por RUT del estudiante con datos mínimos"""
    try:
        rows = get_convalidations_by_student_rut(student_rut)
        return [build_convalidation_out(row) for row in rows]
    except mariadb.Error as e:
        raise HTTPException(status_code=500, detail=str(e))

def get_convalidations_by_student_rol_service(student_rol: str):
    """Obtiene convalidaciones por ROL del estudiante con datos mínimos"""
    try:
        rows = get_convalidations_by_student_rol(student_rol)
        return [build_convalidation_out(row) for row in rows]
    except mariadb.Error as e:
        raise HTTPException(status_code=500, detail=str(e))

def get_convalidations_by_student_name_service(student_name: str):
    """Obtiene convalidaciones por nombre del estudiante con datos mínimos"""
    try:
        rows = get_convalidations_by_student_name(student_name)
        return [build_convalidation_out(row) for row in rows]
    except mariadb.Error as e:
        raise HTTPException(status_code=500, detail=str(e))

def get_convalidations_by_reviewed_by_service(id_reviewed_by: int):
    """Obtiene convalidaciones revisadas por un administrador con datos mínimos"""
    try:
        rows = get_convalidations_by_reviewed_by(id_reviewed_by)
        return [build_convalidation_out(row) for row in rows]
    except mariadb.Error as e:
        raise HTTPException(status_code=500, detail=str(e))

def get_convalidations_by_curriculum_course_service(id_curriculum_course: int):
    """Obtiene convalidaciones por curso curricular con datos mínimos"""
    try:
        rows = get_convalidations_by_curriculum_course(id_curriculum_course)
        return [build_convalidation_out(row) for row in rows]
    except mariadb.Error as e:
        raise HTTPException(status_code=500, detail=str(e))

def get_convalidations_by_workshop_service(id_workshop: int):
    """Obtiene convalidaciones por taller con datos mínimos"""
    try:
        rows = get_convalidations_by_workshop(id_workshop)
        return [build_convalidation_out(row) for row in rows]
    except mariadb.Error as e:
        raise HTTPException(status_code=500, detail=str(e))

def get_convalidations_by_activity_service(id_activity: int):
    """Obtiene convalidaciones por actividad con datos mínimos"""
    try:
        rows = get_convalidations_by_activity(id_activity)
        return [build_convalidation_out(row) for row in rows]
    except mariadb.Error as e:
        raise HTTPException(status_code=500, detail=str(e))

def get_convalidations_by_type_service(id_convalidation_type: int):
    """Obtiene convalidaciones por tipo con datos mínimos"""
    try:
        rows = get_convalidations_by_type(id_convalidation_type)
        return [build_convalidation_out(row) for row in rows]
    except mariadb.Error as e:
        raise HTTPException(status_code=500, detail=str(e))

def get_convalidations_by_state_service(id_convalidation_state: int):
    """Obtiene convalidaciones por estado con datos mínimos"""
    try:
        rows = get_convalidations_by_state(id_convalidation_state)
        return [build_convalidation_out(row) for row in rows]
    except mariadb.Error as e:
        raise HTTPException(status_code=500, detail=str(e))

def get_convalidation_by_id_service(id_convalidation: int):
    """Obtiene una convalidación específica con datos completos"""
    try:
        result = get_convalidation_by_id(id_convalidation)
        return build_convalidation_out(result) if result else None
    except mariadb.Error as e:
        raise HTTPException(status_code=500, detail=str(e))

def filter_convalidations_service(filters: ConvalidationSearch):
    """Filtra convalidaciones según criterios específicos"""
    try:
        rows = filter_convalidations(filters.dict())
        return [build_convalidation_out(row) for row in rows]
    except mariadb.Error as e:
        raise HTTPException(status_code=500, detail=str(e))

def create_convalidation_service(convalidation: ConvalidationIn):
    """Crea una nueva convalidación"""
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

def review_convalidation_service(id_convalidation: int, convalidation: ConvalidationIn):
    """Revisa una convalidación"""
    try:
        return review_convalidation(
            id_convalidation, 
            convalidation.id_convalidation_state, 
            convalidation.review_comments, 
            convalidation.id_reviewed_by
        )
    except mariadb.Error as e:
        raise HTTPException(status_code=400, detail=str(e))

def drop_convalidation_while_no_reviewed_by_service(id_convalidation: int):
    """Elimina una convalidación que no ha sido revisada"""
    try:
        return drop_convalidation_while_no_reviewed_by(id_convalidation)
    except mariadb.Error as e:
        raise HTTPException(status_code=400, detail=str(e)) 