"""
Schemas Pydantic para USER_TYPES
Sistema: SGSCT
"""
from pydantic import BaseModel, field_validator


class UserTypeCreate(BaseModel):
    """Schema para crear tipo de usuario"""
    user_type: str
    
    @field_validator("user_type")
    @classmethod
    def user_type_not_empty(cls, v: str) -> str:
        if not v or not v.strip():
            raise ValueError("El tipo de usuario no puede estar vacío")
        return v.strip()
    
    model_config = {
        "json_schema_extra": {
            "example": {
                "user_type": "STUDENT"
            }
        }
    }


class UserTypeUpdate(BaseModel):
    """Schema para actualizar tipo de usuario"""
    user_type: str
    
    @field_validator("user_type")
    @classmethod
    def user_type_not_empty(cls, v: str) -> str:
        if not v or not v.strip():
            raise ValueError("El tipo de usuario no puede estar vacío")
        return v.strip()
    
    model_config = {
        "json_schema_extra": {
            "example": {
                "user_type": "ADMINISTRATOR"
            }
        }
    }


class UserTypeResponse(BaseModel):
    """Schema para respuesta de tipo de usuario"""
    id: int
    user_type: str
    
    model_config = {
        "from_attributes": True,
        "json_schema_extra": {
            "example": {
                "id": 1,
                "user_type": "STUDENT"
            }
        }
    }
