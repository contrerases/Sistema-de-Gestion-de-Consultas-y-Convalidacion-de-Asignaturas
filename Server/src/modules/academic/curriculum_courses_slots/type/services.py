"""
Servicio de lógica de negocio para Curriculum Course Slot Type
"""

from typing import Dict, Any
from sqlalchemy.orm import Session

from src.modules.academic.curriculum_courses_slots.type.schemas import (
    CurriculumCourseTypeCreate,
    CurriculumCourseTypeUpdate,
    CurriculumCourseTypeResponse,
)
from src.modules.academic.curriculum_courses_slots.type.repository import (
    CurriculumCourseTypeRepository,
)

from fastapi import HTTPException, status


class CurriculumCourseTypeServices:
    def __init__(self, db: Session):
        self.db = db
        self.repository = CurriculumCourseTypeRepository(db)

    def get_all(self, page: int = 1, page_size: int = 20) -> Dict[str, Any]:
        skip = (page - 1) * page_size
        types = self.repository.get_all(skip=skip, limit=page_size)
        total = self.repository.count()
        return {
            "items": [self._to_response(course_type) for course_type in types],
            "page": page,
            "page_size": page_size,
            "total": total,
        }

    def get_by_id(self, type_id: int) -> CurriculumCourseTypeResponse:
        course_type = self.repository.get_by_id(type_id)
        if not course_type:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail=f"Tipo con ID {type_id} no encontrado",
            )
        return self._to_response(course_type)

    def create(self, data: CurriculumCourseTypeCreate) -> CurriculumCourseTypeResponse:
        course_type = self.repository.create(name=data.name)
        return self._to_response(course_type)

    def update(
        self, type_id: int, data: CurriculumCourseTypeUpdate
    ) -> CurriculumCourseTypeResponse:
        course_type = self.repository.update(type_id, name=data.name)
        if not course_type:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail=f"Tipo con ID {type_id} no encontrado",
            )
        return self._to_response(course_type)

    def delete(self, type_id: int) -> None:
        success = self.repository.delete(type_id)
        if not success:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail=f"Tipo con ID {type_id} no encontrado",
            )

    def _to_response(self, course_type) -> CurriculumCourseTypeResponse:
        return CurriculumCourseTypeResponse(
            id=course_type.id,
            name=course_type.name,
        )
