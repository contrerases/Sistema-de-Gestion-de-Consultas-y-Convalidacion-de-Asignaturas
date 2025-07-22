from pydantic import BaseModel, Field
from utils.constants import MAX_LENGTH_NAME, MIN_GRADE, MAX_GRADE

class WorkshopGradeOut(BaseModel):
    id_workshop_grade: int
    id_student: int
    name_student: str = Field(..., max_length=MAX_LENGTH_NAME)
    rut_student: str
    rol_student: str
    campus_student: str
    id_workshop: int
    workshop: str = Field(..., max_length=MAX_LENGTH_NAME)
    semester: str
    year: int
    grade: int = Field(..., ge=MIN_GRADE, le=MAX_GRADE) 