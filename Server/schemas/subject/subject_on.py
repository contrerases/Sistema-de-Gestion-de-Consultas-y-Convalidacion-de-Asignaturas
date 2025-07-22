from pydantic import BaseModel, Field
from typing import Optional
from utils.constants import MAX_LENGTH_ACRONYM, MAX_LENGTH_NAME

class SubjectOn(BaseModel):
    id: Optional[int] = Field(None, alias="id_subject")
    acronym: Optional[str] = Field(None, max_length=MAX_LENGTH_ACRONYM)
    name: Optional[str] = Field(None, max_length=MAX_LENGTH_NAME)
    id_department: Optional[int] = None
    credits: Optional[int] = None
    department: Optional[str] = None
