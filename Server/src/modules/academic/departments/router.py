"""
Endpoints REST para DEPARTMENTS
Sistema: SGSCT
"""

from typing import Annotated
from fastapi import APIRouter, Depends, status, Query
from sqlalchemy.orm import Session
from src.database.sessions import get_db
from src.modules.academic.departments.schemas import (
    DepartmentCreate,
    DepartmentUpdate,
    DepartmentResponse,
)
from src.modules.academic.departments.services import DepartmentServices

from src.core.responses import PaginatedResponse
from src.modules.auth.dependencies import require_admin
from src.modules.users.base.models import User


router = APIRouter(prefix="/departments", tags=["Departamentos Académicos"])


@router.get(
    "",
    status_code=status.HTTP_200_OK,
    summary="Listar departamentos",
    description="Obtiene lista paginada de todos los departamentos",
    response_model=PaginatedResponse[DepartmentResponse],
)
async def get_departments(
    db: Annotated[Session, Depends(get_db)],
    page: Annotated[int, Query(ge=1)] = 1,
    page_size: Annotated[int, Query(ge=1, le=100)] = 20,
):
    """Lista todos los departamentos con paginación"""
    service = DepartmentServices(db)
    result = service.get_all(page=page, page_size=page_size)
    return PaginatedResponse(
        total=result["total"],
        items=[item.model_dump() for item in result["items"]],
        skip=(page - 1) * page_size,
        limit=page_size,
    )


@router.get(
    "/{department_id}",
    status_code=status.HTTP_200_OK,
    summary="Obtener departamento",
    description="Obtiene un departamento por ID",
)
async def get_department(department_id: int, db: Annotated[Session, Depends(get_db)]):
    """Obtiene un departamento específico"""
    service = DepartmentServices(db)
    department = service.get_by_id(department_id)
    return department.model_dump()


@router.post(
    "",
    status_code=status.HTTP_201_CREATED,
    summary="Crear departamento",
    description="Crea un nuevo departamento (solo administradores)",
)
async def create_department(
    db: Annotated[Session, Depends(get_db)],
    admin: Annotated[User, Depends(require_admin)],
    data: DepartmentCreate,
):
    """Crea un nuevo departamento"""
    service = DepartmentServices(db)
    department = service.create(data)
    return department.model_dump()


@router.put(
    "/{department_id}",
    status_code=status.HTTP_200_OK,
    summary="Actualizar departamento",
    description="Actualiza un departamento existente (solo administradores)",
)
async def update_department(
    department_id: int,
    db: Annotated[Session, Depends(get_db)],
    admin: Annotated[User, Depends(require_admin)],
    data: DepartmentUpdate,
):
    """Actualiza un departamento"""
    service = DepartmentServices(db)
    department = service.update(department_id, data)
    return department.model_dump()


@router.delete(
    "/{department_id}",
    status_code=status.HTTP_200_OK,
    summary="Eliminar departamento",
    description="Elimina un departamento (solo administradores)",
)
async def delete_department(
    department_id: int,
    db: Annotated[Session, Depends(get_db)],
    admin: Annotated[User, Depends(require_admin)],
):
    """Elimina un departamento"""
    service = DepartmentServices(db)
    service.delete(department_id)
    return {"detail": "Departamento eliminado exitosamente"}
