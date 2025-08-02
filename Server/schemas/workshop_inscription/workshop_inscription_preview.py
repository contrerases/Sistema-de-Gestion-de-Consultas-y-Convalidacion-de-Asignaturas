from pydantic import BaseModel, Field
from utils.constants import MAX_LENGTH_NAME, MIN_YEAR, MAX_YEAR

class WorkshopInscriptionPreview(BaseModel):
    id_inscription: int
    id_student: int
    id_workshop: int
    is_convalidated: bool
    rut_student: str
    student_name: str = Field(..., max_length=MAX_LENGTH_NAME)
    workshop_name: str = Field(..., max_length=MAX_LENGTH_NAME)
    semester: str
    year: int = Field(..., ge=MIN_YEAR, le=MAX_YEAR)
    workshop_state: str = Field(..., max_length=MAX_LENGTH_NAME) 