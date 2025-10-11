"""
Schemas de Grades
Sistema: SGSCT
"""
from pydantic import BaseModel, Field
from datetime import datetime


class GradeBase(BaseModel):
    """Schema base para Grade"""
    id_student: int = Field(..., description="ID del estudiante")
    id_workshop: int = Field(..., description="ID del taller")
    grade: int = Field(..., ge=0, le=100, description="Calificación (0-100)")


class GradeCreate(GradeBase):
    """Schema para crear Grade"""
    pass


class GradeUpdate(BaseModel):
    """Schema para actualizar Grade"""
    grade: int = Field(..., ge=0, le=100, description="Nueva calificación")


class GradeResponse(GradeBase):
    """Schema de respuesta para Grade"""
    id: int
    evaluated_at: datetime
    
    class Config:
        from_attributes = True
