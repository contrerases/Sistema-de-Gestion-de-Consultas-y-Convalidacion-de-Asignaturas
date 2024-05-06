from pydantic import BaseModel


class CurriculumCourseBase(BaseModel):
    id: int
    name: str

class CurriculumCoursePost(BaseModel):
    name: str
