"""
Router del submódulo Administrators
Sistema: SGSCT
"""

from fastapi import APIRouter, Depends, status
from sqlalchemy.orm import Session
from typing import Optional
from src.database.sessions import get_db
from src.modules.users.administrators.services import AdministratorServices
from src.modules.users.administrators.schemas import (
    AdministratorCreate,
    AdministratorUpdate,
    AdministratorResponse,
)
from src.modules.users.base.models import User
from src.modules.auth.dependencies import require_admin
from src.core.responses import PaginatedResponse
from src.monitoring.logging import get_logger

logger = get_logger(__name__)

router = APIRouter(prefix="/administrators", tags=["Administrators"])


@router.get("", response_model=PaginatedResponse[AdministratorResponse])
def get_all_administrators(
    skip: int = 0,
    limit: int = 50,
    campus_id: Optional[int] = None,
    db: Session = Depends(get_db),
    current_user: User = Depends(require_admin),
):
    """Obtiene todos los administradores"""
    service = AdministratorServices(db)
    return service.get_all(skip=skip, limit=limit, campus_id=campus_id)


@router.get("/{admin_id}", response_model=AdministratorResponse)
def get_administrator_by_id(
    admin_id: int,
    db: Session = Depends(get_db),
    current_user: User = Depends(require_admin),
):
    """Obtiene un administrador por ID"""
    service = AdministratorServices(db)
    return service.get_by_id(admin_id)


@router.post(
    "", response_model=AdministratorResponse, status_code=status.HTTP_201_CREATED
)
def create_administrator(
    data: AdministratorCreate,
    db: Session = Depends(get_db),
    current_user: User = Depends(require_admin),
):
    """Crea un nuevo administrador"""
    service = AdministratorServices(db)
    return service.create(data)


@router.put("/{admin_id}", response_model=AdministratorResponse)
def update_administrator(
    admin_id: int,
    data: AdministratorUpdate,
    db: Session = Depends(get_db),
    current_user: User = Depends(require_admin),
):
    """Actualiza un administrador"""
    service = AdministratorServices(db)
    return service.update(admin_id, data)


@router.delete("/{admin_id}")
def delete_administrator(
    admin_id: int,
    db: Session = Depends(get_db),
    current_user: User = Depends(require_admin),
):
    """Elimina un administrador"""
    service = AdministratorServices(db)
    service.delete(admin_id)
    return {"message": "Administrador eliminado exitosamente"}
