from fastapi import APIRouter
from typing import List
from services.catalog_service import (
    get_convalidation_types_service,
    get_convalidation_states_service,
    get_workshop_states_service,
    get_curriculum_course_types_service
)

router = APIRouter(prefix="/catalogs", tags=["catalogs"])

@router.get("/convalidation-types")
def get_convalidation_types():
    """Obtiene los tipos de convalidación"""
    return get_convalidation_types_service()

@router.get("/convalidation-states")
def get_convalidation_states():
    """Obtiene los estados de convalidación"""
    return get_convalidation_states_service()

@router.get("/workshop-states")
def get_workshop_states():
    """Obtiene los estados de talleres"""
    return get_workshop_states_service()

@router.get("/curriculum-course-types")
def get_curriculum_course_types():
    """Obtiene los tipos de cursos curriculares"""
    return get_curriculum_course_types_service() 