"""
Router del submódulo Administrators
Sistema: SGSCT
"""
from fastapi import APIRouter, Depends, status
from sqlalchemy.orm import Session
from typing import Dict
from src.database.sessions import get_db
from src.modules.users.administrators.service import AdministratorService
from src.modules.users.administrators.schemas import (
    AdministratorCreate,
    AdministratorUpdate,
    AdministratorResponse
)
from src.modules.users.models import User
from src.modules.auth.dependencies import get_current_user
from src.modules.auth.schemas import MessageResponse
from src.monitoring.logging import get_logger

logger = get_logger(__name__)

router = APIRouter(
    prefix="/administrators",
    tags=["Administrators"]
)


@router.get("", response_model=Dict)
def get_all_administrators(
    page: int = 1,
    page_size: int = 50,
    campus_id: int = None,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """Obtiene todos los administradores"""
    service = AdministratorService(db)
    return service.get_all(page=page, page_size=page_size, campus_id=campus_id)


@router.get("/{admin_id}", response_model=AdministratorResponse)
def get_administrator_by_id(
    admin_id: int,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """Obtiene un administrador por ID"""
    service = AdministratorService(db)
    return service.get_by_id(admin_id)


@router.post("", response_model=AdministratorResponse, status_code=status.HTTP_201_CREATED)
def create_administrator(
    data: AdministratorCreate,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """Crea un nuevo administrador"""
    service = AdministratorService(db)
    return service.create(data)


@router.put("/{admin_id}", response_model=AdministratorResponse)
def update_administrator(
    admin_id: int,
    data: AdministratorUpdate,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """Actualiza un administrador"""
    service = AdministratorService(db)
    return service.update(admin_id, data)


@router.delete("/{admin_id}", response_model=MessageResponse)
def delete_administrator(
    admin_id: int,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """Elimina un administrador"""
    service = AdministratorService(db)
    service.delete(admin_id)
    return MessageResponse(message="Administrador eliminado exitosamente")
