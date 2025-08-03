from pydantic import BaseModel, EmailStr, validator
from utils.constants import MAX_LENGTH_NAME

class ProfessorIn(BaseModel):
    name: str
    email: EmailStr
    
    @validator('name')
    def validate_name(cls, v):
        if not v or not v.strip():
            raise ValueError('El nombre del profesor es requerido')
        if len(v) > MAX_LENGTH_NAME:
            raise ValueError(f'El nombre no puede exceder {MAX_LENGTH_NAME} caracteres')
        return v.strip()
    
    class Config:
        from_attributes = True 