"""
Endpoints REST para CONVALIDATION_STATES
Sistema: SGSCT
"""
from typing import Annotated
from fastapi import APIRouter, Depends, status, Query
from sqlalchemy.orm import Session
from src.database.sessions import get_db
from src.modules.catalog.convalidation_states.service import ConvalidationStateService
from src.modules.catalog.convalidation_states.schemas import ConvalidationStateCreate, ConvalidationStateUpdate
from src.modules.auth.dependencies import require_admin
from src.modules.auth.models import User
from src.core.responses import success_response, paginated_response

router = APIRouter(prefix="/convalidation-states", tags=["Estados de Convalidación"])


@router.get("", status_code=status.HTTP_200_OK, summary="Listar estados de convalidación")
async def get_convalidation_states(
    page: Annotated[int, Query(ge=1)] = 1,
    page_size: Annotated[int, Query(ge=1, le=100)] = 20,
    db: Annotated[Session, Depends(get_db)] = None
):
    service = ConvalidationStateService(db)
    result = service.get_all(page=page, page_size=page_size)
    
    return paginated_response(
        data=[item.model_dump() for item in result["items"]],
        page=result["page"],
        page_size=result["page_size"],
        total=result["total"]
    )


@router.get("/{state_id}", status_code=status.HTTP_200_OK, summary="Obtener estado de convalidación")
async def get_convalidation_state(
    state_id: int,
    db: Annotated[Session, Depends(get_db)] = None
):
    service = ConvalidationStateService(db)
    convalidation_state = service.get_by_id(state_id)
    
    return success_response(
        data=convalidation_state.model_dump(),
        message="Estado de convalidación obtenido exitosamente"
    )


@router.post("", status_code=status.HTTP_201_CREATED, summary="Crear estado de convalidación (admin)")
async def create_convalidation_state(
    data: ConvalidationStateCreate,
    db: Annotated[Session, Depends(get_db)] = None,
    admin: Annotated[User, Depends(require_admin)] = None
):
    service = ConvalidationStateService(db)
    convalidation_state = service.create(data)
    
    return success_response(
        data=convalidation_state.model_dump(),
        message="Estado de convalidación creado exitosamente"
    )


@router.put("/{state_id}", status_code=status.HTTP_200_OK, summary="Actualizar estado de convalidación (admin)")
async def update_convalidation_state(
    state_id: int,
    data: ConvalidationStateUpdate,
    db: Annotated[Session, Depends(get_db)] = None,
    admin: Annotated[User, Depends(require_admin)] = None
):
    service = ConvalidationStateService(db)
    convalidation_state = service.update(state_id, data)
    
    return success_response(
        data=convalidation_state.model_dump(),
        message="Estado de convalidación actualizado exitosamente"
    )


@router.delete("/{state_id}", status_code=status.HTTP_200_OK, summary="Eliminar estado de convalidación (admin)")
async def delete_convalidation_state(
    state_id: int,
    db: Annotated[Session, Depends(get_db)] = None,
    admin: Annotated[User, Depends(require_admin)] = None
):
    service = ConvalidationStateService(db)
    service.delete(state_id)
    
    return success_response(
        data=None,
        message="Estado de convalidación eliminado exitosamente"
    )
