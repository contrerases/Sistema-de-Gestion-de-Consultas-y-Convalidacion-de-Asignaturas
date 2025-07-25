from pydantic import BaseModel, Field
from utils.constants import MAX_LENGTH_NAME

class DepartmentOut(BaseModel):
    id_department: int
    department: str = Field(..., max_length=MAX_LENGTH_NAME) 