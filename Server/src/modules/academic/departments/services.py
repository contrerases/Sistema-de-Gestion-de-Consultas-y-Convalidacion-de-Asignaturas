"""
Servicio de lógica de negocio para DEPARTMENTS
Sistema: SGSCT
"""

from typing import Dict, Any
from sqlalchemy.orm import Session
from fastapi import HTTPException, status
from src.modules.academic.departments.repository import DepartmentRepository
from src.modules.academic.departments.schemas import (
    DepartmentCreate,
    DepartmentUpdate,
    DepartmentResponse,
)

from src.monitoring.logging import get_logger

logger = get_logger(__name__)


class DepartmentServices:
    """Servicio para gestión de departamentos"""

    def __init__(self, db: Session):
        self.db = db
        self.repository = DepartmentRepository(db)

    def get_all(self, page: int = 1, page_size: int = 20) -> Dict[str, Any]:
        """Obtiene todos los departamentos paginados"""
        skip = (page - 1) * page_size
        departments = self.repository.get_all(skip=skip, limit=page_size)
        total = self.repository.count()

        return {
            "items": [DepartmentResponse.model_validate(dept) for dept in departments],
            "page": page,
            "page_size": page_size,
            "total": total,
        }

    def get_by_id(self, department_id: int) -> DepartmentResponse:
        """Obtiene un departamento por ID"""
        department = self.repository.get_by_id(department_id)
        if not department:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail="Departamento no encontrado",
            )
        return DepartmentResponse.model_validate(department)

    def create(self, data: DepartmentCreate) -> DepartmentResponse:
        """Crea un nuevo departamento"""
        # Verificar que no exista con el mismo nombre
        existing = self.repository.get_by_name(data.name)
        if existing:
            raise HTTPException(
                status_code=status.HTTP_409_CONFLICT,
                detail="Ya existe un departamento con ese nombre",
            )
        department = self.repository.create(name=data.name)
        logger.info(f"Departamento creado: {data.name} (ID: {department.id})")
        return DepartmentResponse.model_validate(department)

    def update(self, department_id: int, data: DepartmentUpdate) -> DepartmentResponse:
        """Actualiza un departamento"""
        # Verificar que existe
        existing = self.repository.get_by_id(department_id)
        if not existing:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail="Departamento no encontrado",
            )
        # Verificar que el nuevo nombre no esté en uso por otro departamento
        name_check = self.repository.get_by_name(data.name)
        if name_check is not None and getattr(name_check, "id", None) != department_id:
            raise HTTPException(
                status_code=status.HTTP_409_CONFLICT,
                detail="Ya existe un departamento con ese nombre",
            )
        department = self.repository.update(department_id, data.name)
        logger.info(f"Departamento actualizado: ID {department_id} -> {data.name}")
        return DepartmentResponse.model_validate(department)

    def delete(self, department_id: int) -> None:
        """Elimina un departamento"""
        existing = self.repository.get_by_id(department_id)
        if not existing:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail="Departamento no encontrado",
            )
        logger.warning(f"Departamento eliminado: {existing.name} (ID: {department_id})")
        success = self.repository.delete(department_id)
        if not success:
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail="No se pudo eliminar el departamento",
            )
