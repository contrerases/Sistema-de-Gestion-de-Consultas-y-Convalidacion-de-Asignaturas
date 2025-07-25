from pydantic import BaseModel, Field
from utils.constants import MAX_LENGTH_NAME

class CurriculumCourseIn(BaseModel):
    curriculum_course: str = Field(..., max_length=MAX_LENGTH_NAME)
    description: str = Field(..., max_length=MAX_LENGTH_NAME)
    id_curriculum_course_type: int 