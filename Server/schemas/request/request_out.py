from pydantic import BaseModel, Field
from datetime import datetime
from typing import Optional

class RequestOut(BaseModel):
    id_request: int
    sent_at: datetime
    reviewed_at: Optional[datetime] = None
    id_student: int
    id_reviewed_by: Optional[int] = None
    # Datos del estudiante
    student_name: str
    student_rut: str
    student_campus: str
    student_email: Optional[str] = None
    # Datos del revisor (si existe)
    reviewer_name: Optional[str] = None
    reviewer_campus: Optional[str] = None
    reviewer_email: Optional[str] = None 