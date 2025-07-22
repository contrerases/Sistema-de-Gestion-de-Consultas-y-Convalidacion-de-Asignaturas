from pydantic import BaseModel, Field
from utils.constants import MAX_LENGTH_NAME, MAX_LENGTH_DESCRIPTION, MIN_YEAR, MAX_YEAR

class WorkshopIn(BaseModel):
    name: str = Field(..., max_length=MAX_LENGTH_NAME)
    semester: str = Field(..., pattern='^(1|2)$')
    year: int = Field(..., ge=MIN_YEAR, le=MAX_YEAR)
    professor: str = Field(..., max_length=MAX_LENGTH_NAME)
    description: str = Field(..., max_length=MAX_LENGTH_DESCRIPTION)
    inscription_start_date: str
    inscription_end_date: str
    course_start_date: str
    course_end_date: str
    available: bool
    limit_inscriptions: int
    id_workshop_state: int 