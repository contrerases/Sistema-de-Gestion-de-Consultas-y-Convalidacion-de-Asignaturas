from pydantic import BaseModel, Field
from utils.constants import MAX_LENGTH_NAME

class DepartmentOut(BaseModel):
    id: int
    name: str = Field(..., max_length=MAX_LENGTH_NAME) 

class DepartmentCreate(BaseModel):
    name: str = Field(..., max_length=MAX_LENGTH_NAME)


class DepartmentUpdate(BaseModel):
    name: str = Field(..., max_length=MAX_LENGTH_NAME)

class DepartmentDelete(BaseModel):
    id: int