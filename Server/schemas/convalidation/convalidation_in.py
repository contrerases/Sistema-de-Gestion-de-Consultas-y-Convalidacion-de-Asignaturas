from pydantic import BaseModel, Field
from typing import Optional
from utils.constants import MAX_LENGTH_NAME, MAX_LENGTH_DESCRIPTION

class ConvalidationIn(BaseModel):
    id_student: int
    id_convalidation_type: int
    id_curriculum_course: int
    id_workshop: Optional[int] = None
    activity_name: Optional[str] = Field(None, max_length=MAX_LENGTH_NAME)
    description: Optional[str] = Field(None, max_length=MAX_LENGTH_DESCRIPTION)
    file_name: Optional[str] = Field(None, max_length=MAX_LENGTH_NAME)
    file_data: Optional[bytes] = None
    id_subject: Optional[int] = None
    id_department: Optional[int] = None 