"""
Repositorio para Curriculum Course Slots Base
"""

from typing import Optional, List
from sqlalchemy.orm import Session
from src.modules.academic.curriculum_courses_slots.base.models import (
    CurriculumCourseSlot,
)


class CurriculumCourseSlotRepository:
    """Repositorio para operaciones CRUD de curriculum course slots base"""

    def __init__(self, db: Session):
        self.db = db

    def get_all(self, skip: int = 0, limit: int = 100) -> List[CurriculumCourseSlot]:
        return self.db.query(CurriculumCourseSlot).offset(skip).limit(limit).all()

    def get_by_id(self, slot_id: int) -> Optional[CurriculumCourseSlot]:
        return (
            self.db.query(CurriculumCourseSlot)
            .filter(CurriculumCourseSlot.id == slot_id)
            .first()
        )

    def create(self, **kwargs) -> CurriculumCourseSlot:
        slot = CurriculumCourseSlot(**kwargs)
        self.db.add(slot)
        self.db.commit()
        self.db.refresh(slot)
        return slot

    def update(self, slot_id: int, **kwargs) -> Optional[CurriculumCourseSlot]:
        slot = self.get_by_id(slot_id)
        if slot:
            for key, value in kwargs.items():
                setattr(slot, key, value)
            self.db.commit()
            self.db.refresh(slot)
        return slot

    def delete(self, slot_id: int) -> bool:
        slot = self.get_by_id(slot_id)
        if slot:
            self.db.delete(slot)
            self.db.commit()
            return True
        return False

    def count(self) -> int:
        return self.db.query(CurriculumCourseSlot).count()
