from pydantic import BaseModel


class SubjectBase(BaseModel):
    id: int
    acronym: str
    name: str
    id_department: int
    credits: int

class SubjectResponse(BaseModel):
    id: int
    acronym: str
    name: str
    department_name: str
    credits: int

class SubjectPost(BaseModel):
    acronym: str
    name: str
    id_department: int
    credits: int