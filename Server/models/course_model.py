from pydantic import BaseModel

class Course(BaseModel):
    id: int
    acronym: str
    name: str
