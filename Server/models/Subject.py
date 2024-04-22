from pydantic import BaseModel


class Subject(BaseModel):
    id: int
    name: str
    type: str