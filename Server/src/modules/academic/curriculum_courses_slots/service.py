"""
Servicio de lógica de negocio para CURRICULUM_COURSE_SLOTS
Sistema: SGSCT
"""
from typing import List, Dict, Any
from sqlalchemy.orm import Session
from src.modules.academic.curriculum_courses_slots.repositories import CurriculumCourseSlotRepository
from src.modules.academic.curriculum_courses_slots.schemas import (
    CurriculumCourseSlotCreate,
    CurriculumCourseSlotUpdate,
    CurriculumCourseSlotResponse
)
from src.core.exceptions import NotFoundException, ValidationException
from src.monitoring.logging import get_logger

logger = get_logger(__name__)


class CurriculumCourseSlotService:
    """Servicio para gestión de casillas curriculares"""
    
    def __init__(self, db: Session):
        self.db = db
        self.repository = CurriculumCourseSlotRepository(db)
    
    def get_all(self, page: int = 1, page_size: int = 20) -> Dict[str, Any]:
        """Obtiene todas las casillas curriculares paginadas"""
        skip = (page - 1) * page_size
        slots = self.repository.get_all(skip=skip, limit=page_size)
        total = self.repository.count()
        
        return {
            "items": [CurriculumCourseSlotResponse.model_validate(slot) for slot in slots],
            "page": page,
            "page_size": page_size,
            "total": total
        }
    
    def get_by_id(self, slot_id: int) -> CurriculumCourseSlotResponse:
        """Obtiene una casilla curricular por ID"""
        slot = self.repository.get_by_id(slot_id)
        
        if not slot:
            raise NotFoundException(f"Casilla curricular con ID {slot_id} no encontrada")
        
        return CurriculumCourseSlotResponse.model_validate(slot)
    
    def get_by_type(self, type_id: int, page: int = 1, page_size: int = 20) -> Dict[str, Any]:
        """Obtiene casillas curriculares por tipo"""
        skip = (page - 1) * page_size
        slots = self.repository.get_by_type(type_id, skip=skip, limit=page_size)
        total = self.repository.count_by_type(type_id)
        
        return {
            "items": [CurriculumCourseSlotResponse.model_validate(slot) for slot in slots],
            "page": page,
            "page_size": page_size,
            "total": total
        }
    
    def create(self, data: CurriculumCourseSlotCreate) -> CurriculumCourseSlotResponse:
        """Crea una nueva casilla curricular"""
        slot = self.repository.create(
            name=data.name,
            id_curriculum_course_type=data.id_curriculum_course_type
        )
        return CurriculumCourseSlotResponse.model_validate(slot)
    
    def update(self, slot_id: int, data: CurriculumCourseSlotUpdate) -> CurriculumCourseSlotResponse:
        """Actualiza una casilla curricular"""
        existing = self.repository.get_by_id(slot_id)
        if not existing:
            raise NotFoundException(f"Casilla curricular con ID {slot_id} no encontrada")
        
        slot = self.repository.update(
            slot_id=slot_id,
            name=data.name,
            id_curriculum_course_type=data.id_curriculum_course_type
        )
        return CurriculumCourseSlotResponse.model_validate(slot)
    
    def delete(self, slot_id: int) -> None:
        """Elimina una casilla curricular"""
        existing = self.repository.get_by_id(slot_id)
        if not existing:
            raise NotFoundException(f"Casilla curricular con ID {slot_id} no encontrada")
        
        success = self.repository.delete(slot_id)
        if not success:
            raise ValidationException("No se pudo eliminar la casilla curricular")
