"""
Router del submódulo Students
Sistema: SGSCT
"""

from fastapi import APIRouter, Depends, status
from sqlalchemy.orm import Session
from typing import Dict, Optional
from src.database.sessions import get_db
from src.modules.users.students.services import StudentServices
from src.modules.users.students.schemas import (
    StudentCreate,
    StudentUpdate,
    StudentResponse,
)
from src.modules.users.base.models import User


from src.monitoring.logging import get_logger
from src.modules.auth.dependencies import get_current_user

logger = get_logger(__name__)

router = APIRouter(prefix="/students", tags=["Students"])


@router.get("", response_model=Dict)
def get_all_students(
    page: int = 1,
    page_size: int = 50,
    campus_id: Optional[int] = None,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    """Obtiene todos los estudiantes"""
    service = StudentServices(db)
    return service.get_all(page=page, page_size=page_size, campus_id=campus_id)


@router.get("/{student_id}", response_model=StudentResponse)
def get_student_by_id(
    student_id: int,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    """Obtiene un estudiante por ID"""
    service = StudentServices(db)
    return service.get_by_id(student_id)


@router.get("/rut/{rut}", response_model=StudentResponse)
def get_student_by_rut(
    rut: str,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    """Obtiene un estudiante por RUT"""
    service = StudentServices(db)
    return service.get_by_rut(rut)


@router.get("/rol/{rol}", response_model=StudentResponse)
def get_student_by_rol(
    rol: str,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    """Obtiene un estudiante por ROL"""
    service = StudentServices(db)
    return service.get_by_rol(rol)


@router.post("", response_model=StudentResponse, status_code=status.HTTP_201_CREATED)
def create_student(
    data: StudentCreate,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    """Crea un nuevo estudiante"""
    service = StudentServices(db)
    return service.create(data)


@router.put("/{student_id}", response_model=StudentResponse)
def update_student(
    student_id: int,
    data: StudentUpdate,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    """Actualiza un estudiante"""
    service = StudentServices(db)
    return service.update(student_id, data)


@router.delete("/{student_id}", response_model=dict)
def delete_student(
    student_id: int,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    """Elimina un estudiante"""
    service = StudentServices(db)
    service.delete(student_id)
    return {"message": "Estudiante eliminado exitosamente"}
