from database.connection import get_db_connection
from utils.constants import PROCEDURES
from typing import Optional, List

def get_curriculum_courses() -> List[dict]:
    """Obtiene lista de cursos curriculares"""
    with get_db_connection() as conn:
        with conn.cursor(dictionary=True) as cursor:
            cursor.callproc(PROCEDURES['get_curriculum_courses'])
            return cursor.fetchall()

def get_curriculum_courses_by_type(id_curriculum_course_type: int) -> List[dict]:
    """Obtiene cursos curriculares por tipo"""
    with get_db_connection() as conn:
        with conn.cursor(dictionary=True) as cursor:
            cursor.callproc(PROCEDURES['get_curriculum_courses_by_type'], [id_curriculum_course_type])
            return cursor.fetchall()

def get_curriculum_courses_not_convalidated_by_student(id_student: int) -> List[dict]:
    """Obtiene cursos curriculares no convalidados por estudiante"""
    with get_db_connection() as conn:
        with conn.cursor(dictionary=True) as cursor:
            cursor.callproc(PROCEDURES['get_curriculum_courses_not_convalidated_by_student'], [id_student])
            return cursor.fetchall()

def create_curriculum_course(name: str, id_curriculum_course_type: int) -> bool:
    """Crea un nuevo curso curricular"""
    with get_db_connection() as conn:
        with conn.cursor() as cursor:
            cursor.callproc(PROCEDURES['create_curriculum_course'], [name, id_curriculum_course_type])
            return True

def update_curriculum_course(curriculum_course_id: int, name: str, id_curriculum_course_type: int) -> bool:
    """Actualiza un curso curricular existente"""
    with get_db_connection() as conn:
        with conn.cursor() as cursor:
            cursor.callproc(PROCEDURES['update_curriculum_course'], [curriculum_course_id, name, id_curriculum_course_type])
            return True

def delete_curriculum_course(curriculum_course_id: int) -> bool:
    """Elimina un curso curricular"""
    with get_db_connection() as conn:
        with conn.cursor() as cursor:
            cursor.callproc(PROCEDURES['delete_curriculum_course'], [curriculum_course_id])
            return True 