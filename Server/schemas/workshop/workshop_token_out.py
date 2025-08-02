from pydantic import BaseModel, Field
from datetime import datetime
from utils.constants import MAX_LENGTH_NAME, MAX_LENGTH_EMAIL

class WorkshopTokenOut(BaseModel):
    id: int
    id_workshop: int
    token: str
    id_professor: int
    expiration_at: datetime
    created_at: datetime
    used_at: datetime | None
    created_by: int
    is_used: bool
    workshop_name: str = Field(..., max_length=MAX_LENGTH_NAME)
    professor_name: str = Field(..., max_length=MAX_LENGTH_NAME)
    professor_email: str = Field(..., max_length=MAX_LENGTH_EMAIL)
    created_by_name: str = Field(..., max_length=MAX_LENGTH_NAME) 