from pydantic import BaseModel
 
class CurriculumCourseTypeOut(BaseModel):
    id: int
    name: str 