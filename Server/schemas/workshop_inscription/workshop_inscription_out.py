from pydantic import BaseModel, Field
from utils.constants import MAX_LENGTH_NAME

class WorkshopInscriptionOut(BaseModel):
    id_inscription: int
    id_student: int
    name_student: str = Field(..., max_length=MAX_LENGTH_NAME)
    rut_student: str
    campus_student: str
    rol_student: str
    id_workshop: int
    workshop: str = Field(..., max_length=MAX_LENGTH_NAME)
    semester: str
    year: int
    is_convalidated: bool
    id_curriculum_course: int
    curriculum_course: str 