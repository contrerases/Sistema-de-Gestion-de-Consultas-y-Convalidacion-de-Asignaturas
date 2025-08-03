from pydantic import BaseModel, Field
from utils.constants import MAX_LENGTH_NAME

class ProfessorPreview(BaseModel):
    id: int
    name: str = Field(..., max_length=MAX_LENGTH_NAME)
    email: str 