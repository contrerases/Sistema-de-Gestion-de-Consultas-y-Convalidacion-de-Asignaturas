from pydantic import BaseModel, Field
from utils.constants import MAX_LENGTH_NAME, MAX_LENGTH_DESCRIPTION, MIN_YEAR, MAX_YEAR
from datetime import datetime

class WorkshopOut(BaseModel):
    id_workshop: int
    workshop_name: str = Field(..., max_length=MAX_LENGTH_NAME)
    semester: str
    year: int = Field(..., ge=MIN_YEAR, le=MAX_YEAR)
    description: str = Field(..., max_length=MAX_LENGTH_DESCRIPTION)
    inscription_start_date: datetime
    inscription_end_date: datetime
    course_start_date: datetime
    course_end_date: datetime
    inscriptions_number: int
    limit_inscriptions: int
    syllabus_data: str | None
    id_professor: int
    professor_name: str = Field(..., max_length=MAX_LENGTH_NAME)
    professor_email: str
    id_workshop_state: int
    workshop_state: str = Field(..., max_length=MAX_LENGTH_NAME)
    state_description: str | None
    available_slots: int
    is_inscription_open: bool
    is_course_active: bool
    is_full: bool 