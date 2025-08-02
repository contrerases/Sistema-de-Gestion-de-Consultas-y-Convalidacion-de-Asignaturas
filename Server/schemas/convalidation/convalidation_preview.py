from pydantic import BaseModel, Field
from utils.constants import MAX_LENGTH_NAME
from datetime import datetime

class ConvalidationPreview(BaseModel):
    id_convalidation: int
    id_request: int
    id_convalidation_state: int
    rut_student: str
    student_name: str = Field(..., max_length=MAX_LENGTH_NAME)
    convalidation_type: str = Field(..., max_length=MAX_LENGTH_NAME)
    convalidation_state: str = Field(..., max_length=MAX_LENGTH_NAME)
    curriculum_course: str = Field(..., max_length=MAX_LENGTH_NAME)
    sent_at: datetime 