"""
Esquemas Pydantic para CONVALIDATION_STATES
Sistema: SGSCT
"""
from pydantic import BaseModel, Field, field_validator
from typing import Optional


class ConvalidationStateCreate(BaseModel):
    convalidation_state: str = Field(..., min_length=1, max_length=255)
    description: Optional[str] = Field(None, max_length=500)

    @field_validator("convalidation_state")
    @classmethod
    def validate_state_name(cls, v: str) -> str:
        if not v.strip():
            raise ValueError("El nombre del estado de convalidación no puede estar vacío")
        return v.strip()

    model_config = {
        "from_attributes": True,
        "json_schema_extra": {
            "example": {
                "convalidation_state": "En Revisión",
                "description": "Solicitud en proceso de evaluación"
            }
        }
    }


class ConvalidationStateUpdate(BaseModel):
    convalidation_state: Optional[str] = Field(None, min_length=1, max_length=255)
    description: Optional[str] = Field(None, max_length=500)

    @field_validator("convalidation_state")
    @classmethod
    def validate_state_name(cls, v: Optional[str]) -> Optional[str]:
        if v is not None and not v.strip():
            raise ValueError("El nombre del estado de convalidación no puede estar vacío")
        return v.strip() if v else None

    model_config = {"from_attributes": True}


class ConvalidationStateResponse(BaseModel):
    id: int
    convalidation_state: str
    description: Optional[str] = None

    model_config = {
        "from_attributes": True,
        "json_schema_extra": {
            "example": {
                "id": 1,
                "convalidation_state": "En Revisión",
                "description": "Solicitud en proceso de evaluación"
            }
        }
    }
