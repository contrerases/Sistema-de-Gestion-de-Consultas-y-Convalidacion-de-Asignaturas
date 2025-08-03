from fastapi import HTTPException
from typing import List
import mariadb
from crud.curriculum_course import get_curriculum_courses, get_curriculum_courses_by_type, get_curriculum_courses_not_convalidated_by_student, create_curriculum_course, update_curriculum_course, delete_curriculum_course
from schemas.curriculum_course.curriculum_course_in import CurriculumCourseIn
from schemas.curriculum_course.curriculum_course_out import CurriculumCourseOut

def get_all_curriculum_courses_service() -> List[CurriculumCourseOut]:
    """Obtiene lista de cursos curriculares"""
    try:
        rows = get_curriculum_courses()
        return [CurriculumCourseOut(**row) for row in rows]
    except mariadb.Error as e:
        raise HTTPException(status_code=500, detail=str(e))

def get_curriculum_course_by_id_service(id_curriculum_course: int) -> CurriculumCourseOut:
    rows = get_curriculum_courses(id_curriculum_course=id_curriculum_course)
    if not rows:
        raise HTTPException(status_code=404, detail="Curso de malla no encontrado")
    return CurriculumCourseOut(**rows[0])

def get_curriculum_courses_by_type_service(id_curriculum_course_type: int) -> List[CurriculumCourseOut]:
    """Obtiene cursos curriculares por tipo"""
    try:
        rows = get_curriculum_courses_by_type(id_curriculum_course_type)
        return [CurriculumCourseOut(**row) for row in rows]
    except mariadb.Error as e:
        raise HTTPException(status_code=500, detail=str(e))

def get_curriculum_courses_not_convalidated_by_student_service(id_student: int) -> List[CurriculumCourseOut]:
    """Obtiene cursos curriculares no convalidados por estudiante"""
    try:
        rows = get_curriculum_courses_not_convalidated_by_student(id_student)
        return [CurriculumCourseOut(**row) for row in rows]
    except mariadb.Error as e:
        raise HTTPException(status_code=500, detail=str(e))

def create_curriculum_course_service(course: CurriculumCourseIn) -> bool:
    """Crea un nuevo curso curricular"""
    try:
        return create_curriculum_course(course.name, course.id_curriculum_course_type)
    except mariadb.Error as e:
        raise HTTPException(status_code=400, detail=str(e))

def update_curriculum_course_service(id_curriculum_course: int, course: CurriculumCourseIn) -> bool:
    """Actualiza un curso curricular existente"""
    try:
        return update_curriculum_course(id_curriculum_course, course.name, course.id_curriculum_course_type)
    except mariadb.Error as e:
        raise HTTPException(status_code=400, detail=str(e))

def delete_curriculum_course_service(id_curriculum_course: int) -> bool:
    """Elimina un curso curricular"""
    try:
        return delete_curriculum_course(id_curriculum_course)
    except mariadb.Error as e:
        raise HTTPException(status_code=400, detail=str(e)) 