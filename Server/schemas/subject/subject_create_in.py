from pydantic import BaseModel, Field
from utils.constants import MAX_LENGTH_ACRONYM, MAX_LENGTH_NAME, MIN_CREDITS, MAX_CREDITS

class SubjectCreateIn(BaseModel):
    acronym: str = Field(..., max_length=MAX_LENGTH_ACRONYM)
    name: str = Field(..., max_length=MAX_LENGTH_NAME)
    id_department: int
    credits: int 