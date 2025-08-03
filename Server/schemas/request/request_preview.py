from pydantic import BaseModel, Field
from datetime import datetime

class RequestPreview(BaseModel):
    id_request: int
    sent_at: datetime
    id_student: int
    student_rut: str
    student_name: str
    reviewed_at: datetime | None = None 