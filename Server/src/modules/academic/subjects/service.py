"""
Servicio de lógica de negocio para SUBJECTS
Sistema: SGSCT
"""
import logging
from typing import List, Dict, Any
from sqlalchemy.orm import Session
from src.modules.academic.subjects.repositories import SubjectRepository
from src.modules.academic.subjects.schemas import SubjectCreate, SubjectUpdate, SubjectResponse
from src.modules.academic.departments.repositories import DepartmentRepository
from src.core.exceptions import NotFoundException, ValidationException

logger = logging.getLogger(__name__)


class SubjectService:
    """Servicio para gestión de asignaturas"""
    
    def __init__(self, db: Session):
        self.db = db
        self.repository = SubjectRepository(db)
        self.department_repository = DepartmentRepository(db)
    
    def get_all(self, page: int = 1, page_size: int = 20) -> Dict[str, Any]:
        """Obtiene todas las asignaturas paginadas"""
        skip = (page - 1) * page_size
        subjects = self.repository.get_all(skip=skip, limit=page_size)
        total = self.repository.count()
        
        return {
            "items": [self._to_response(subject) for subject in subjects],
            "page": page,
            "page_size": page_size,
            "total": total
        }
    
    def get_by_id(self, subject_id: int) -> SubjectResponse:
        """Obtiene una asignatura por ID"""
        subject = self.repository.get_by_id(subject_id)
        
        if not subject:
            raise NotFoundException(f"Asignatura con ID {subject_id} no encontrada")
        
        return self._to_response(subject)
    
    def get_by_department(
        self,
        department_id: int,
        page: int = 1,
        page_size: int = 20
    ) -> Dict[str, Any]:
        """Obtiene asignaturas de un departamento"""
        # Verificar que el departamento existe
        department = self.department_repository.get_by_id(department_id)
        if not department:
            raise NotFoundException(f"Departamento con ID {department_id} no encontrado")
        
        skip = (page - 1) * page_size
        subjects = self.repository.get_by_department(department_id, skip=skip, limit=page_size)
        total = self.repository.count_by_department(department_id)
        
        return {
            "items": [self._to_response(subject) for subject in subjects],
            "page": page,
            "page_size": page_size,
            "total": total
        }
    
    def create(self, data: SubjectCreate) -> SubjectResponse:
        """Crea una nueva asignatura"""
        # Verificar que el departamento existe
        department = self.department_repository.get_by_id(data.id_department)
        if not department:
            raise ValidationException(
                message="Departamento no encontrado",
                details=[{"field": "id_department", "message": "Departamento no existe"}]
            )
        
        # Verificar que no exista una asignatura con el mismo acrónimo
        existing = self.repository.get_by_acronym(data.acronym)
        if existing:
            raise ValidationException(
                message="Ya existe una asignatura con ese acrónimo",
                details=[{"field": "acronym", "message": "Acrónimo duplicado"}]
            )
        
        subject = self.repository.create(
            acronym=data.acronym,
            name=data.name,
            id_department=data.id_department,
            credits=data.credits
        )
        
        logger.info(f"Asignatura creada: {data.acronym} - {data.name} (ID: {subject.id})")
        return self._to_response(subject)
    
    def update(self, subject_id: int, data: SubjectUpdate) -> SubjectResponse:
        """Actualiza una asignatura"""
        # Verificar que existe
        existing = self.repository.get_by_id(subject_id)
        if not existing:
            raise NotFoundException(f"Asignatura con ID {subject_id} no encontrada")
        
        # Verificar que el departamento existe
        department = self.department_repository.get_by_id(data.id_department)
        if not department:
            raise ValidationException(
                message="Departamento no encontrado",
                details=[{"field": "id_department", "message": "Departamento no existe"}]
            )
        
        # Verificar que el nuevo acrónimo no esté en uso por otra asignatura
        acronym_check = self.repository.get_by_acronym(data.acronym)
        if acronym_check and acronym_check.id != subject_id:
            raise ValidationException(
                message="Ya existe otra asignatura con ese acrónimo",
                details=[{"field": "acronym", "message": "Acrónimo duplicado"}]
            )
        
        subject = self.repository.update(
            subject_id=subject_id,
            acronym=data.acronym,
            name=data.name,
            id_department=data.id_department,
            credits=data.credits
        )
        
        logger.info(f"Asignatura actualizada: ID {subject_id} -> {data.acronym}")
        return self._to_response(subject)
    
    def delete(self, subject_id: int) -> None:
        """Elimina una asignatura"""
        existing = self.repository.get_by_id(subject_id)
        if not existing:
            raise NotFoundException(f"Asignatura con ID {subject_id} no encontrada")
        
        logger.warning(f"Asignatura eliminada: {existing.acronym} (ID: {subject_id})")
        
        success = self.repository.delete(subject_id)
        if not success:
            raise ValidationException("No se pudo eliminar la asignatura")
    
    def _to_response(self, subject) -> SubjectResponse:
        """Convierte modelo ORM a schema de respuesta"""
        return SubjectResponse(
            id=subject.id,
            acronym=subject.acronym,
            name=subject.name,
            id_department=subject.id_department,
            department_name=subject.department.name,
            credits=subject.credits
        )
