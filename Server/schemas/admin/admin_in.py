from pydantic import BaseModel, Field, EmailStr
from utils.constants import MAX_LENGTH_NAME, MAX_LENGTH_EMAIL, MIN_LENGTH_PASSWORD

class AdminIn(BaseModel):
    first_names: str = Field(..., max_length=MAX_LENGTH_NAME)
    last_names: str = Field(..., max_length=MAX_LENGTH_NAME)
    campus: str = Field(..., max_length=MAX_LENGTH_NAME)
    email: EmailStr = Field(..., max_length=MAX_LENGTH_EMAIL)
    password: str = Field(..., min_length=MIN_LENGTH_PASSWORD) 