"""
Repositorio para CURRICULUM_COURSES_TYPE
Sistema: SGSCT
"""
from typing import List, Optional
from sqlalchemy.orm import Session
from src.modules.catalog.curriculum_course_types.models import CurriculumCourseType
from src.database.repository import BaseRepository


class CurriculumCourseTypeRepository(BaseRepository[CurriculumCourseType]):
    
    def __init__(self, db: Session):
        super().__init__(CurriculumCourseType, db)
    
    def get_all(self, skip: int = 0, limit: int = 100) -> List[CurriculumCourseType]:
        return self.db.query(self.model).offset(skip).limit(limit).all()
    
    def get_by_id(self, type_id: int) -> Optional[CurriculumCourseType]:
        return self.db.query(self.model).filter(self.model.id == type_id).first()
    
    def get_by_type(self, type_name: str) -> Optional[CurriculumCourseType]:
        return self.db.query(self.model).filter(
            self.model.curriculum_course_type == type_name
        ).first()
    
    def create(self, curriculum_type: CurriculumCourseType) -> CurriculumCourseType:
        self.db.add(curriculum_type)
        self.db.commit()
        self.db.refresh(curriculum_type)
        return curriculum_type
    
    def update(self, curriculum_type: CurriculumCourseType) -> CurriculumCourseType:
        self.db.commit()
        self.db.refresh(curriculum_type)
        return curriculum_type
    
    def delete(self, curriculum_type: CurriculumCourseType) -> None:
        self.db.delete(curriculum_type)
        self.db.commit()
    
    def count(self) -> int:
        return self.db.query(self.model).count()
