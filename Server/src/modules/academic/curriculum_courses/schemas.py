"""
Schemas Pydantic para CURRICULUM_COURSE_SLOTS
Sistema: SGSCT
"""
from pydantic import BaseModel, field_validator


class CurriculumCourseSlotCreate(BaseModel):
    """Schema para crear casilla curricular"""
    name: str
    id_curriculum_course_type: int
    
    @field_validator("name")
    @classmethod
    def name_not_empty(cls, v: str) -> str:
        if not v or not v.strip():
            raise ValueError("El nombre no puede estar vacío")
        return v.strip()
    
    model_config = {
        "json_schema_extra": {
            "example": {
                "name": "Actividades de Formación Integral I",
                "id_curriculum_course_type": 1
            }
        }
    }


class CurriculumCourseSlotUpdate(BaseModel):
    """Schema para actualizar casilla curricular"""
    name: str
    id_curriculum_course_type: int
    
    @field_validator("name")
    @classmethod
    def name_not_empty(cls, v: str) -> str:
        if not v or not v.strip():
            raise ValueError("El nombre no puede estar vacío")
        return v.strip()
    
    model_config = {
        "json_schema_extra": {
            "example": {
                "name": "Actividades de Formación Integral I",
                "id_curriculum_course_type": 1
            }
        }
    }


class CurriculumCourseSlotResponse(BaseModel):
    """Schema para respuesta de casilla curricular"""
    id: int
    name: str
    id_curriculum_course_type: int
    
    model_config = {
        "from_attributes": True,
        "json_schema_extra": {
            "example": {
                "id": 1,
                "name": "Actividades de Formación Integral I",
                "id_curriculum_course_type": 1
            }
        }
    }
