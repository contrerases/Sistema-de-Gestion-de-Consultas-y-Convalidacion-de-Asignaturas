"""
Schemas Pydantic para SUBJECTS
Sistema: SGSCT
"""

from pydantic import BaseModel, field_validator


class SubjectCreate(BaseModel):
    """Schema para crear asignatura"""

    acronym: str
    name: str
    id_department: int
    credits: int

    @field_validator("acronym", "name")
    @classmethod
    def fields_not_empty(cls, v: str) -> str:
        if not v or not v.strip():
            raise ValueError("El campo no puede estar vacío")
        return v.strip()

    @field_validator("credits")
    @classmethod
    def credits_positive(cls, v: int) -> int:
        if v <= 0:
            raise ValueError("Los créditos deben ser mayores a 0")
        return v

    model_config = {
        "json_schema_extra": {
            "example": {
                "acronym": "INF-150",
                "name": "Programación",
                "id_department": 1,
                "credits": 4,
            }
        }
    }


class SubjectUpdate(BaseModel):
    """Schema para actualizar asignatura"""

    acronym: str
    name: str
    id_department: int
    credits: int

    @field_validator("acronym", "name")
    @classmethod
    def fields_not_empty(cls, v: str) -> str:
        if not v or not v.strip():
            raise ValueError("El campo no puede estar vacío")
        return v.strip()

    @field_validator("credits")
    @classmethod
    def credits_positive(cls, v: int) -> int:
        if v <= 0:
            raise ValueError("Los créditos deben ser mayores a 0")
        return v

    model_config = {
        "json_schema_extra": {
            "example": {
                "acronym": "INF-150",
                "name": "Programación Actualizada",
                "id_department": 1,
                "credits": 5,
            }
        }
    }


class SubjectResponse(BaseModel):
    """Schema para respuesta de asignatura"""

    id: int
    acronym: str
    name: str
    id_department: int
    department_name: str
    credits: int

    model_config = {
        "from_attributes": True,
        "json_schema_extra": {
            "example": {
                "id": 1,
                "acronym": "INF-150",
                "name": "Programación",
                "id_department": 1,
                "department_name": "Departamento de Informática",
                "credits": 4,
            }
        },
    }
