"""
Schemas del submódulo Professors
Sistema: SGSCT
"""
from pydantic import BaseModel, Field
from typing import Optional


class ProfessorBase(BaseModel):
    """Schema base para profesores"""
    name_professor: str = Field(..., min_length=2, max_length=255, description="Nombre del profesor")
    email_professor: Optional[str] = Field(None, max_length=255, description="Email del profesor")


class ProfessorCreate(ProfessorBase):
    """Schema para crear profesor"""
    pass


class ProfessorUpdate(BaseModel):
    """Schema para actualizar profesor"""
    name_professor: Optional[str] = Field(None, min_length=2, max_length=255)
    email_professor: Optional[str] = Field(None, max_length=255)


class ProfessorResponse(BaseModel):
    """Schema de respuesta para profesor"""
    id: int
    name_professor: str
    email_professor: Optional[str]
    
    class Config:
        from_attributes = True
