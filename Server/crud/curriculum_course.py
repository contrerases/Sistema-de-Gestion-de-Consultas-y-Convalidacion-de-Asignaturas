from database.connection import get_db_connection
from utils.constants import PROCEDURES
from typing import Optional, List, Dict, Any

def get_curriculum_courses(id_curriculum_course: Optional[int] = None, id_curriculum_course_type: Optional[int] = None) -> List[Dict[str, Any]]:
    with get_db_connection() as conn:
        with conn.cursor(dictionary=True) as cursor:
            cursor.callproc(PROCEDURES['get_curriculum_courses'], [id_curriculum_course, id_curriculum_course_type])
            return cursor.fetchall()

def get_curriculum_courses_not_convalidated_by_student(id_student: int) -> List[Dict[str, Any]]:
    with get_db_connection() as conn:
        with conn.cursor(dictionary=True) as cursor:
            cursor.callproc(PROCEDURES['get_curriculum_courses_not_convalidated_by_student'], [id_student])
            return cursor.fetchall()

def create_curriculum_course(curriculum_course: str, description: str, id_curriculum_course_type: int) -> bool:
    with get_db_connection() as conn:
        with conn.cursor() as cursor:
            cursor.callproc(PROCEDURES['create_curriculum_course'], [curriculum_course, description, id_curriculum_course_type])
            return True

def update_curriculum_course(id_curriculum_course: int, curriculum_course: str, description: str, id_curriculum_course_type: int) -> bool:
    with get_db_connection() as conn:
        with conn.cursor() as cursor:
            cursor.callproc(PROCEDURES['update_curriculum_course'], [id_curriculum_course, curriculum_course, description, id_curriculum_course_type])
            return True

def delete_curriculum_course(id_curriculum_course: int) -> bool:
    with get_db_connection() as conn:
        with conn.cursor() as cursor:
            cursor.callproc(PROCEDURES['delete_curriculum_course'], [id_curriculum_course])
            return True 