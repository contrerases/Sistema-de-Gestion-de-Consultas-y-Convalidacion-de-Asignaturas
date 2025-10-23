"""
Repositorio para Curriculum Course Slot Type
"""

from typing import Optional, List
from sqlalchemy.orm import Session
from src.modules.academic.curriculum_courses_slots.type.models import (
    CurriculumCourseType,
)


class CurriculumCourseTypeRepository:
    def __init__(self, db: Session):
        self.db = db

    def get_all(self, skip: int = 0, limit: int = 100) -> List[CurriculumCourseType]:
        return self.db.query(CurriculumCourseType).offset(skip).limit(limit).all()

    def get_by_id(self, type_id: int) -> Optional[CurriculumCourseType]:
        return (
            self.db.query(CurriculumCourseType)
            .filter(CurriculumCourseType.id == type_id)
            .first()
        )

    def create(self, **kwargs) -> CurriculumCourseType:
        course_type = CurriculumCourseType(**kwargs)
        self.db.add(course_type)
        self.db.commit()
        self.db.refresh(course_type)
        return course_type

    def update(self, type_id: int, **kwargs) -> Optional[CurriculumCourseType]:
        course_type = self.get_by_id(type_id)
        if course_type:
            for key, value in kwargs.items():
                setattr(course_type, key, value)
            self.db.commit()
            self.db.refresh(course_type)
        return course_type

    def delete(self, type_id: int) -> bool:
        course_type = self.get_by_id(type_id)
        if course_type:
            self.db.delete(course_type)
            self.db.commit()
            return True
        return False

    def count(self) -> int:
        return self.db.query(CurriculumCourseType).count()
