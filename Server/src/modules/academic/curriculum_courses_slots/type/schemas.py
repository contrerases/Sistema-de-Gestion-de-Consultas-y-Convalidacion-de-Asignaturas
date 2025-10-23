"""
Schemas Pydantic para Curriculum Course Slot Type
"""

from pydantic import BaseModel, field_validator


class CurriculumCourseTypeCreate(BaseModel):
    name: str

    @field_validator("name")
    @classmethod
    def name_not_empty(cls, v: str) -> str:
        if not v or not v.strip():
            raise ValueError("El nombre no puede estar vacío")
        return v.strip()


class CurriculumCourseTypeUpdate(BaseModel):
    name: str

    @field_validator("name")
    @classmethod
    def name_not_empty(cls, v: str) -> str:
        if not v or not v.strip():
            raise ValueError("El nombre no puede estar vacío")
        return v.strip()


class CurriculumCourseTypeResponse(BaseModel):
    id: int
    name: str

    class Config:
        from_attributes = True
