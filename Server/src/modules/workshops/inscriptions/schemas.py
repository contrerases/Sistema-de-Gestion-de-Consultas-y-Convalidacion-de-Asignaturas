"""
Schemas de Inscriptions
Sistema: SGSCT
"""
from pydantic import BaseModel, Field
from typing import Optional
from datetime import datetime


class InscriptionBase(BaseModel):
    """Schema base para Inscription"""
    id_student: int = Field(..., description="ID del estudiante")
    id_workshop: int = Field(..., description="ID del taller")
    id_curriculum_course: Optional[int] = Field(None, description="ID del slot curricular (opcional)")


class InscriptionCreate(InscriptionBase):
    """Schema para crear Inscription"""
    pass


class InscriptionResponse(InscriptionBase):
    """Schema de respuesta para Inscription"""
    id: int
    is_convalidated: bool
    inscription_at: datetime
    
    class Config:
        from_attributes = True
