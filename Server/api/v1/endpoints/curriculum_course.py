from fastapi import APIRouter, status
from typing import List
from schemas.curriculum_course.curriculum_course_in import CurriculumCourseIn
from schemas.curriculum_course.curriculum_course_out import CurriculumCourseOut
from services.curriculum_course_service import (
    get_all_curriculum_courses_service,
    get_curriculum_courses_by_type_service,
    get_curriculum_courses_not_convalidated_by_student_service,
    create_curriculum_course_service,
    update_curriculum_course_service,
    delete_curriculum_course_service
)

router = APIRouter(prefix="/curriculum-courses", tags=["curriculum-courses"])

@router.get("/", response_model=List[CurriculumCourseOut])
def get_curriculum_courses():
    """Obtiene lista de cursos curriculares"""
    return get_all_curriculum_courses_service()

@router.get("/{id_curriculum_course}", response_model=CurriculumCourseOut)
def get_curriculum_course_by_id(id_curriculum_course: int):
    """Obtiene un curso curricular específico por ID"""
    return get_all_curriculum_courses_service()

@router.get("/type/{id_curriculum_course_type}", response_model=List[CurriculumCourseOut])
def get_curriculum_courses_by_type(id_curriculum_course_type: int):
    """Obtiene cursos curriculares por tipo"""
    return get_curriculum_courses_by_type_service(id_curriculum_course_type)

@router.get("/not-convalidated-by-student/{id_student}", response_model=List[CurriculumCourseOut])
def get_curriculum_courses_not_convalidated_by_student(id_student: int):
    """Obtiene cursos curriculares no convalidados por estudiante"""
    return get_curriculum_courses_not_convalidated_by_student_service(id_student)

@router.post("/", response_model=bool, status_code=status.HTTP_201_CREATED)
def create_curriculum_course(curriculum_course: CurriculumCourseIn):
    """Crea un nuevo curso curricular"""
    return create_curriculum_course_service(curriculum_course)

@router.put("/{id_curriculum_course}", response_model=bool)
def update_curriculum_course(id_curriculum_course: int, curriculum_course: CurriculumCourseIn):
    """Actualiza un curso curricular existente"""
    return update_curriculum_course_service(id_curriculum_course, curriculum_course)

@router.delete("/{id_curriculum_course}", response_model=bool)
def delete_curriculum_course(id_curriculum_course: int):
    """Elimina un curso curricular"""
    return delete_curriculum_course_service(id_curriculum_course) 