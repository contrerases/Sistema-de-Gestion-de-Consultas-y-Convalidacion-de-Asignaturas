from src.modules.academic.curriculum_courses_slots.base.router import (
    router as curriculum_courses_slots_router,
)
from src.modules.academic.curriculum_courses_slots.type.router import (
    router as curriculum_course_types_router,
)

from fastapi import APIRouter

router = APIRouter(
    prefix="/curriculums-courses-slots", tags=["Curriculum Course Slots"]
)

router.include_router(curriculum_courses_slots_router)
router.include_router(curriculum_course_types_router)
