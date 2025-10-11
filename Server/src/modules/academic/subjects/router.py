"""
Endpoints REST para SUBJECTS
Sistema: SGSCT
"""
from typing import Annotated
from fastapi import APIRouter, Depends, status, Query
from sqlalchemy.orm import Session
from src.database.sessions import get_db
from src.modules.academic.subjects.service import SubjectService
from src.modules.academic.subjects.schemas import (
    SubjectCreate,
    SubjectUpdate,
    SubjectResponse
)
from src.modules.auth.dependencies import require_admin
from src.modules.users.models import User
from src.core.responses import success_response, paginated_response

router = APIRouter(prefix="/subjects", tags=["Asignaturas"])


@router.get(
    "",
    status_code=status.HTTP_200_OK,
    summary="Listar asignaturas",
    description="Obtiene lista paginada de todas las asignaturas"
)
async def get_subjects(
    page: Annotated[int, Query(ge=1)] = 1,
    page_size: Annotated[int, Query(ge=1, le=100)] = 20,
    db: Annotated[Session, Depends(get_db)] = None
):
    """Lista todas las asignaturas con paginación"""
    service = SubjectService(db)
    result = service.get_all(page=page, page_size=page_size)
    
    return paginated_response(
        data=[item.model_dump() for item in result["items"]],
        page=result["page"],
        page_size=result["page_size"],
        total=result["total"]
    )


@router.get(
    "/department/{department_id}",
    status_code=status.HTTP_200_OK,
    summary="Listar asignaturas por departamento",
    description="Obtiene asignaturas de un departamento específico"
)
async def get_subjects_by_department(
    department_id: int,
    page: Annotated[int, Query(ge=1)] = 1,
    page_size: Annotated[int, Query(ge=1, le=100)] = 20,
    db: Annotated[Session, Depends(get_db)] = None
):
    """Lista asignaturas de un departamento"""
    service = SubjectService(db)
    result = service.get_by_department(department_id, page=page, page_size=page_size)
    
    return paginated_response(
        data=[item.model_dump() for item in result["items"]],
        page=result["page"],
        page_size=result["page_size"],
        total=result["total"]
    )


@router.get(
    "/{subject_id}",
    status_code=status.HTTP_200_OK,
    summary="Obtener asignatura",
    description="Obtiene una asignatura por ID"
)
async def get_subject(
    subject_id: int,
    db: Annotated[Session, Depends(get_db)] = None
):
    """Obtiene una asignatura específica"""
    service = SubjectService(db)
    subject = service.get_by_id(subject_id)
    
    return success_response(
        data=subject.model_dump(),
        message="Asignatura obtenida exitosamente"
    )


@router.post(
    "",
    status_code=status.HTTP_201_CREATED,
    summary="Crear asignatura",
    description="Crea una nueva asignatura (solo administradores)"
)
async def create_subject(
    data: SubjectCreate,
    db: Annotated[Session, Depends(get_db)] = None,
    admin: Annotated[User, Depends(require_admin)] = None
):
    """Crea una nueva asignatura"""
    service = SubjectService(db)
    subject = service.create(data)
    
    return success_response(
        data=subject.model_dump(),
        message="Asignatura creada exitosamente"
    )


@router.put(
    "/{subject_id}",
    status_code=status.HTTP_200_OK,
    summary="Actualizar asignatura",
    description="Actualiza una asignatura existente (solo administradores)"
)
async def update_subject(
    subject_id: int,
    data: SubjectUpdate,
    db: Annotated[Session, Depends(get_db)] = None,
    admin: Annotated[User, Depends(require_admin)] = None
):
    """Actualiza una asignatura"""
    service = SubjectService(db)
    subject = service.update(subject_id, data)
    
    return success_response(
        data=subject.model_dump(),
        message="Asignatura actualizada exitosamente"
    )


@router.delete(
    "/{subject_id}",
    status_code=status.HTTP_200_OK,
    summary="Eliminar asignatura",
    description="Elimina una asignatura (solo administradores)"
)
async def delete_subject(
    subject_id: int,
    db: Annotated[Session, Depends(get_db)] = None,
    admin: Annotated[User, Depends(require_admin)] = None
):
    """Elimina una asignatura"""
    service = SubjectService(db)
    service.delete(subject_id)
    
    return success_response(
        data=None,
        message="Asignatura eliminada exitosamente"
    )
