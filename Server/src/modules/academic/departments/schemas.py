"""
Schemas Pydantic para DEPARTMENTS
Sistema: SGSCT
"""
from pydantic import BaseModel, field_validator


class DepartmentCreate(BaseModel):
    """Schema para crear departamento"""
    name: str
    
    @field_validator("name")
    @classmethod
    def name_not_empty(cls, v: str) -> str:
        if not v or not v.strip():
            raise ValueError("El nombre no puede estar vacío")
        return v.strip()
    
    model_config = {
        "json_schema_extra": {
            "example": {
                "name": "Departamento de Informática"
            }
        }
    }


class DepartmentUpdate(BaseModel):
    """Schema para actualizar departamento"""
    name: str
    
    @field_validator("name")
    @classmethod
    def name_not_empty(cls, v: str) -> str:
        if not v or not v.strip():
            raise ValueError("El nombre no puede estar vacío")
        return v.strip()
    
    model_config = {
        "json_schema_extra": {
            "example": {
                "name": "Departamento de Informática Actualizado"
            }
        }
    }


class DepartmentResponse(BaseModel):
    """Schema para respuesta de departamento"""
    id: int
    name: str
    
    model_config = {
        "from_attributes": True,
        "json_schema_extra": {
            "example": {
                "id": 1,
                "name": "Departamento de Informática"
            }
        }
    }
