"""
Schemas del módulo Users
Sistema: SGSCT
"""
from pydantic import BaseModel, Field, field_validator
from typing import Optional
import re
from src.modules.users.constants import (
    RUT_PATTERN,
    ROL_PATTERN,
    VALID_EMAIL_DOMAINS,
    MSG_INVALID_RUT,
    MSG_INVALID_ROL,
    MSG_INVALID_EMAIL_DOMAIN
)


# ============================================================================
# USER SCHEMAS
# ============================================================================

class UserBase(BaseModel):
    """Schema base para usuarios"""
    email: str = Field(..., max_length=255, description="Email institucional")
    full_name: str = Field(..., min_length=2, max_length=255, description="Nombre completo")
    id_campus: int = Field(..., description="ID del campus")
    id_user_type: int = Field(..., description="ID del tipo de usuario")
    
    @field_validator("email")
    @classmethod
    def validate_email_domain(cls, v: str) -> str:
        """Valida que el email sea del dominio institucional"""
        if not any(v.endswith(domain) for domain in VALID_EMAIL_DOMAINS):
            raise ValueError(MSG_INVALID_EMAIL_DOMAIN)
        return v.lower().strip()


class UserCreate(UserBase):
    """Schema para crear usuario"""
    password: str = Field(..., min_length=8, description="Contraseña (mínimo 8 caracteres)")
    rol_student: Optional[str] = Field(None, min_length=9, max_length=11, description="ROL del estudiante")
    rut_student: Optional[str] = Field(None, min_length=7, max_length=9, description="RUT del estudiante")
    
    @field_validator("rol_student")
    @classmethod
    def validate_rol(cls, v: Optional[str]) -> Optional[str]:
        """Valida formato del ROL"""
        if v and not re.match(ROL_PATTERN, v):
            raise ValueError(MSG_INVALID_ROL)
        return v
    
    @field_validator("rut_student")
    @classmethod
    def validate_rut(cls, v: Optional[str]) -> Optional[str]:
        """Valida formato del RUT"""
        if v and not re.match(RUT_PATTERN, v):
            raise ValueError(MSG_INVALID_RUT)
        return v


class UserUpdate(BaseModel):
    """Schema para actualizar usuario"""
    full_name: Optional[str] = Field(None, min_length=2, max_length=255)
    id_campus: Optional[int] = None
    rol_student: Optional[str] = Field(None, min_length=9, max_length=11)
    rut_student: Optional[str] = Field(None, min_length=7, max_length=9)
    
    @field_validator("rol_student")
    @classmethod
    def validate_rol(cls, v: Optional[str]) -> Optional[str]:
        if v and not re.match(ROL_PATTERN, v):
            raise ValueError(MSG_INVALID_ROL)
        return v
    
    @field_validator("rut_student")
    @classmethod
    def validate_rut(cls, v: Optional[str]) -> Optional[str]:
        if v and not re.match(RUT_PATTERN, v):
            raise ValueError(MSG_INVALID_RUT)
        return v


class UserResponse(BaseModel):
    """Schema de respuesta para usuario"""
    id: int
    email: str
    full_name: str
    id_campus: int
    id_user_type: int
    rol_student: Optional[str]
    rut_student: Optional[str]
    
    class Config:
        from_attributes = True


# ============================================================================
# PROFESSOR SCHEMAS
# ============================================================================

class ProfessorBase(BaseModel):
    """Schema base para profesores"""
    name: str = Field(..., min_length=2, max_length=255, description="Nombre del profesor")
    email: str = Field(..., max_length=255, description="Email del profesor")
    
    @field_validator("email")
    @classmethod
    def validate_email(cls, v: str) -> str:
        """Normaliza el email"""
        return v.lower().strip()


class ProfessorCreate(ProfessorBase):
    """Schema para crear profesor"""
    pass


class ProfessorUpdate(BaseModel):
    """Schema para actualizar profesor"""
    name: Optional[str] = Field(None, min_length=2, max_length=255)
    email: Optional[str] = Field(None, max_length=255)
    
    @field_validator("email")
    @classmethod
    def validate_email(cls, v: Optional[str]) -> Optional[str]:
        if v:
            return v.lower().strip()
        return v


class ProfessorResponse(ProfessorBase):
    """Schema de respuesta para profesor"""
    id: int
    
    class Config:
        from_attributes = True
