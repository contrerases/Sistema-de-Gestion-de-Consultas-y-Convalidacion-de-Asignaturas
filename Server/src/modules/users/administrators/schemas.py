"""
Schemas del submódulo Administrators
Sistema: SGSCT
"""
from pydantic import BaseModel, Field, field_validator
from typing import Optional
from src.modules.users.constants import (
    VALID_EMAIL_DOMAINS,
    MSG_INVALID_EMAIL_DOMAIN
)


class AdministratorBase(BaseModel):
    """Schema base para administradores"""
    email: str = Field(..., max_length=255, description="Email institucional del administrador")
    full_name: str = Field(..., min_length=2, max_length=255, description="Nombre completo")
    id_campus: int = Field(..., description="ID del campus")
    
    @field_validator("email")
    @classmethod
    def validate_email_domain(cls, v: str) -> str:
        """Valida que el email sea de un dominio institucional válido"""
        if not any(v.endswith(domain) for domain in VALID_EMAIL_DOMAINS):
            raise ValueError(MSG_INVALID_EMAIL_DOMAIN)
        return v.lower().strip()


class AdministratorCreate(AdministratorBase):
    """Schema para crear administrador"""
    password: str = Field(..., min_length=8, description="Contraseña (mínimo 8 caracteres)")


class AdministratorUpdate(BaseModel):
    """Schema para actualizar administrador"""
    full_name: Optional[str] = Field(None, min_length=2, max_length=255)
    id_campus: Optional[int] = None


class AdministratorResponse(BaseModel):
    """Schema de respuesta para administrador"""
    id: int
    email: str
    full_name: str
    id_campus: int
    id_user_type: int
    
    class Config:
        from_attributes = True
