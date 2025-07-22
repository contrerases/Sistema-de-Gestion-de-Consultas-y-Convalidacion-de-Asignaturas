from pydantic import BaseModel, Field
from typing import Optional
from utils.constants import MAX_LENGTH_NAME

class ConvalidationOn(BaseModel):
    id_request: Optional[int] = None
    id_convalidation: Optional[int] = None
    id_convalidation_type: Optional[int] = None
    id_convalidation_state: Optional[int] = None
    id_curriculum_course: Optional[int] = None
    id_student: Optional[int] = None
    student_rol: Optional[str] = Field(None, max_length=MAX_LENGTH_NAME)
    student_rut: Optional[str] = Field(None, max_length=MAX_LENGTH_NAME)
    student_name: Optional[str] = Field(None, max_length=MAX_LENGTH_NAME)
    id_reviewed_by: Optional[int] = None
    id_workshop: Optional[int] = None
    id_subject: Optional[int] = None
    id_department: Optional[int] = None
    student_campus: Optional[str] = Field(None, max_length=MAX_LENGTH_NAME)
    activity_name: Optional[str] = Field(None, max_length=MAX_LENGTH_NAME) 