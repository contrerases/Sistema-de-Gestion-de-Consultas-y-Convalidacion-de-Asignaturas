from pydantic import BaseModel, Field
from utils.constants import MAX_LENGTH_NAME, MIN_GRADE, MAX_GRADE

class WorkshopGradeOut(BaseModel):
    id_grade: int
    id_workshop: int
    workshop: str = Field(..., max_length=MAX_LENGTH_NAME)
    id_student: int
    rut_student: str
    semester: str
    year: int
    grade: int = Field(..., ge=MIN_GRADE, le=MAX_GRADE) 