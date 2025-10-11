"""
Schemas de Requests
Sistema: SGSCT
"""
from pydantic import BaseModel, Field
from typing import Optional
from datetime import datetime


class RequestBase(BaseModel):
    """Schema base para Request"""
    id_student: int = Field(..., description="ID del estudiante")
    id_request_state: int = Field(..., description="ID del estado de la solicitud")


class RequestCreate(RequestBase):
    """Schema para crear Request"""
    pass


class RequestUpdateState(BaseModel):
    """Schema para actualizar estado de Request"""
    id_request_state: int = Field(..., description="Nuevo ID del estado")


class RequestResponse(RequestBase):
    """Schema de respuesta para Request"""
    id: int
    sent_at: datetime
    
    class Config:
        from_attributes = True
