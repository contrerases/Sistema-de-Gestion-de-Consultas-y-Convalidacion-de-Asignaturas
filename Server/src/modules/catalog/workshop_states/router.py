"""
Endpoints REST para WORKSHOP_STATES
Sistema: SGSCT
"""
from typing import Annotated
from fastapi import APIRouter, Depends, status, Query
from sqlalchemy.orm import Session
from src.database.sessions import get_db
from src.modules.catalog.workshop_states.service import WorkshopStateService
from src.modules.catalog.workshop_states.schemas import WorkshopStateCreate, WorkshopStateUpdate
from src.modules.auth.dependencies import require_admin
from src.modules.users.models import User
from src.core.responses import success_response, paginated_response

router = APIRouter(prefix="/workshop-states", tags=["Estados de Talleres"])


@router.get("", status_code=status.HTTP_200_OK, summary="Listar estados de talleres")
async def get_workshop_states(
    page: Annotated[int, Query(ge=1)] = 1,
    page_size: Annotated[int, Query(ge=1, le=100)] = 20,
    db: Annotated[Session, Depends(get_db)] = None
):
    service = WorkshopStateService(db)
    result = service.get_all(page=page, page_size=page_size)
    
    return paginated_response(
        data=[item.model_dump() for item in result["items"]],
        page=result["page"],
        page_size=result["page_size"],
        total=result["total"]
    )


@router.get("/{state_id}", status_code=status.HTTP_200_OK, summary="Obtener estado de taller")
async def get_workshop_state(
    state_id: int,
    db: Annotated[Session, Depends(get_db)] = None
):
    service = WorkshopStateService(db)
    workshop_state = service.get_by_id(state_id)
    
    return success_response(
        data=workshop_state.model_dump(),
        message="Estado de taller obtenido exitosamente"
    )


@router.post("", status_code=status.HTTP_201_CREATED, summary="Crear estado de taller (admin)")
async def create_workshop_state(
    data: WorkshopStateCreate,
    db: Annotated[Session, Depends(get_db)] = None,
    admin: Annotated[User, Depends(require_admin)] = None
):
    service = WorkshopStateService(db)
    workshop_state = service.create(data)
    
    return success_response(
        data=workshop_state.model_dump(),
        message="Estado de taller creado exitosamente"
    )


@router.put("/{state_id}", status_code=status.HTTP_200_OK, summary="Actualizar estado de taller (admin)")
async def update_workshop_state(
    state_id: int,
    data: WorkshopStateUpdate,
    db: Annotated[Session, Depends(get_db)] = None,
    admin: Annotated[User, Depends(require_admin)] = None
):
    service = WorkshopStateService(db)
    workshop_state = service.update(state_id, data)
    
    return success_response(
        data=workshop_state.model_dump(),
        message="Estado de taller actualizado exitosamente"
    )


@router.delete("/{state_id}", status_code=status.HTTP_200_OK, summary="Eliminar estado de taller (admin)")
async def delete_workshop_state(
    state_id: int,
    db: Annotated[Session, Depends(get_db)] = None,
    admin: Annotated[User, Depends(require_admin)] = None
):
    service = WorkshopStateService(db)
    service.delete(state_id)
    
    return success_response(
        data=None,
        message="Estado de taller eliminado exitosamente"
    )
