from fastapi import APIRouter, HTTPException, status
from typing import List
from schemas.curriculum_course.curriculum_course_in import CurriculumCourseIn
from schemas.curriculum_course.curriculum_course_out import CurriculumCourseOut
from services.curriculum_course_service import (
    get_all_curriculum_courses_service,
    get_curriculum_course_by_id_service,
    get_curriculum_courses_by_type_service,
    get_curriculum_courses_not_convalidated_by_student_service,
    create_curriculum_course_service,
    update_curriculum_course_service,
    delete_curriculum_course_service
)

router = APIRouter(prefix="/curriculum-courses", tags=["curriculum-courses"])

@router.get("/", response_model=List[CurriculumCourseOut])
def get_all_curriculum_courses():
    return get_all_curriculum_courses_service()

@router.get("/{id_curriculum_course}", response_model=CurriculumCourseOut)
def get_curriculum_course_by_id(id_curriculum_course: int):
    return get_curriculum_course_by_id_service(id_curriculum_course)

@router.get("/type/{id_curriculum_course_type}", response_model=List[CurriculumCourseOut])
def get_curriculum_courses_by_type(id_curriculum_course_type: int):
    return get_curriculum_courses_by_type_service(id_curriculum_course_type)

@router.get("/not-convalidated-by-student/{id_student}", response_model=List[CurriculumCourseOut])
def get_curriculum_courses_not_convalidated_by_student(id_student: int):
    return get_curriculum_courses_not_convalidated_by_student_service(id_student)

@router.post("/", response_model=bool, status_code=status.HTTP_201_CREATED)
def create_curriculum_course(course: CurriculumCourseIn):
    return create_curriculum_course_service(course)

@router.put("/{id_curriculum_course}", response_model=bool)
def update_curriculum_course(id_curriculum_course: int, course: CurriculumCourseIn):
    return update_curriculum_course_service(id_curriculum_course, course)

@router.delete("/{id_curriculum_course}", response_model=bool)
def delete_curriculum_course(id_curriculum_course: int):
    return delete_curriculum_course_service(id_curriculum_course) 