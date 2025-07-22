from crud.curriculum_courses_type import get_all_curriculum_courses_types
from schemas.curriculum_courses_type.type_out import CurriculumCourseTypeOut
from typing import List
 
def get_all_curriculum_courses_types_service() -> List[CurriculumCourseTypeOut]:
    rows = get_all_curriculum_courses_types()
    return [CurriculumCourseTypeOut(**row) for row in rows] 