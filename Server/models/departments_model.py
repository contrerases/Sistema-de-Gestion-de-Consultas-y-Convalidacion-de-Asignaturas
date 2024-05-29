from pydantic import BaseModel


class DepartmentBase(BaseModel):
    id: int
    name: str

class DepartmentResponse(BaseModel):
    id: int
    name: str

class DepartmentPost(BaseModel):
    name: str