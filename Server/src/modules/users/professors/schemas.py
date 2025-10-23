"""
Schemas del submódulo Professors
Sistema: SGSCT
"""

from pydantic import BaseModel, Field
from typing import Optional


class Professor(BaseModel):
    """Schema base para profesores"""

    name: str = Field(
        ..., min_length=2, max_length=255, description="Nombre del profesor"
    )
    email: str = Field(..., max_length=255, description="Email del profesor")


class ProfessorCreate(Professor):
    """Schema para crear profesor"""

    pass


class ProfessorUpdate(BaseModel):
    """Schema para actualizar profesor"""

    name: Optional[str] = Field(None, min_length=2, max_length=255)
    email: Optional[str] = Field(None, max_length=255)


class ProfessorResponse(BaseModel):
    """Schema de respuesta para profesor"""

    id: int
    name: str
    email: str

    class Config:
        from_attributes = True
