"""
Endpoints REST para DEPARTMENTS
Sistema: SGSCT
"""
from typing import Annotated
from fastapi import APIRouter, Depends, status, Query
from sqlalchemy.orm import Session
from src.database.sessions import get_db
from src.modules.academic.departments.service import DepartmentService
from src.modules.academic.departments.schemas import (
    DepartmentCreate,
    DepartmentUpdate,
    DepartmentResponse
)
from src.modules.auth.dependencies import require_admin
from src.modules.auth.models import User
from src.core.responses import success_response, paginated_response

router = APIRouter(prefix="/departments", tags=["Departamentos Académicos"])


@router.get(
    "",
    status_code=status.HTTP_200_OK,
    summary="Listar departamentos",
    description="Obtiene lista paginada de todos los departamentos"
)
async def get_departments(
    page: Annotated[int, Query(ge=1)] = 1,
    page_size: Annotated[int, Query(ge=1, le=100)] = 20,
    db: Annotated[Session, Depends(get_db)] = None
):
    """Lista todos los departamentos con paginación"""
    service = DepartmentService(db)
    result = service.get_all(page=page, page_size=page_size)
    
    return paginated_response(
        data=[item.model_dump() for item in result["items"]],
        page=result["page"],
        page_size=result["page_size"],
        total=result["total"]
    )


@router.get(
    "/{department_id}",
    status_code=status.HTTP_200_OK,
    summary="Obtener departamento",
    description="Obtiene un departamento por ID"
)
async def get_department(
    department_id: int,
    db: Annotated[Session, Depends(get_db)] = None
):
    """Obtiene un departamento específico"""
    service = DepartmentService(db)
    department = service.get_by_id(department_id)
    
    return success_response(
        data=department.model_dump(),
        message="Departamento obtenido exitosamente"
    )


@router.post(
    "",
    status_code=status.HTTP_201_CREATED,
    summary="Crear departamento",
    description="Crea un nuevo departamento (solo administradores)"
)
async def create_department(
    data: DepartmentCreate,
    db: Annotated[Session, Depends(get_db)] = None,
    admin: Annotated[User, Depends(require_admin)] = None
):
    """Crea un nuevo departamento"""
    service = DepartmentService(db)
    department = service.create(data)
    
    return success_response(
        data=department.model_dump(),
        message="Departamento creado exitosamente"
    )


@router.put(
    "/{department_id}",
    status_code=status.HTTP_200_OK,
    summary="Actualizar departamento",
    description="Actualiza un departamento existente (solo administradores)"
)
async def update_department(
    department_id: int,
    data: DepartmentUpdate,
    db: Annotated[Session, Depends(get_db)] = None,
    admin: Annotated[User, Depends(require_admin)] = None
):
    """Actualiza un departamento"""
    service = DepartmentService(db)
    department = service.update(department_id, data)
    
    return success_response(
        data=department.model_dump(),
        message="Departamento actualizado exitosamente"
    )


@router.delete(
    "/{department_id}",
    status_code=status.HTTP_200_OK,
    summary="Eliminar departamento",
    description="Elimina un departamento (solo administradores)"
)
async def delete_department(
    department_id: int,
    db: Annotated[Session, Depends(get_db)] = None,
    admin: Annotated[User, Depends(require_admin)] = None
):
    """Elimina un departamento"""
    service = DepartmentService(db)
    service.delete(department_id)
    
    return success_response(
        data=None,
        message="Departamento eliminado exitosamente"
    )
