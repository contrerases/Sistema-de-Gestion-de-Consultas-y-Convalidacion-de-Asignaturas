from pydantic import BaseModel, Field
from utils.constants import MAX_LENGTH_NAME, MIN_YEAR, MAX_YEAR

class WorkshopGradePreview(BaseModel):
    id_grade: int
    id_student: int
    id_workshop: int
    grade: float
    rut_student: str
    student_name: str = Field(..., max_length=MAX_LENGTH_NAME)
    workshop_name: str = Field(..., max_length=MAX_LENGTH_NAME)
    semester: str
    year: int = Field(..., ge=MIN_YEAR, le=MAX_YEAR) 