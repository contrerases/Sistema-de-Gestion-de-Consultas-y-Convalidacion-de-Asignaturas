"""
Endpoints REST para CAMPUS
Sistema: SGSCT
"""
from typing import Annotated
from fastapi import APIRouter, Depends, status, Query
from sqlalchemy.orm import Session
from src.database.sessions import get_db
from src.modules.catalog.campus.service import CampusService
from src.modules.catalog.campus.schemas import CampusCreate, CampusUpdate
from src.modules.auth.dependencies import require_admin
from src.modules.users.models import User
from src.core.responses import success_response, paginated_response

router = APIRouter(prefix="/campus", tags=["Campus"])


@router.get("", status_code=status.HTTP_200_OK, summary="Listar campus")
async def get_campus_list(
    page: Annotated[int, Query(ge=1)] = 1,
    page_size: Annotated[int, Query(ge=1, le=100)] = 20,
    db: Annotated[Session, Depends(get_db)] = None
):
    service = CampusService(db)
    result = service.get_all(page=page, page_size=page_size)
    
    return paginated_response(
        data=[item.model_dump() for item in result["items"]],
        page=result["page"],
        page_size=result["page_size"],
        total=result["total"]
    )


@router.get("/{campus_id}", status_code=status.HTTP_200_OK, summary="Obtener campus")
async def get_campus(
    campus_id: int,
    db: Annotated[Session, Depends(get_db)] = None
):
    service = CampusService(db)
    campus = service.get_by_id(campus_id)
    
    return success_response(
        data=campus.model_dump(),
        message="Campus obtenido exitosamente"
    )


@router.post("", status_code=status.HTTP_201_CREATED, summary="Crear campus (admin)")
async def create_campus(
    data: CampusCreate,
    db: Annotated[Session, Depends(get_db)] = None,
    admin: Annotated[User, Depends(require_admin)] = None
):
    service = CampusService(db)
    campus = service.create(data)
    
    return success_response(
        data=campus.model_dump(),
        message="Campus creado exitosamente"
    )


@router.put("/{campus_id}", status_code=status.HTTP_200_OK, summary="Actualizar campus (admin)")
async def update_campus(
    campus_id: int,
    data: CampusUpdate,
    db: Annotated[Session, Depends(get_db)] = None,
    admin: Annotated[User, Depends(require_admin)] = None
):
    service = CampusService(db)
    campus = service.update(campus_id, data)
    
    return success_response(
        data=campus.model_dump(),
        message="Campus actualizado exitosamente"
    )


@router.delete("/{campus_id}", status_code=status.HTTP_200_OK, summary="Eliminar campus (admin)")
async def delete_campus(
    campus_id: int,
    db: Annotated[Session, Depends(get_db)] = None,
    admin: Annotated[User, Depends(require_admin)] = None
):
    service = CampusService(db)
    service.delete(campus_id)
    
    return success_response(
        data=None,
        message="Campus eliminado exitosamente"
    )
