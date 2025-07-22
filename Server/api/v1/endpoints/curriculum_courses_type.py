from fastapi import APIRouter
from services.curriculum_courses_type_service import get_all_curriculum_courses_types_service
from schemas.curriculum_courses_type.type_out import CurriculumCourseTypeOut
from typing import List

router = APIRouter(prefix="/curriculum-courses-types", tags=["curriculum-courses-types"])

@router.get("/", response_model=List[CurriculumCourseTypeOut])
def get_all_curriculum_courses_types():
    return get_all_curriculum_courses_types_service() 