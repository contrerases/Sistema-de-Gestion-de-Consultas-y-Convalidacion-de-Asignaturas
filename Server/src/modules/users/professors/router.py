"""
Router del submódulo Professors
Sistema: SGSCT
"""
from fastapi import APIRouter, Depends, status
from sqlalchemy.orm import Session
from typing import Dict
from src.database.sessions import get_db
from src.modules.users.professors.service import ProfessorService
from src.modules.users.professors.schemas import (
    ProfessorCreate,
    ProfessorUpdate,
    ProfessorResponse
)
from src.modules.users.models import User
from src.modules.auth.dependencies import get_current_user
from src.modules.auth.schemas import MessageResponse
from src.monitoring.logging import get_logger

logger = get_logger(__name__)

router = APIRouter(
    prefix="/professors",
    tags=["Professors"]
)


@router.get("", response_model=Dict)
def get_all_professors(
    page: int = 1,
    page_size: int = 50,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """Obtiene todos los profesores"""
    service = ProfessorService(db)
    return service.get_all(page=page, page_size=page_size)


@router.get("/{professor_id}", response_model=ProfessorResponse)
def get_professor_by_id(
    professor_id: int,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """Obtiene un profesor por ID"""
    service = ProfessorService(db)
    return service.get_by_id(professor_id)


@router.get("/email/{email}", response_model=ProfessorResponse)
def get_professor_by_email(
    email: str,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """Obtiene un profesor por email"""
    service = ProfessorService(db)
    return service.get_by_email(email)


@router.post("", response_model=ProfessorResponse, status_code=status.HTTP_201_CREATED)
def create_professor(
    data: ProfessorCreate,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """Crea un nuevo profesor"""
    service = ProfessorService(db)
    return service.create(data)


@router.put("/{professor_id}", response_model=ProfessorResponse)
def update_professor(
    professor_id: int,
    data: ProfessorUpdate,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """Actualiza un profesor"""
    service = ProfessorService(db)
    return service.update(professor_id, data)


@router.delete("/{professor_id}", response_model=MessageResponse)
def delete_professor(
    professor_id: int,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """Elimina un profesor"""
    service = ProfessorService(db)
    service.delete(professor_id)
    return MessageResponse(message="Profesor eliminado exitosamente")
