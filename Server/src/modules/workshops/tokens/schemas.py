"""
Schemas de Tokens
Sistema: SGSCT
"""
from pydantic import BaseModel, Field
from datetime import datetime


class TokenBase(BaseModel):
    """Schema base para Token"""
    id_workshop: int = Field(..., description="ID del taller")
    expires_at: datetime = Field(..., description="Fecha de expiración")


class TokenCreate(TokenBase):
    """Schema para crear Token"""
    pass


class TokenValidate(BaseModel):
    """Schema para validar Token"""
    token: str = Field(..., description="Token a validar")


class TokenResponse(TokenBase):
    """Schema de respuesta para Token"""
    id: int
    token: str
    created_at: datetime
    is_active: bool
    
    class Config:
        from_attributes = True
