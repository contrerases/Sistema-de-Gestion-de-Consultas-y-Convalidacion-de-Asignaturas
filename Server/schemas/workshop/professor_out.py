from pydantic import BaseModel, Field
from datetime import datetime
from utils.constants import MAX_LENGTH_NAME, MAX_LENGTH_EMAIL

class ProfessorOut(BaseModel):
    id: int
    name: str = Field(..., max_length=MAX_LENGTH_NAME)
    email: str = Field(..., max_length=MAX_LENGTH_EMAIL)
    is_active: bool
    created_at: datetime
    updated_at: datetime 