from pydantic import BaseModel, Field
from typing import Optional
from utils.constants import MAX_LENGTH_ACRONYM, MAX_LENGTH_NAME

class SubjectOut(BaseModel):
    id_subject: int
    acronym: str = Field(..., max_length=MAX_LENGTH_ACRONYM)
    subject: str = Field(..., max_length=MAX_LENGTH_NAME)
    credits: int
    id_department: int
    department: Optional[str] = None  