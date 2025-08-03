from fastapi import APIRouter
from typing import List
from schemas.curriculum_courses_type.type_out import TypeOut
from services.curriculum_courses_type_service import get_all_curriculum_courses_types_service

router = APIRouter(prefix="/curriculum-courses-types", tags=["curriculum-courses-types"])

@router.get("/", response_model=List[TypeOut])
def get_curriculum_courses_types():
    """Obtiene lista de tipos de cursos curriculares"""
    return get_all_curriculum_courses_types_service() 