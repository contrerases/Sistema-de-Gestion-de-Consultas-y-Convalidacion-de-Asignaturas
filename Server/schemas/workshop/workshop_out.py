from pydantic import BaseModel, Field
from utils.constants import MAX_LENGTH_NAME, MAX_LENGTH_DESCRIPTION, MIN_YEAR, MAX_YEAR
from datetime import datetime

class WorkshopOut(BaseModel):
    id_workshop: int
    workshop: str = Field(..., max_length=MAX_LENGTH_NAME)
    semester: str
    year: int = Field(..., ge=MIN_YEAR, le=MAX_YEAR)
    professor: str = Field(..., max_length=MAX_LENGTH_NAME)
    description: str = Field(..., max_length=MAX_LENGTH_DESCRIPTION)
    inscription_start_date: datetime
    inscription_end_date: datetime
    course_start_date: datetime
    course_end_date: datetime
    available: bool
    limit_inscriptions: int
    id_workshop_state: int
    workshop_state: str = Field(..., max_length=MAX_LENGTH_NAME)
    inscriptions_count: int 