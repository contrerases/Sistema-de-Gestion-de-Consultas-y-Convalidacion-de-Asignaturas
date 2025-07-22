from pydantic import BaseModel, Field
from utils.constants import MAX_LENGTH_NAME, MAX_LENGTH_EMAIL

class StudentOut(BaseModel):
    id_student: int
    name_student: str = Field(..., max_length=MAX_LENGTH_NAME)
    rol_student: str
    rut_student: str
    campus_student: str
    email_student: str = Field(..., max_length=MAX_LENGTH_EMAIL) 