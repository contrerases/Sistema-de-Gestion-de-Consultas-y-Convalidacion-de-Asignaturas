"""
Endpoints REST para SUBJECTS
Sistema: SGSCT
"""

from typing import Annotated
from fastapi import APIRouter, Depends, status, Query
from sqlalchemy.orm import Session
from src.database.sessions import get_db
from src.modules.academic.subjects.schemas import (
    SubjectCreate,
    SubjectUpdate,
    SubjectResponse,
)
from src.modules.academic.subjects.services import SubjectServices
from src.modules.auth.dependencies import require_admin
from src.modules.users.base.models import User
from src.core.responses import PaginatedResponse

router = APIRouter(prefix="/subjects", tags=["Asignaturas"])


@router.get(
    "",
    status_code=status.HTTP_200_OK,
    summary="Listar asignaturas",
    description="Obtiene lista paginada de todas las asignaturas",
    response_model=PaginatedResponse[SubjectResponse],
)
async def get_subjects(
    db: Annotated[Session, Depends(get_db)],
    page: Annotated[int, Query(ge=1)] = 1,
    page_size: Annotated[int, Query(ge=1, le=100)] = 20,
):
    """Lista todas las asignaturas con paginación"""
    service = SubjectServices(db)
    result = service.get_all(page=page, page_size=page_size)
    return PaginatedResponse(
        total=result["total"],
        items=[item.model_dump() for item in result["items"]],
        skip=(page - 1) * page_size,
        limit=page_size,
    )


@router.get(
    "/department/{department_id}",
    status_code=status.HTTP_200_OK,
    summary="Listar asignaturas por departamento",
    description="Obtiene asignaturas de un departamento específico",
)
async def get_subjects_by_department(
    department_id: int,
    db: Annotated[Session, Depends(get_db)],
    page: Annotated[int, Query(ge=1)] = 1,
    page_size: Annotated[int, Query(ge=1, le=100)] = 20,
):
    """Lista asignaturas de un departamento"""
    service = SubjectServices(db)
    result = service.get_by_department(department_id, page=page, page_size=page_size)
    return PaginatedResponse(
        total=result["total"],
        items=[item.model_dump() for item in result["items"]],
        skip=(page - 1) * page_size,
        limit=page_size,
    )


@router.get(
    "/{subject_id}",
    status_code=status.HTTP_200_OK,
    summary="Obtener asignatura",
    description="Obtiene una asignatura por ID",
)
async def get_subject(
    subject_id: int,
    db: Annotated[Session, Depends(get_db)],
):
    """Obtiene una asignatura específica"""
    service = SubjectServices(db)
    subject = service.get_by_id(subject_id)
    return subject.model_dump()


@router.post(
    "",
    status_code=status.HTTP_201_CREATED,
    summary="Crear asignatura",
    description="Crea una nueva asignatura (solo administradores)",
)
async def create_subject(
    db: Annotated[Session, Depends(get_db)],
    admin: Annotated[User, Depends(require_admin)],
    data: SubjectCreate,
):
    """Crea una nueva asignatura"""
    service = SubjectServices(db)
    subject = service.create(data)
    return subject.model_dump()


@router.put(
    "/{subject_id}",
    status_code=status.HTTP_200_OK,
    summary="Actualizar asignatura",
    description="Actualiza una asignatura existente (solo administradores)",
)
async def update_subject(
    subject_id: int,
    db: Annotated[Session, Depends(get_db)],
    admin: Annotated[User, Depends(require_admin)],
    data: SubjectUpdate,
):
    """Actualiza una asignatura"""
    service = SubjectServices(db)
    subject = service.update(subject_id, data)
    return subject.model_dump()


@router.delete(
    "/{subject_id}",
    status_code=status.HTTP_200_OK,
    summary="Eliminar asignatura",
    description="Elimina una asignatura (solo administradores)",
)
async def delete_subject(
    subject_id: int,
    db: Annotated[Session, Depends(get_db)],
    admin: Annotated[User, Depends(require_admin)],
):
    """Elimina una asignatura"""
    service = SubjectServices(db)
    service.delete(subject_id)
    return {"detail": "Asignatura eliminada exitosamente"}
