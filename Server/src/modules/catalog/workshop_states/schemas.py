"""
Esquemas Pydantic para WORKSHOP_STATES
Sistema: SGSCT
"""
from pydantic import BaseModel, Field, field_validator
from typing import Optional


class WorkshopStateCreate(BaseModel):
    workshop_state: str = Field(..., min_length=1, max_length=255)
    description: Optional[str] = Field(None, max_length=500)

    @field_validator("workshop_state")
    @classmethod
    def validate_state_name(cls, v: str) -> str:
        if not v.strip():
            raise ValueError("El nombre del estado del taller no puede estar vacío")
        return v.strip()

    model_config = {
        "from_attributes": True,
        "json_schema_extra": {
            "example": {
                "workshop_state": "Pendiente",
                "description": "Taller en espera de aprobación"
            }
        }
    }


class WorkshopStateUpdate(BaseModel):
    workshop_state: Optional[str] = Field(None, min_length=1, max_length=255)
    description: Optional[str] = Field(None, max_length=500)

    @field_validator("workshop_state")
    @classmethod
    def validate_state_name(cls, v: Optional[str]) -> Optional[str]:
        if v is not None and not v.strip():
            raise ValueError("El nombre del estado del taller no puede estar vacío")
        return v.strip() if v else None

    model_config = {"from_attributes": True}


class WorkshopStateResponse(BaseModel):
    id: int
    workshop_state: str
    description: Optional[str] = None

    model_config = {
        "from_attributes": True,
        "json_schema_extra": {
            "example": {
                "id": 1,
                "workshop_state": "Pendiente",
                "description": "Taller en espera de aprobación"
            }
        }
    }
