from pydantic import BaseModel, Field
from utils.constants import MAX_LENGTH_NAME

class CurriculumCourseOut(BaseModel):
    id_curriculum_course: int
    curriculum_course: str = Field(..., max_length=MAX_LENGTH_NAME)
    description: str = Field(..., max_length=MAX_LENGTH_NAME)
    id_curriculum_course_type: int
    curriculum_course_type: str = Field(..., max_length=MAX_LENGTH_NAME) 