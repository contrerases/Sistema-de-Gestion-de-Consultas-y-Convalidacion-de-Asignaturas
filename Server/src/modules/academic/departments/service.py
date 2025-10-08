"""
Servicio de lógica de negocio para DEPARTMENTS
Sistema: SGSCT
"""
import logging
from typing import List, Dict, Any
from sqlalchemy.orm import Session
from src.modules.academic.departments.repositories import DepartmentRepository
from src.modules.academic.departments.schemas import DepartmentCreate, DepartmentUpdate, DepartmentResponse
from src.core.exceptions import NotFoundException, ValidationException

logger = logging.getLogger(__name__)


class DepartmentService:
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
            "total": total
        }
    
    def get_by_id(self, department_id: int) -> DepartmentResponse:
        """Obtiene un departamento por ID"""
        department = self.repository.get_by_id(department_id)
        
        if not department:
            raise NotFoundException(f"Departamento con ID {department_id} no encontrado")
        
        return DepartmentResponse.model_validate(department)
    
    def create(self, data: DepartmentCreate) -> DepartmentResponse:
        """Crea un nuevo departamento"""
        # Verificar que no exista con el mismo nombre
        existing = self.repository.get_by_name(data.name)
        if existing:
            raise ValidationException(
                message="Ya existe un departamento con ese nombre",
                details=[{"field": "name", "message": "Nombre duplicado"}]
            )
        
        department = self.repository.create(name=data.name)
        logger.info(f"Departamento creado: {data.name} (ID: {department.id})")
        return DepartmentResponse.model_validate(department)
    
    def update(self, department_id: int, data: DepartmentUpdate) -> DepartmentResponse:
        """Actualiza un departamento"""
        # Verificar que existe
        existing = self.repository.get_by_id(department_id)
        if not existing:
            raise NotFoundException(f"Departamento con ID {department_id} no encontrado")
        
        # Verificar que el nuevo nombre no esté en uso por otro departamento
        name_check = self.repository.get_by_name(data.name)
        if name_check and name_check.id != department_id:
            raise ValidationException(
                message="Ya existe otro departamento con ese nombre",
                details=[{"field": "name", "message": "Nombre duplicado"}]
            )
        
        department = self.repository.update(department_id, data.name)
        logger.info(f"Departamento actualizado: ID {department_id} -> {data.name}")
        return DepartmentResponse.model_validate(department)
    
    def delete(self, department_id: int) -> None:
        """Elimina un departamento"""
        existing = self.repository.get_by_id(department_id)
        if not existing:
            raise NotFoundException(f"Departamento con ID {department_id} no encontrado")
        
        logger.warning(f"Departamento eliminado: {existing.name} (ID: {department_id})")
        success = self.repository.delete(department_id)
        if not success:
            raise ValidationException("No se pudo eliminar el departamento")
