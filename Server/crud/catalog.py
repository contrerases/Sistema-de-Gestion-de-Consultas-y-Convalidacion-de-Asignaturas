from database.connection import get_db_connection
from utils.constants import PROCEDURES
from typing import List

def get_convalidation_types() -> List[dict]:
    """Obtiene los tipos de convalidación"""
    with get_db_connection() as conn:
        with conn.cursor(dictionary=True) as cursor:
            cursor.callproc(PROCEDURES['get_convalidation_types'])
            return cursor.fetchall()

def get_convalidation_states() -> List[dict]:
    """Obtiene los estados de convalidación"""
    with get_db_connection() as conn:
        with conn.cursor(dictionary=True) as cursor:
            cursor.callproc(PROCEDURES['get_convalidation_states'])
            return cursor.fetchall()

def get_workshop_states() -> List[dict]:
    """Obtiene los estados de talleres"""
    with get_db_connection() as conn:
        with conn.cursor(dictionary=True) as cursor:
            cursor.callproc(PROCEDURES['get_workshop_states'])
            return cursor.fetchall()

def get_curriculum_course_types() -> List[dict]:
    """Obtiene los tipos de cursos curriculares"""
    with get_db_connection() as conn:
        with conn.cursor(dictionary=True) as cursor:
            cursor.callproc(PROCEDURES['get_curriculum_courses_types'])
            return cursor.fetchall()