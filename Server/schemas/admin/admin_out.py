from pydantic import BaseModel, Field
from utils.constants import MAX_LENGTH_NAME, MAX_LENGTH_EMAIL

class AdminOut(BaseModel):
    id_admin: int
    name_admin: str = Field(..., max_length=MAX_LENGTH_NAME)
    campus_admin: str = Field(..., max_length=MAX_LENGTH_NAME)
    email_admin: str = Field(..., max_length=MAX_LENGTH_EMAIL) 