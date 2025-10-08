"""
Esquemas Pydantic para CONVALIDATION_TYPES
Sistema: SGSCT
"""
from pydantic import BaseModel, Field, field_validator
from typing import Optional


class ConvalidationTypeCreate(BaseModel):
    convalidation_type: str = Field(..., min_length=1, max_length=255)

    @field_validator("convalidation_type")
    @classmethod
    def validate_type_name(cls, v: str) -> str:
        if not v.strip():
            raise ValueError("El nombre del tipo de convalidación no puede estar vacío")
        return v.strip()

    model_config = {
        "from_attributes": True,
        "json_schema_extra": {
            "example": {
                "convalidation_type": "Movilidad Internacional"
            }
        }
    }


class ConvalidationTypeUpdate(BaseModel):
    convalidation_type: Optional[str] = Field(None, min_length=1, max_length=255)

    @field_validator("convalidation_type")
    @classmethod
    def validate_type_name(cls, v: Optional[str]) -> Optional[str]:
        if v is not None and not v.strip():
            raise ValueError("El nombre del tipo de convalidación no puede estar vacío")
        return v.strip() if v else None

    model_config = {"from_attributes": True}


class ConvalidationTypeResponse(BaseModel):
    id: int
    convalidation_type: str

    model_config = {
        "from_attributes": True,
        "json_schema_extra": {
            "example": {
                "id": 1,
                "convalidation_type": "Movilidad Internacional"
            }
        }
    }
