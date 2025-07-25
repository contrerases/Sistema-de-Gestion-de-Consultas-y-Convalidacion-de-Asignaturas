from fastapi import HTTPException
from typing import List
from crud.curriculum_course import get_curriculum_courses, get_curriculum_courses_not_convalidated_by_student, create_curriculum_course, update_curriculum_course, delete_curriculum_course
from schemas.curriculum_course.curriculum_course_in import CurriculumCourseIn
from schemas.curriculum_course.curriculum_course_out import CurriculumCourseOut

def get_all_curriculum_courses_service() -> List[CurriculumCourseOut]:
    rows = get_curriculum_courses()
    return [CurriculumCourseOut(**row) for row in rows]

def get_curriculum_course_by_id_service(id_curriculum_course: int) -> CurriculumCourseOut:
    rows = get_curriculum_courses(id_curriculum_course=id_curriculum_course)
    if not rows:
        raise HTTPException(status_code=404, detail="Curso de malla no encontrado")
    return CurriculumCourseOut(**rows[0])

def get_curriculum_courses_by_type_service(id_curriculum_course_type: int) -> List[CurriculumCourseOut]:
    rows = get_curriculum_courses(id_curriculum_course_type=id_curriculum_course_type)
    return [CurriculumCourseOut(**row) for row in rows]

def get_curriculum_courses_not_convalidated_by_student_service(id_student: int) -> List[CurriculumCourseOut]:
    rows = get_curriculum_courses_not_convalidated_by_student(id_student)
    return [CurriculumCourseOut(**row) for row in rows]

def create_curriculum_course_service(course: CurriculumCourseIn) -> bool:
    return create_curriculum_course(course.curriculum_course, course.description, course.id_curriculum_course_type)

def update_curriculum_course_service(id_curriculum_course: int, course: CurriculumCourseIn) -> bool:
    return update_curriculum_course(id_curriculum_course, course.curriculum_course, course.description, course.id_curriculum_course_type)

def delete_curriculum_course_service(id_curriculum_course: int) -> bool:
    return delete_curriculum_course(id_curriculum_course) 