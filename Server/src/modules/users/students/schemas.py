"""
Schemas del submódulo Students
Sistema: SGSCT
"""

from pydantic import BaseModel, Field, field_validator
from typing import Optional
import re
from src.modules.users.base.constants import (
    RUT_PATTERN,
    ROL_PATTERN,
    VALID_EMAIL_DOMAINS,
    MSG_INVALID_RUT,
    MSG_INVALID_ROL,
    MSG_INVALID_EMAIL_DOMAIN,
)


class StudentBase(BaseModel):
    """Schema base para estudiantes"""

    email: str = Field(
        ..., max_length=255, description="Email institucional del estudiante"
    )
    full_name: str = Field(
        ..., min_length=2, max_length=255, description="Nombre completo"
    )
    id_campus: int = Field(..., description="ID del campus")
    rol_student: str = Field(
        ..., min_length=9, max_length=11, description="ROL del estudiante"
    )
    rut_student: str = Field(
        ..., min_length=7, max_length=9, description="RUT del estudiante"
    )

    @field_validator("email")
    @classmethod
    def validate_email_domain(cls, v: str) -> str:
        """Valida que el email sea de un dominio institucional válido"""
        if not any(v.endswith(domain) for domain in VALID_EMAIL_DOMAINS):
            raise ValueError(MSG_INVALID_EMAIL_DOMAIN)
        return v.lower().strip()

    @field_validator("rol_student")
    @classmethod
    def validate_rol(cls, v: str) -> str:
        """Valida formato del ROL"""
        if not re.match(ROL_PATTERN, v):
            raise ValueError(MSG_INVALID_ROL)
        return v

    @field_validator("rut_student")
    @classmethod
    def validate_rut(cls, v: str) -> str:
        """Valida formato del RUT"""
        if not re.match(RUT_PATTERN, v):
            raise ValueError(MSG_INVALID_RUT)
        return v


class StudentCreate(StudentBase):
    """Schema para crear estudiante"""

    password: str = Field(
        ..., min_length=8, description="Contraseña (mínimo 8 caracteres)"
    )


class StudentUpdate(BaseModel):
    """Schema para actualizar estudiante"""

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


class StudentResponse(BaseModel):
    """Schema de respuesta para estudiante"""

    id: int
    email: str
    full_name: str
    id_campus: int
    id_user_type: int
    rol_student: str
    rut_student: str

    class Config:
        from_attributes = True
