from fastapi import HTTPException
import mariadb
from crud.request import (
    get_requests,
    get_requests_by_student,
    get_request_by_id,
    get_request_convalidations
)
from schemas.request.request_out import RequestOut

# =============================================================================
# SERVICIOS DE SOLICITUDES
# =============================================================================

def get_all_requests_service():
    """Obtiene lista de solicitudes con datos mínimos para preview"""
    try:
        rows = get_requests()
        return [RequestOut(**row) for row in rows]
    except mariadb.Error as e:
        raise HTTPException(status_code=500, detail=str(e))

def get_requests_by_student_service(id_student: int):
    """Obtiene las solicitudes de un estudiante específico"""
    try:
        rows = get_requests_by_student(id_student)
        return [RequestOut(**row) for row in rows]
    except mariadb.Error as e:
        raise HTTPException(status_code=500, detail=str(e))

def get_request_by_id_service(id_request: int):
    """Obtiene una solicitud específica por ID con datos completos"""
    try:
        result = get_request_by_id(id_request)
        if not result:
            raise HTTPException(status_code=404, detail="Solicitud no encontrada")
        return RequestOut(**result)
    except mariadb.Error as e:
        raise HTTPException(status_code=500, detail=str(e))

def get_request_convalidations_service(id_request: int):
    """Obtiene las convalidaciones de una solicitud específica"""
    try:
        return get_request_convalidations(id_request)
    except mariadb.Error as e:
        raise HTTPException(status_code=500, detail=str(e)) 