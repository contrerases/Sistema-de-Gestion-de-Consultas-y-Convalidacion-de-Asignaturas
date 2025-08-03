from fastapi import APIRouter, status
from typing import List
from schemas.request.request_out import RequestOut
from services.request_service import (
    get_all_requests_service,
    get_request_by_id_service,
    get_requests_by_student_service,
    get_request_convalidations_service
)

router = APIRouter(prefix="/requests", tags=["requests"])

@router.get("/", response_model=List[RequestOut])
def get_requests():
    """Lista todas las solicitudes con datos mínimos"""
    return get_all_requests_service()

@router.get("/{id_request}", response_model=RequestOut)
def get_request_by_id(id_request: int):
    """Obtiene una solicitud específica por ID con datos completos"""
    return get_request_by_id_service(id_request)

@router.get("/student/{id_student}", response_model=List[RequestOut])
def get_requests_by_student(id_student: int):
    """Obtiene las solicitudes de un estudiante específico"""
    return get_requests_by_student_service(id_student)

@router.get("/{id_request}/convalidations", response_model=List[dict])
def get_request_convalidations(id_request: int):
    """Obtiene las convalidaciones de una solicitud específica"""
    return get_request_convalidations_service(id_request) 