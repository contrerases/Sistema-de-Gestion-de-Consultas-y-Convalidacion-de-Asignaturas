from pydantic import BaseModel


class TypeCurriculumCourseBase(BaseModel):
    id: int
    name: str
    

    
class TypeCurriculumCourseResponse(TypeCurriculumCourseBase):
    pass

