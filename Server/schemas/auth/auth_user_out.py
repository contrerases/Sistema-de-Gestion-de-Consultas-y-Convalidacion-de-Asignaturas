from typing import Optional
from datetime import datetime
from pydantic import BaseModel, Field
from utils.constants import MAX_LENGTH_NAME, MAX_LENGTH_EMAIL

class AuthUserOut(BaseModel):
    id_auth_user: int
    email: str = Field(..., max_length=MAX_LENGTH_EMAIL)
    id_user: int
    first_names: str = Field(..., max_length=MAX_LENGTH_NAME)
    last_names: str = Field(..., max_length=MAX_LENGTH_NAME)
    common_name: str = Field(..., max_length=MAX_LENGTH_NAME)
    full_name: str = Field(..., max_length=MAX_LENGTH_NAME)
    campus: str = Field(..., max_length=MAX_LENGTH_NAME)
    created_at: datetime
    updated_at: datetime
    user_type: str  
    id_student: Optional[int] = None
    rol_student: Optional[str] = None
    rut_student: Optional[str] = None
    campus_student: Optional[str] = None
    id_admin: Optional[int] = None