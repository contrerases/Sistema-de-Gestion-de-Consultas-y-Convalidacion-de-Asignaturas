from pydantic import BaseModel


class CurriculumCoursesBase(BaseModel):
    id: int
    name: str
