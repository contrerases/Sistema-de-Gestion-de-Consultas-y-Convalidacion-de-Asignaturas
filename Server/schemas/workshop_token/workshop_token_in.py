from pydantic import BaseModel, validator
from datetime import datetime, timedelta
from typing import Optional

class WorkshopTokenIn(BaseModel):
    id_workshop: int
    id_professor: int
    expiration_hours: int = 24  # Por defecto 24 horas
    
    @validator('expiration_hours')
    def validate_expiration_hours(cls, v):
        if v < 1 or v > 168:  # Entre 1 hora y 1 semana
            raise ValueError('Las horas de expiración deben estar entre 1 y 168')
        return v
    
    class Config:
        from_attributes = True 