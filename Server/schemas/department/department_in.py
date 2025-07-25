from pydantic import BaseModel, Field
from utils.constants import MAX_LENGTH_NAME

class DepartmentIn(BaseModel):
    department: str = Field(..., max_length=MAX_LENGTH_NAME) 