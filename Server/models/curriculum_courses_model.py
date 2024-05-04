from pydantic import BaseModel


class CurriculumCourseBase(BaseModel):
    id: int
    name: str
