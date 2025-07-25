from pydantic import BaseModel, Field
from utils.constants import MAX_LENGTH_NAME

class WorkshopInscriptionOut(BaseModel):
    id_inscription: int
    id_workshop: int
    id_student: int
    rut_student: str
    semester: str
    year: int
    is_convalidated: bool
    id_curriculum_course: int
    curriculum_course: str 