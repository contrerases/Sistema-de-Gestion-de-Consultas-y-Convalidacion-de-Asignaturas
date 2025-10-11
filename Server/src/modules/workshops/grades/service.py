"""
Servicio de Grades
Sistema: SGSCT
"""
from typing import Dict, Optional
from sqlalchemy.orm import Session
from src.modules.workshops.grades.repositories import GradeRepository
from src.modules.workshops.grades.schemas import GradeCreate, GradeUpdate, GradeResponse
from src.modules.workshops.inscriptions.repositories import InscriptionRepository
from src.modules.workshops.constants import (
    VALIDATE_INSCRIPTION_BEFORE_GRADE,
    MSG_STUDENT_NOT_INSCRIBED,
    MSG_GRADE_ALREADY_EXISTS
)
from src.core.exceptions import NotFoundException, ValidationException
from src.monitoring.logging import get_logger

logger = get_logger(__name__)


class GradeService:
    """Servicio para gestión de calificaciones"""
    
    def __init__(self, db: Session):
        self.db = db
        self.repository = GradeRepository(db)
        self.inscription_repository = InscriptionRepository(db)
    
    def get_all(self, page: int = 1, page_size: int = 20, workshop_id: Optional[int] = None, student_id: Optional[int] = None) -> Dict:
        """Obtiene todas las calificaciones con filtros"""
        skip = (page - 1) * page_size
        grades_db = self.repository.get_all(skip=skip, limit=page_size, workshop_id=workshop_id, student_id=student_id)
        total = self.repository.count(workshop_id=workshop_id, student_id=student_id)
        
        return {
            "items": [GradeResponse.model_validate(g) for g in grades_db],
            "page": page,
            "page_size": page_size,
            "total": total
        }
    
    def get_by_id(self, grade_id: int) -> GradeResponse:
        """Obtiene una calificación por ID"""
        grade = self.repository.get_by_id(grade_id)
        if not grade:
            raise NotFoundException(f"Calificación con ID {grade_id} no encontrada")
        
        return GradeResponse.model_validate(grade)
    
    def get_by_workshop(self, workshop_id: int, page: int = 1, page_size: int = 20) -> Dict:
        """Obtiene calificaciones de un taller"""
        skip = (page - 1) * page_size
        grades_db = self.repository.get_by_workshop(workshop_id, skip=skip, limit=page_size)
        total = self.repository.count(workshop_id=workshop_id)
        
        return {
            "items": [GradeResponse.model_validate(g) for g in grades_db],
            "page": page,
            "page_size": page_size,
            "total": total
        }
    
    def get_by_student(self, student_id: int) -> list[GradeResponse]:
        """Obtiene calificaciones de un estudiante"""
        grades_db = self.repository.get_by_student(student_id)
        return [GradeResponse.model_validate(g) for g in grades_db]
    
    def create(self, data: GradeCreate) -> GradeResponse:
        """Crea una nueva calificación"""
        # Validar que el estudiante esté inscrito
        if VALIDATE_INSCRIPTION_BEFORE_GRADE:
            inscription = self.inscription_repository.check_existing(data.id_student, data.id_workshop)
            if not inscription:
                raise ValidationException(MSG_STUDENT_NOT_INSCRIBED)
        
        # Validar que no tenga ya una calificación
        existing = self.repository.get_existing(data.id_student, data.id_workshop)
        if existing:
            raise ValidationException(MSG_GRADE_ALREADY_EXISTS)
        
        logger.info(f"Asignando calificación {data.grade} a estudiante {data.id_student} en taller {data.id_workshop}")
        
        grade = self.repository.create(
            student_id=data.id_student,
            workshop_id=data.id_workshop,
            grade=data.grade
        )
        
        return GradeResponse.model_validate(grade)
    
    def update(self, grade_id: int, data: GradeUpdate) -> GradeResponse:
        """Actualiza una calificación"""
        existing = self.repository.get_by_id(grade_id)
        if not existing:
            raise NotFoundException(f"Calificación con ID {grade_id} no encontrada")
        
        logger.info(f"Actualizando calificación {grade_id} a {data.grade}")
        
        grade = self.repository.update(grade_id, data.grade)
        return GradeResponse.model_validate(grade)
    
    def delete(self, grade_id: int) -> None:
        """Elimina una calificación"""
        existing = self.repository.get_by_id(grade_id)
        if not existing:
            raise NotFoundException(f"Calificación con ID {grade_id} no encontrada")
        
        logger.info(f"Eliminando calificación {grade_id}")
        self.repository.delete(grade_id)
