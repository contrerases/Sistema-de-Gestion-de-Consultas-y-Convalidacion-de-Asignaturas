from pydantic import BaseModel


class TypeCourseBase(BaseModel):
    id: int
    name: str
