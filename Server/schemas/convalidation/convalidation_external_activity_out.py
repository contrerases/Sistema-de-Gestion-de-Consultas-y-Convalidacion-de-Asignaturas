from pydantic import BaseModel, Field
from typing import Optional
from utils.constants import MAX_LENGTH_NAME, MAX_LENGTH_DESCRIPTION
from datetime import datetime

class ConvalidationExternalActivityOut(BaseModel):
    # vw_request
    id_request: int
    sent_at: Optional[datetime] = None
    reviewed_at: Optional[datetime] = None
    id_student: int
    student_name: str
    student_rut: str
    student_rol: str
    student_campus: str
    id_reviewed_by: Optional[int] = None
    reviewed_by: Optional[str] = None
    # vw_convalidations
    id_convalidation: int
    review_comments: Optional[str] = None
    id_convalidation_type: int
    convalidation_type: str = Field(..., max_length=MAX_LENGTH_NAME)
    id_convalidation_state: int
    convalidation_state: str = Field(..., max_length=MAX_LENGTH_NAME)
    id_curriculum_course: int
    curriculum_course: str = Field(..., max_length=MAX_LENGTH_NAME)
    # específicos de external activity
    activity_name: str = Field(..., max_length=MAX_LENGTH_NAME)
    description: Optional[str] = Field(None, max_length=MAX_LENGTH_DESCRIPTION)
    file_name: Optional[str] = Field(None, max_length=MAX_LENGTH_NAME)
    file_data: Optional[bytes] = None 