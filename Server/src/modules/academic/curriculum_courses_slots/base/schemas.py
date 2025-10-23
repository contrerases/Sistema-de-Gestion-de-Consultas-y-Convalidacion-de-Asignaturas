"""
Schemas Pydantic para Curriculum Course Slot Base
"""


from typing import Optional
from pydantic import BaseModel, field_validator


class CurriculumCourseSlotCreate(BaseModel):
    name: str

    @field_validator("name")
    @classmethod
    def name_not_empty(cls, v: str) -> str:
        if not v or not v.strip():
            raise ValueError("El nombre no puede estar vacío")
        return v.strip()


class CurriculumCourseSlotUpdate(BaseModel):
    name: str

    @field_validator("name")
    @classmethod
    def name_not_empty(cls, v: str) -> str:
        if not v or not v.strip():
            raise ValueError("El nombre no puede estar vacío")
        return v.strip()


class CurriculumCourseSlotResponse(BaseModel):
    id: int
    name: str
    id_curriculum_course_type: int
    curriculum_course_type: str

    class Config:
        from_attributes = True
