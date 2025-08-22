from pydantic import BaseModel, Field
from typing import Optional
from datetime import datetime

class AuthUser(BaseModel):
    """Modelo para usuario autenticado"""
    id_user: str = Field(..., description="ID único del usuario")
    email: str = Field(..., description="Correo electrónico del usuario")
    rut: Optional[str] = Field(..., description="RUT del estudiante")
    rol_student: Optional[str] = Field(..., description="Rol estudiantil del estudiante")
    user_type: str = Field(..., description="Rol del usuario en el sistema")
    name: Optional[str] = Field(None, description="Nombre completo del usuario")
    campus: str = Field(..., description="Campus universitario del usuario")
    exp: float = Field(..., description="Timestamp de expiración del token")
    
    class Config:
        json_encoders = {
            datetime: lambda v: v.isoformat()
        }
    
    def is_admin(self) -> bool:
        """Verifica si el usuario es administrador"""
        return self.user_type == "ADMINISTRATOR"
    
    def is_student(self) -> bool:
        """Verifica si el usuario es estudiante"""
        return self.user_type == "STUDENT"
    
    def is_token_expired(self) -> bool:
        """Verifica si el token ha expirado"""
        return datetime.utcnow().timestamp() > self.exp