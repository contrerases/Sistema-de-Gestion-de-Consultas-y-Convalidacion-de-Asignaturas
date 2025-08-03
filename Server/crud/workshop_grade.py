from database.connection import get_db_connection
from utils.constants import PROCEDURES
from typing import Optional, List, Dict, Any

# =============================================================================
# FUNCIONES DE CALIFICACIONES
# =============================================================================

def get_workshop_grades() -> List[dict]:
    """Obtiene lista de calificaciones con datos mínimos para preview"""
    with get_db_connection() as conn:
        with conn.cursor(dictionary=True) as cursor:
            cursor.callproc(PROCEDURES['get_workshop_grades'])
            return cursor.fetchall()

def get_workshop_grades_by_workshop(id_workshop: int) -> List[dict]:
    """Obtiene calificaciones de un taller específico con datos mínimos"""
    with get_db_connection() as conn:
        with conn.cursor(dictionary=True) as cursor:
            cursor.callproc(PROCEDURES['get_workshop_grades_by_workshop'], [id_workshop])
            return cursor.fetchall()

def get_workshop_grades_by_student(id_student: int) -> List[dict]:
    """Obtiene calificaciones de un estudiante con datos mínimos"""
    with get_db_connection() as conn:
        with conn.cursor(dictionary=True) as cursor:
            cursor.callproc(PROCEDURES['get_workshop_grades_by_student'], [id_student])
            return cursor.fetchall()

def get_workshop_grade_by_id(id_grade: int) -> Optional[dict]:
    """Obtiene una calificación específica con datos completos"""
    with get_db_connection() as conn:
        with conn.cursor(dictionary=True) as cursor:
            cursor.callproc(PROCEDURES['get_workshop_grade_by_id'], [id_grade])
            result = cursor.fetchall()
            return result[0] if result else None

def create_workshop_grade(id_student: int, id_workshop: int, grade: float) -> bool:
    """Crea una nueva calificación"""
    with get_db_connection() as conn:
        with conn.cursor() as cursor:
            cursor.callproc(PROCEDURES['create_workshop_grade'], [id_student, id_workshop, grade])
            return True 