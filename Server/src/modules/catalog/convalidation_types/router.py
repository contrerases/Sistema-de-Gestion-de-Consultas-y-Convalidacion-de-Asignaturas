"""
Endpoints REST para CONVALIDATION_TYPES
Sistema: SGSCT
"""
from typing import Annotated
from fastapi import APIRouter, Depends, status, Query
from sqlalchemy.orm import Session
from src.database.sessions import get_db
from src.modules.catalog.convalidation_types.service import ConvalidationTypeService
from src.modules.catalog.convalidation_types.schemas import ConvalidationTypeCreate, ConvalidationTypeUpdate
from src.modules.auth.dependencies import require_admin
from src.modules.auth.models import User
from src.core.responses import success_response, paginated_response

router = APIRouter(prefix="/convalidation-types", tags=["Tipos de Convalidación"])


@router.get("", status_code=status.HTTP_200_OK, summary="Listar tipos de convalidación")
async def get_convalidation_types(
    page: Annotated[int, Query(ge=1)] = 1,
    page_size: Annotated[int, Query(ge=1, le=100)] = 20,
    db: Annotated[Session, Depends(get_db)] = None
):
    service = ConvalidationTypeService(db)
    result = service.get_all(page=page, page_size=page_size)
    
    return paginated_response(
        data=[item.model_dump() for item in result["items"]],
        page=result["page"],
        page_size=result["page_size"],
        total=result["total"]
    )


@router.get("/{type_id}", status_code=status.HTTP_200_OK, summary="Obtener tipo de convalidación")
async def get_convalidation_type(
    type_id: int,
    db: Annotated[Session, Depends(get_db)] = None
):
    service = ConvalidationTypeService(db)
    convalidation_type = service.get_by_id(type_id)
    
    return success_response(
        data=convalidation_type.model_dump(),
        message="Tipo de convalidación obtenido exitosamente"
    )


@router.post("", status_code=status.HTTP_201_CREATED, summary="Crear tipo de convalidación (admin)")
async def create_convalidation_type(
    data: ConvalidationTypeCreate,
    db: Annotated[Session, Depends(get_db)] = None,
    admin: Annotated[User, Depends(require_admin)] = None
):
    service = ConvalidationTypeService(db)
    convalidation_type = service.create(data)
    
    return success_response(
        data=convalidation_type.model_dump(),
        message="Tipo de convalidación creado exitosamente"
    )


@router.put("/{type_id}", status_code=status.HTTP_200_OK, summary="Actualizar tipo de convalidación (admin)")
async def update_convalidation_type(
    type_id: int,
    data: ConvalidationTypeUpdate,
    db: Annotated[Session, Depends(get_db)] = None,
    admin: Annotated[User, Depends(require_admin)] = None
):
    service = ConvalidationTypeService(db)
    convalidation_type = service.update(type_id, data)
    
    return success_response(
        data=convalidation_type.model_dump(),
        message="Tipo de convalidación actualizado exitosamente"
    )


@router.delete("/{type_id}", status_code=status.HTTP_200_OK, summary="Eliminar tipo de convalidación (admin)")
async def delete_convalidation_type(
    type_id: int,
    db: Annotated[Session, Depends(get_db)] = None,
    admin: Annotated[User, Depends(require_admin)] = None
):
    service = ConvalidationTypeService(db)
    service.delete(type_id)
    
    return success_response(
        data=None,
        message="Tipo de convalidación eliminado exitosamente"
    )
