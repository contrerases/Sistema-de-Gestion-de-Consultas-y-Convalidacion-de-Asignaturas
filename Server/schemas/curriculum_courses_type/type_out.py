from pydantic import BaseModel
 
class CurriculumCoursesTypeOut(BaseModel):
    id_curriculum_course_type: int
    curriculum_course_type: str 