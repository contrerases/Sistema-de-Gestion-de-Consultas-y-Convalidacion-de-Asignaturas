"""
Esquemas Pydantic para CURRICULUM_COURSES_TYPES
Sistema: SGSCT
"""
from pydantic import BaseModel, Field, field_validator
from typing import Optional


class CurriculumCourseTypeCreate(BaseModel):
    curriculum_course_type: str = Field(..., min_length=1, max_length=255)

    @field_validator("curriculum_course_type")
    @classmethod
    def validate_type_name(cls, v: str) -> str:
        if not v.strip():
            raise ValueError("El nombre del tipo de curso curricular no puede estar vacío")
        return v.strip()

    model_config = {
        "from_attributes": True,
        "json_schema_extra": {
            "example": {
                "curriculum_course_type": "Obligatorio"
            }
        }
    }


class CurriculumCourseTypeUpdate(BaseModel):
    curriculum_course_type: Optional[str] = Field(None, min_length=1, max_length=255)

    @field_validator("curriculum_course_type")
    @classmethod
    def validate_type_name(cls, v: Optional[str]) -> Optional[str]:
        if v is not None and not v.strip():
            raise ValueError("El nombre del tipo de curso curricular no puede estar vacío")
        return v.strip() if v else None

    model_config = {"from_attributes": True}


class CurriculumCourseTypeResponse(BaseModel):
    id: int
    curriculum_course_type: str

    model_config = {
        "from_attributes": True,
        "json_schema_extra": {
            "example": {
                "id": 1,
                "curriculum_course_type": "Obligatorio"
            }
        }
    }
