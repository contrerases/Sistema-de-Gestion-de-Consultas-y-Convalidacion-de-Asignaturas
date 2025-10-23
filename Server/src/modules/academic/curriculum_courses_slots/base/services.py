"""
Servicio de lógica de negocio para Curriculum Course Slot
"""

from typing import Dict, Any
from sqlalchemy.orm import Session

from src.modules.academic.curriculum_courses_slots.base.repository import (
    CurriculumCourseSlotRepository,
)
from src.modules.academic.curriculum_courses_slots.base.schemas import (
    CurriculumCourseSlotCreate,
    CurriculumCourseSlotUpdate,
    CurriculumCourseSlotResponse,
)

from fastapi import HTTPException, status


class CurriculumCourseSlotServices:
    def __init__(self, db: Session):
        self.db = db
        self.repository = CurriculumCourseSlotRepository(db)

    def get_all(self, page: int = 1, page_size: int = 20) -> Dict[str, Any]:
        skip = (page - 1) * page_size
        slots = self.repository.get_all(skip=skip, limit=page_size)
        total = self.repository.count()
        return {
            "items": [self._to_response(slot) for slot in slots],
            "page": page,
            "page_size": page_size,
            "total": total,
        }

    def get_by_id(self, slot_id: int) -> CurriculumCourseSlotResponse:
        slot = self.repository.get_by_id(slot_id)
        if not slot:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail=f"Slot con ID {slot_id} no encontrado",
            )
        return self._to_response(slot)

    def create(self, data: CurriculumCourseSlotCreate) -> CurriculumCourseSlotResponse:
        slot = self.repository.create(name=data.name, description=data.description)
        return self._to_response(slot)

    def update(
        self, slot_id: int, data: CurriculumCourseSlotUpdate
    ) -> CurriculumCourseSlotResponse:
        slot = self.repository.update(
            slot_id, name=data.name, description=data.description
        )
        if not slot:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail=f"Slot con ID {slot_id} no encontrado",
            )
        return self._to_response(slot)

    def delete(self, slot_id: int) -> None:
        success = self.repository.delete(slot_id)
        if not success:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail=f"Slot con ID {slot_id} no encontrado",
            )

    def _to_response(self, slot) -> CurriculumCourseSlotResponse:
        return CurriculumCourseSlotResponse(
            id=slot.id,
            name=slot.name,
            id_curriculum_course_type=slot.id_curriculum_course_type,
            curriculum_course_type=slot.curriculum_course_type.name
        )
