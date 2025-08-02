from pydantic import BaseModel, Field
from utils.constants import MAX_LENGTH_NAME

class StatsWorkshopOut(BaseModel):
    id_workshop: int
    workshop_name: str = Field(..., max_length=MAX_LENGTH_NAME)
    semester: str
    year: int
    inscriptions_number: int
    limit_inscriptions: int
    available_slots: int
    total_grades: int
    average_grade: float | None
    min_grade: float | None
    max_grade: float | None
    workshop_state: str = Field(..., max_length=MAX_LENGTH_NAME)
    professor_name: str = Field(..., max_length=MAX_LENGTH_NAME) 