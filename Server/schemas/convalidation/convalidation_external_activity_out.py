from pydantic import BaseModel, Field
from typing import Optional
from utils.constants import MAX_LENGTH_NAME

class ConvalidationExternalActivityOut(BaseModel):
    id_convalidation: Optional[int] = None
    id_student: int
    id_convalidation_type: int
    id_curriculum_course: int
    id_activity_name: str = Field(..., max_length=MAX_LENGTH_NAME)
    description: Optional[str] = Field(None, max_length=MAX_LENGTH_NAME)
    file_name: Optional[str] = Field(None, max_length=MAX_LENGTH_NAME)
    file_data: Optional[bytes] = None
    id_department: Optional[int] = None 