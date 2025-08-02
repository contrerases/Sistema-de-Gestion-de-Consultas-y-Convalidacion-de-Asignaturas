from pydantic import BaseModel, Field
from utils.constants import MAX_LENGTH_NAME

class StudentPreview(BaseModel):
    id_student: int
    name_student: str = Field(..., max_length=MAX_LENGTH_NAME)
    rut_student: str
    campus_student: str 