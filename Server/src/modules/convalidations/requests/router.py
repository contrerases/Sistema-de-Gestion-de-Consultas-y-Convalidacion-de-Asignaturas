"""
Router de Requests
Sistema: SGSCT
"""
from fastapi import APIRouter, Depends, status, Query
from sqlalchemy.orm import Session
from typing import Annotated, Optional
from src.database.sessions import get_db
from src.modules.convalidations.requests.service import RequestService
from src.modules.convalidations.requests.schemas import RequestCreate, RequestUpdateState
from src.core.responses import success_response, paginated_response

router = APIRouter(prefix="/requests", tags=["Solicitudes de Convalidación"])


@router.get("", status_code=status.HTTP_200_OK, summary="Listar solicitudes")
async def get_requests(
    page: Annotated[int, Query(ge=1)] = 1,
    page_size: Annotated[int, Query(ge=1, le=100)] = 20,
    state_id: Optional[int] = None,
    student_id: Optional[int] = None,
    db: Annotated[Session, Depends(get_db)] = None
):
    """Lista todas las solicitudes con paginación y filtros opcionales"""
    service = RequestService(db)
    result = service.get_all(page=page, page_size=page_size, state_id=state_id, student_id=student_id)
    
    return paginated_response(
        data=[item.model_dump() for item in result["items"]],
        page=result["page"],
        page_size=result["page_size"],
        total=result["total"]
    )


@router.get("/{request_id}", status_code=status.HTTP_200_OK, summary="Obtener solicitud")
async def get_request(
    request_id: int,
    db: Annotated[Session, Depends(get_db)] = None
):
    """Obtiene una solicitud específica por ID"""
    service = RequestService(db)
    request = service.get_by_id(request_id)
    
    return success_response(
        data=request.model_dump(),
        message="Solicitud obtenida exitosamente"
    )


@router.get("/student/{student_id}", status_code=status.HTTP_200_OK, summary="Solicitudes de estudiante")
async def get_requests_by_student(
    student_id: int,
    page: Annotated[int, Query(ge=1)] = 1,
    page_size: Annotated[int, Query(ge=1, le=100)] = 20,
    db: Annotated[Session, Depends(get_db)] = None
):
    """Obtiene todas las solicitudes de un estudiante"""
    service = RequestService(db)
    result = service.get_by_student(student_id, page=page, page_size=page_size)
    
    return paginated_response(
        data=[item.model_dump() for item in result["items"]],
        page=result["page"],
        page_size=result["page_size"],
        total=result["total"]
    )


@router.post("", status_code=status.HTTP_201_CREATED, summary="Crear solicitud")
async def create_request(
    data: RequestCreate,
    db: Annotated[Session, Depends(get_db)] = None
):
    """Crea una nueva solicitud de convalidación"""
    service = RequestService(db)
    request = service.create(data)
    
    return success_response(
        data=request.model_dump(),
        message="Solicitud creada exitosamente"
    )


@router.patch("/{request_id}/state", status_code=status.HTTP_200_OK, summary="Actualizar estado")
async def update_request_state(
    request_id: int,
    data: RequestUpdateState,
    db: Annotated[Session, Depends(get_db)] = None
):
    """Actualiza el estado de una solicitud"""
    service = RequestService(db)
    request = service.update_state(request_id, data)
    
    return success_response(
        data=request.model_dump(),
        message="Estado actualizado exitosamente"
    )


@router.delete("/{request_id}", status_code=status.HTTP_200_OK, summary="Eliminar solicitud")
async def delete_request(
    request_id: int,
    db: Annotated[Session, Depends(get_db)] = None
):
    """Elimina una solicitud (solo si no tiene convalidaciones)"""
    service = RequestService(db)
    service.delete(request_id)
    
    return success_response(
        data=None,
        message="Solicitud eliminada exitosamente"
    )
