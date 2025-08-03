from database.connection import get_db_connection
from utils.constants import PROCEDURES
from typing import Optional, List

# =============================================================================
# FUNCIONES DE ESTUDIANTES
# =============================================================================

def get_students() -> List[dict]:
    """Obtiene lista de estudiantes con datos mínimos para preview"""
    with get_db_connection() as conn:
        with conn.cursor(dictionary=True) as cursor:
            cursor.callproc(PROCEDURES['get_students'])
            return cursor.fetchall()

def get_student_by_rut(rut_student: str) -> Optional[dict]:
    """Obtiene un estudiante por RUT con datos mínimos"""
    with get_db_connection() as conn:
        with conn.cursor(dictionary=True) as cursor:
            cursor.callproc(PROCEDURES['get_student_by_rut'], [rut_student])
            result = cursor.fetchall()
            return result[0] if result else None

def get_student_by_name(first_names: str) -> List[dict]:
    """Obtiene estudiantes por nombre con datos mínimos"""
    with get_db_connection() as conn:
        with conn.cursor(dictionary=True) as cursor:
            cursor.callproc(PROCEDURES['get_student_by_name'], [first_names])
            return cursor.fetchall()

def get_student_by_rol(rol_student: str) -> Optional[dict]:
    """Obtiene un estudiante por ROL con datos mínimos"""
    with get_db_connection() as conn:
        with conn.cursor(dictionary=True) as cursor:
            cursor.callproc(PROCEDURES['get_student_by_rol'], [rol_student])
            result = cursor.fetchall()
            return result[0] if result else None

def get_student_by_id(student_id: int) -> Optional[dict]:
    """Obtiene un estudiante por ID con datos completos"""
    with get_db_connection() as conn:
        with conn.cursor(dictionary=True) as cursor:
            cursor.callproc(PROCEDURES['get_student_by_id'], [student_id])
            result = cursor.fetchall()
            return result[0] if result else None

def create_student(first_names, last_names, campus, rol_student, rut_student, campus_student, email, password_hash):
    """Crea un nuevo estudiante"""
    with get_db_connection() as conn:
        with conn.cursor() as cursor:
            cursor.callproc(PROCEDURES['create_student'], [first_names, last_names, campus, rol_student, rut_student, campus_student, email, password_hash])
            return True

def update_student(student_id, first_names, last_names, campus, rol_student, rut_student, campus_student, email, password_hash):
    """Actualiza un estudiante existente"""
    with get_db_connection() as conn:
        with conn.cursor() as cursor:
            cursor.callproc(PROCEDURES['update_student'], [student_id, first_names, last_names, campus, rol_student, rut_student, campus_student, email, password_hash])
            return True

def delete_student(student_id):
    """Elimina un estudiante"""
    with get_db_connection() as conn:
        with conn.cursor() as cursor:
            cursor.callproc(PROCEDURES['delete_student'], [student_id])
            return True 