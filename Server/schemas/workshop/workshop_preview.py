from pydantic import BaseModel, Field
from utils.constants import MAX_LENGTH_NAME, MIN_YEAR, MAX_YEAR

class WorkshopPreview(BaseModel):
    id_workshop: int
    workshop_name: str = Field(..., max_length=MAX_LENGTH_NAME)
    semester: str
    year: int = Field(..., ge=MIN_YEAR, le=MAX_YEAR)
    inscriptions_number: int
    limit_inscriptions: int
    professor_name: str = Field(..., max_length=MAX_LENGTH_NAME)
    workshop_state: str = Field(..., max_length=MAX_LENGTH_NAME)
    available_slots: int
    is_inscription_open: bool 