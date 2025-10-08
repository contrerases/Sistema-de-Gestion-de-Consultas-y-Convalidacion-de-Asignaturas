"""
Schemas Pydantic para CAMPUS
Sistema: SGSCT
"""
from pydantic import BaseModel, field_validator


class CampusCreate(BaseModel):
    """Schema para crear campus"""
    acronym: str
    name: str
    location: str
    
    @field_validator("acronym", "name", "location")
    @classmethod
    def fields_not_empty(cls, v: str) -> str:
        if not v or not v.strip():
            raise ValueError("El campo no puede estar vacío")
        return v.strip()
    
    model_config = {
        "json_schema_extra": {
            "example": {
                "acronym": "CC",
                "name": "Casa Central",
                "location": "Valparaíso"
            }
        }
    }


class CampusUpdate(BaseModel):
    """Schema para actualizar campus"""
    acronym: str
    name: str
    location: str
    
    @field_validator("acronym", "name", "location")
    @classmethod
    def fields_not_empty(cls, v: str) -> str:
        if not v or not v.strip():
            raise ValueError("El campo no puede estar vacío")
        return v.strip()
    
    model_config = {
        "json_schema_extra": {
            "example": {
                "acronym": "CC",
                "name": "Casa Central",
                "location": "Valparaíso"
            }
        }
    }


class CampusResponse(BaseModel):
    """Schema para respuesta de campus"""
    id: int
    acronym: str
    name: str
    location: str
    
    model_config = {
        "from_attributes": True,
        "json_schema_extra": {
            "example": {
                "id": 1,
                "acronym": "CC",
                "name": "Casa Central",
                "location": "Valparaíso"
            }
        }
    }
