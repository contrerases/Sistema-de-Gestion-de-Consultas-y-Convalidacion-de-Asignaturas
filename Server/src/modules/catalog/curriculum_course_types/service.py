"""
Lógica de negocio para CURRICULUM_COURSES_TYPE
Sistema: SGSCT
"""
from typing import Dict, List
from sqlalchemy.orm import Session
from src.modules.catalog.curriculum_course_types.repositories import CurriculumCourseTypeRepository
from src.modules.catalog.curriculum_course_types.schemas import (
    CurriculumCourseTypeCreate, 
    CurriculumCourseTypeUpdate, 
    CurriculumCourseTypeResponse
)
from src.modules.catalog.curriculum_course_types.models import CurriculumCourseType
from src.core.exceptions import NotFoundException, ValidationException
from src.monitoring.logging import get_logger

logger = get_logger(__name__)


class CurriculumCourseTypeService:
    
    def __init__(self, db: Session):
        self.repository = CurriculumCourseTypeRepository(db)
    
    def get_all(self, page: int = 1, page_size: int = 20) -> Dict:
        skip = (page - 1) * page_size
        types_db = self.repository.get_all(skip=skip, limit=page_size)
        total = self.repository.count()
        
        return {
            "items": [CurriculumCourseTypeResponse.model_validate(t) for t in types_db],
            "page": page,
            "page_size": page_size,
            "total": total
        }
    
    def get_by_id(self, type_id: int) -> CurriculumCourseTypeResponse:
        type_db = self.repository.get_by_id(type_id)
        if not type_db:
            raise NotFoundException(f"Tipo de curso curricular con ID {type_id} no encontrado")
        
        return CurriculumCourseTypeResponse.model_validate(type_db)
    
    def create(self, data: CurriculumCourseTypeCreate) -> CurriculumCourseTypeResponse:
        existing = self.repository.get_by_type(data.curriculum_course_type)
        if existing:
            raise ValidationException(
                f"Ya existe un tipo de curso curricular con el nombre '{data.curriculum_course_type}'"
            )
        
        new_type = CurriculumCourseType(**data.model_dump())
        created = self.repository.create(new_type)
        
        return CurriculumCourseTypeResponse.model_validate(created)
    
    def update(self, type_id: int, data: CurriculumCourseTypeUpdate) -> CurriculumCourseTypeResponse:
        type_db = self.repository.get_by_id(type_id)
        if not type_db:
            raise NotFoundException(f"Tipo de curso curricular con ID {type_id} no encontrado")
        
        if data.curriculum_course_type:
            existing = self.repository.get_by_type(data.curriculum_course_type)
            if existing and existing.id != type_id:
                raise ValidationException(
                    f"Ya existe otro tipo de curso curricular con el nombre '{data.curriculum_course_type}'"
                )
            type_db.curriculum_course_type = data.curriculum_course_type
        
        updated = self.repository.update(type_db)
        
        return CurriculumCourseTypeResponse.model_validate(updated)
    
    def delete(self, type_id: int) -> None:
        type_db = self.repository.get_by_id(type_id)
        if not type_db:
            raise NotFoundException(f"Tipo de curso curricular con ID {type_id} no encontrado")
        
        self.repository.delete(type_db)
