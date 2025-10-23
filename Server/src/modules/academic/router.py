"""
Router principal del módulo Academic
Incluye subrouters de campus, departments, subjects, curriculum_courses_slots
Sistema: SGSCT
"""

from fastapi import APIRouter
from src.modules.academic.campus.router import router as campus_router
from src.modules.academic.departments.router import router as departments_router
from src.modules.academic.subjects.router import router as subjects_router
from src.modules.academic.curriculum_courses_slots.router import (
    router as curriculum_courses_slots_router,
)

router = APIRouter(prefix="/academics")

router.include_router(campus_router)
router.include_router(departments_router)
router.include_router(subjects_router)
router.include_router(curriculum_courses_slots_router)
