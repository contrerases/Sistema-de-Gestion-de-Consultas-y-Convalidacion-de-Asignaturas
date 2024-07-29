from pydantic import BaseModel


class CurriculumCourseBase(BaseModel):
    id: int
    name: str
    id_type_curriculum_course: int

class CurriculumCoursePost(BaseModel):
    name: str
