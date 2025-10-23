"""
Endpoints REST para CAMPUS
Sistema: SGSCT
"""

from typing import Annotated
from fastapi import APIRouter, Depends, status, Query
from sqlalchemy.orm import Session
from src.database.sessions import get_db
from src.modules.users.base.models import User
from src.modules.academic.campus.schemas import (
    CampusCreate,
    CampusUpdate,
    CampusResponse,
)
from src.modules.academic.campus.services import CampusServices
from src.modules.auth.dependencies import require_admin
from src.core.responses import PaginatedResponse


router = APIRouter(prefix="/campus", tags=["Campus"])


@router.get(
    "",
    status_code=status.HTTP_200_OK,
    summary="Listar campus",
    response_model=PaginatedResponse[CampusResponse],
)
async def get_campus_list(
    db: Annotated[Session, Depends(get_db)],
    page: Annotated[int, Query(ge=1)] = 1,
    page_size: Annotated[int, Query(ge=1, le=100)] = 20,
):
    service = CampusServices(db)
    result = service.get_all(page=page, page_size=page_size)
    return PaginatedResponse(
        total=result["total"],
        items=[CampusResponse.model_validate(item) for item in result["items"]],
        skip=(page - 1) * page_size,
        limit=page_size,
    )


@router.get("/{campus_id}", status_code=status.HTTP_200_OK, summary="Obtener campus")
async def get_campus(campus_id: int, db: Annotated[Session, Depends(get_db)]):
    service = CampusServices(db)
    campus = service.get_by_id(campus_id)
    return campus.model_dump()


@router.post("", status_code=status.HTTP_201_CREATED, summary="Crear campus (admin)")
async def create_campus(
    db: Annotated[Session, Depends(get_db)],
    admin: Annotated[User, Depends(require_admin)],
    data: CampusCreate,
):
    service = CampusServices(db)
    campus = service.create(data)
    return campus.model_dump()


@router.put(
    "/{campus_id}", status_code=status.HTTP_200_OK, summary="Actualizar campus (admin)"
)
async def update_campus(
    campus_id: int,
    db: Annotated[Session, Depends(get_db)],
    admin: Annotated[User, Depends(require_admin)],
    data: CampusUpdate,
):
    service = CampusServices(db)
    campus = service.update(campus_id, data)
    return campus.model_dump()


@router.delete(
    "/{campus_id}", status_code=status.HTTP_200_OK, summary="Eliminar campus (admin)"
)
async def delete_campus(
    campus_id: int,
    db: Annotated[Session, Depends(get_db)],
    admin: Annotated[User, Depends(require_admin)],
):
    service = CampusServices(db)
    service.delete(campus_id)
    return {"detail": "Campus eliminado exitosamente"}
