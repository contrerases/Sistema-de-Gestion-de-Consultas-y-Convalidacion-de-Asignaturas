"""
Schemas de Convalidations
Sistema: SGSCT
"""
from pydantic import BaseModel, Field
from typing import Optional
from datetime import datetime


# ============================================================================
# SCHEMAS BASE
# ============================================================================

class ConvalidationBase(BaseModel):
    """Schema base para Convalidation"""
    id_request: int = Field(..., description="ID de la solicitud")
    id_convalidation_type: int = Field(..., description="ID del tipo de convalidación")
    id_convalidation_state: int = Field(..., description="ID del estado")
    id_curriculum_course: Optional[int] = Field(None, description="ID del slot curricular (opcional)")
    review_comments: Optional[str] = Field(None, max_length=1000, description="Comentarios de revisión")


# ============================================================================
# CONVALIDATION SUBJECT
# ============================================================================

class ConvalidationSubjectCreate(BaseModel):
    """Schema para crear convalidación de asignatura"""
    id_request: int = Field(..., description="ID de la solicitud")
    id_convalidation_state: int = Field(..., description="ID del estado")
    id_curriculum_course: Optional[int] = Field(None, description="ID del slot curricular")
    id_subject: int = Field(..., description="ID de la asignatura")
    review_comments: Optional[str] = Field(None, max_length=1000)


# ============================================================================
# CONVALIDATION WORKSHOP
# ============================================================================

class ConvalidationWorkshopCreate(BaseModel):
    """Schema para crear convalidación de taller"""
    id_request: int = Field(..., description="ID de la solicitud")
    id_convalidation_state: int = Field(..., description="ID del estado")
    id_curriculum_course: Optional[int] = Field(None, description="ID del slot curricular")
    id_workshop: int = Field(..., description="ID del taller")
    workshop_grade: Optional[float] = Field(None, ge=0, le=100, description="Calificación del taller")
    review_comments: Optional[str] = Field(None, max_length=1000)


# ============================================================================
# CONVALIDATION EXTERNAL ACTIVITY
# ============================================================================

class ConvalidationExternalActivityCreate(BaseModel):
    """Schema para crear convalidación de actividad externa"""
    id_request: int = Field(..., description="ID de la solicitud")
    id_convalidation_state: int = Field(..., description="ID del estado")
    id_curriculum_course: Optional[int] = Field(None, description="ID del slot curricular")
    activity_name: str = Field(..., max_length=255, description="Nombre de la actividad")
    institution_name: Optional[str] = Field(None, max_length=255, description="Nombre de la institución")
    description: Optional[str] = Field(None, description="Descripción de la actividad")
    review_comments: Optional[str] = Field(None, max_length=1000)


# ============================================================================
# UPDATE & RESPONSE
# ============================================================================

class ConvalidationUpdate(BaseModel):
    """Schema para actualizar convalidación"""
    id_convalidation_state: Optional[int] = Field(None, description="Nuevo estado")
    review_comments: Optional[str] = Field(None, max_length=1000, description="Comentarios")


class ConvalidationApprove(BaseModel):
    """Schema para aprobar convalidación"""
    approved_by: int = Field(..., description="ID del usuario que aprueba")
    review_comments: Optional[str] = Field(None, max_length=1000)


class ConvalidationReject(BaseModel):
    """Schema para rechazar convalidación"""
    reason: str = Field(..., min_length=10, max_length=1000, description="Razón del rechazo")


class ConvalidationResponse(ConvalidationBase):
    """Schema de respuesta para Convalidation"""
    id: int
    approved_at: Optional[datetime]
    approved_by: Optional[int]
    
    class Config:
        from_attributes = True


# ============================================================================
# DETAILED RESPONSES
# ============================================================================

class ConvalidationSubjectResponse(ConvalidationResponse):
    """Schema de respuesta para convalidación de asignatura"""
    id_subject: int


class ConvalidationWorkshopResponse(ConvalidationResponse):
    """Schema de respuesta para convalidación de taller"""
    id_workshop: int
    workshop_grade: Optional[float]


class ConvalidationExternalActivityResponse(ConvalidationResponse):
    """Schema de respuesta para convalidación de actividad externa"""
    activity_name: str
    institution_name: Optional[str]
    description: Optional[str]
    file_path: Optional[str]
