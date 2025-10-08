"""
Schemas Pydantic de autenticación
Sistema: SGSCT
"""
from pydantic import BaseModel, EmailStr, field_validator
from typing import Optional
from src.core.enums import UserType as UserTypeEnum


# =============================================================================
# REQUEST SCHEMAS
# =============================================================================

class LoginRequest(BaseModel):
    """Schema para solicitud de login"""
    email: EmailStr
    password: str
    
    @field_validator("password")
    @classmethod
    def password_not_empty(cls, v: str) -> str:
        if not v or not v.strip():
            raise ValueError("La contraseña no puede estar vacía")
        return v
    
    model_config = {
        "json_schema_extra": {
            "example": {
                "email": "estudiante@usm.cl",
                "password": "password123"
            }
        }
    }


class RegisterRequest(BaseModel):
    """Schema para registro de nuevo usuario"""
    email: EmailStr
    password: str
    full_name: str
    campus_acronym: str
    user_type: UserTypeEnum
    rol_student: Optional[str] = None
    rut_student: Optional[str] = None
    
    @field_validator("password")
    @classmethod
    def password_min_length(cls, v: str) -> str:
        from src.core.constants import ValidationRules
        if len(v) < ValidationRules.PASSWORD_MIN_LENGTH:
            raise ValueError(f"La contraseña debe tener al menos {ValidationRules.PASSWORD_MIN_LENGTH} caracteres")
        return v
    
    @field_validator("full_name")
    @classmethod
    def full_name_not_empty(cls, v: str) -> str:
        if not v or not v.strip():
            raise ValueError("El nombre completo es obligatorio")
        return v.strip()
    
    @field_validator("rol_student")
    @classmethod
    def validate_rol(cls, v: Optional[str], info) -> Optional[str]:
        if v:
            from src.core.constants import ValidationRules
            if len(v) != ValidationRules.ROL_LENGTH:
                raise ValueError(f"El ROL debe tener exactamente {ValidationRules.ROL_LENGTH} dígitos")
            if not v.isdigit():
                raise ValueError("El ROL debe contener solo dígitos")
        return v
    
    @field_validator("rut_student")
    @classmethod
    def validate_rut(cls, v: Optional[str]) -> Optional[str]:
        if v:
            from src.core.constants import ValidationRules, ValidationPatterns
            import re
            if not re.match(ValidationPatterns.RUT, v):
                raise ValueError("El RUT no tiene un formato válido")
        return v
    
    model_config = {
        "json_schema_extra": {
            "example": {
                "email": "nuevo.estudiante@usm.cl",
                "password": "SecurePass123!",
                "full_name": "Juan Pérez González",
                "campus_acronym": "CC",
                "user_type": "STUDENT",
                "rol_student": "2019012345",
                "rut_student": "12345678-9"
            }
        }
    }


class RefreshTokenRequest(BaseModel):
    """Schema para refresh token"""
    refresh_token: str
    
    model_config = {
        "json_schema_extra": {
            "example": {
                "refresh_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
            }
        }
    }


# =============================================================================
# RESPONSE SCHEMAS
# =============================================================================

class TokenResponse(BaseModel):
    """Schema para respuesta de tokens"""
    access_token: str
    refresh_token: str
    token_type: str = "Bearer"
    expires_in: int
    
    model_config = {
        "json_schema_extra": {
            "example": {
                "access_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
                "refresh_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
                "token_type": "Bearer",
                "expires_in": 3600
            }
        }
    }


class UserResponse(BaseModel):
    """Schema para respuesta de usuario"""
    id: int
    email: str
    full_name: str
    campus_acronym: str
    campus_name: str
    user_type: str
    rol_student: Optional[str] = None
    rut_student: Optional[str] = None
    
    model_config = {
        "from_attributes": True,
        "json_schema_extra": {
            "example": {
                "id": 1,
                "email": "estudiante@usm.cl",
                "full_name": "Juan Pérez González",
                "campus_acronym": "CC",
                "campus_name": "Casa Central",
                "user_type": "STUDENT",
                "rol_student": "2019012345",
                "rut_student": "12345678-9"
            }
        }
    }


class LoginResponse(BaseModel):
    """Schema para respuesta completa de login"""
    user: UserResponse
    tokens: TokenResponse
    
    model_config = {
        "json_schema_extra": {
            "example": {
                "user": {
                    "id": 1,
                    "email": "estudiante@usm.cl",
                    "full_name": "Juan Pérez González",
                    "campus_acronym": "CC",
                    "campus_name": "Casa Central",
                    "user_type": "STUDENT",
                    "rol_student": "2019012345",
                    "rut_student": "12345678-9"
                },
                "tokens": {
                    "access_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
                    "refresh_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
                    "token_type": "Bearer",
                    "expires_in": 3600
                }
            }
        }
    }


class MessageResponse(BaseModel):
    """Schema para respuestas simples con mensaje"""
    message: str
    
    model_config = {
        "json_schema_extra": {
            "example": {
                "message": "Operación exitosa"
            }
        }
    }
