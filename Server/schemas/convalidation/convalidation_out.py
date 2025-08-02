from pydantic import BaseModel, Field
from typing import Optional
from datetime import datetime
from utils.constants import MAX_LENGTH_NAME, MAX_LENGTH_EMAIL

class ConvalidationOut(BaseModel):
    id_convalidation: int
    review_comments: str | None
    id_request: int
    id_convalidation_type: int
    id_convalidation_state: int
    id_curriculum_course: int
    # Datos de la solicitud
    sent_at: datetime
    reviewed_at: datetime | None
    id_student: int
    id_reviewed_by: int | None
    # Datos del estudiante
    rol_student: str
    rut_student: str
    student_name: str = Field(..., max_length=MAX_LENGTH_NAME)
    student_campus: str
    student_email: str = Field(..., max_length=MAX_LENGTH_EMAIL)
    # Datos del revisor
    reviewer_id: int | None
    reviewer_name: str | None = Field(None, max_length=MAX_LENGTH_NAME)
    reviewer_campus: str | None
    reviewer_email: str | None = Field(None, max_length=MAX_LENGTH_EMAIL)
    # Datos de tipos y estados
    convalidation_type: str = Field(..., max_length=MAX_LENGTH_NAME)
    convalidation_state: str = Field(..., max_length=MAX_LENGTH_NAME)
    curriculum_course: str = Field(..., max_length=MAX_LENGTH_NAME)
    curriculum_course_type: str = Field(..., max_length=MAX_LENGTH_NAME) 