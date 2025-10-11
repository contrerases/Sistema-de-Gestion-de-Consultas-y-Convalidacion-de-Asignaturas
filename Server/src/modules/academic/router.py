"""
Router principal del módulo academic
Agrega routers de submódulos
"""
from fastapi import APIRouter

from .subjects.router import router as subjects_router
from .curriculum_courses_slots.router import router as curriculum_course_slots_router
from .departments.router import router as departments_router

router = APIRouter(prefix="/academic", tags=["academic"])

router.include_router(subjects_router)
router.include_router(curriculum_course_slots_router)
router.include_router(departments_router)
