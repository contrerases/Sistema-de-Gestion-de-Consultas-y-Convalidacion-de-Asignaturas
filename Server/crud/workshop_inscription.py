from database.connection import get_db_connection
from utils.constants import PROCEDURES
from typing import Optional, List, Dict, Any

# =============================================================================
# FUNCIONES DE INSCRIPCIONES
# =============================================================================

def get_workshop_inscriptions() -> List[dict]:
    """Obtiene lista de inscripciones con datos mínimos para preview"""
    with get_db_connection() as conn:
        with conn.cursor(dictionary=True) as cursor:
            cursor.callproc(PROCEDURES['get_workshop_inscriptions'])
            return cursor.fetchall()

def get_workshop_inscriptions_by_workshop(id_workshop: int) -> List[dict]:
    """Obtiene inscripciones de un taller específico con datos mínimos"""
    with get_db_connection() as conn:
        with conn.cursor(dictionary=True) as cursor:
            cursor.callproc(PROCEDURES['get_workshop_inscriptions_by_workshop'], [id_workshop])
            return cursor.fetchall()

def get_workshop_inscriptions_by_student(id_student: int) -> List[dict]:
    """Obtiene inscripciones de un estudiante con datos mínimos"""
    with get_db_connection() as conn:
        with conn.cursor(dictionary=True) as cursor:
            cursor.callproc(PROCEDURES['get_workshop_inscriptions_by_student'], [id_student])
            return cursor.fetchall()

def get_workshop_inscriptions_by_student_rut(student_rut: str) -> List[dict]:
    """Obtiene inscripciones por RUT del estudiante con datos mínimos"""
    with get_db_connection() as conn:
        with conn.cursor(dictionary=True) as cursor:
            cursor.callproc(PROCEDURES['get_workshop_inscriptions_by_student_rut'], [student_rut])
            return cursor.fetchall()

def get_workshop_inscriptions_by_student_name(student_name: str) -> List[dict]:
    """Obtiene inscripciones por nombre del estudiante con datos mínimos"""
    with get_db_connection() as conn:
        with conn.cursor(dictionary=True) as cursor:
            cursor.callproc(PROCEDURES['get_workshop_inscriptions_by_student_name'], [student_name])
            return cursor.fetchall()

def get_workshop_inscriptions_by_student_rol(student_rol: str) -> List[dict]:
    """Obtiene inscripciones por ROL del estudiante con datos mínimos"""
    with get_db_connection() as conn:
        with conn.cursor(dictionary=True) as cursor:
            cursor.callproc(PROCEDURES['get_workshop_inscriptions_by_student_rol'], [student_rol])
            return cursor.fetchall()

def get_workshop_inscriptions_by_curriculum_course(id_curriculum_course: int) -> List[dict]:
    """Obtiene inscripciones por curso curricular con datos mínimos"""
    with get_db_connection() as conn:
        with conn.cursor(dictionary=True) as cursor:
            cursor.callproc(PROCEDURES['get_workshop_inscriptions_by_curriculum_course'], [id_curriculum_course])
            return cursor.fetchall()

def get_workshop_inscription_by_id(id_inscription: int) -> Optional[dict]:
    """Obtiene una inscripción específica con datos completos"""
    with get_db_connection() as conn:
        with conn.cursor(dictionary=True) as cursor:
            cursor.callproc(PROCEDURES['get_workshop_inscription_by_id'], [id_inscription])
            result = cursor.fetchall()
            return result[0] if result else None

def create_workshop_inscription(id_student: int, id_workshop: int, is_convalidated: bool, id_curriculum_course: Optional[int] = None) -> bool:
    """Crea una nueva inscripción a taller"""
    with get_db_connection() as conn:
        with conn.cursor() as cursor:
            cursor.callproc(PROCEDURES['create_workshop_inscription'], [id_student, id_workshop, is_convalidated, id_curriculum_course])
            return True

def cancel_workshop_inscription(id_inscription: int) -> bool:
    """Cancela una inscripción a taller"""
    with get_db_connection() as conn:
        with conn.cursor() as cursor:
            cursor.callproc(PROCEDURES['cancel_workshop_inscription'], [id_inscription])
            return True

def unregister_workshop_after_start(id_inscription: int) -> bool:
    """Da de baja una inscripción después del inicio del taller"""
    with get_db_connection() as conn:
        with conn.cursor() as cursor:
            cursor.callproc(PROCEDURES['unregister_workshop_after_start'], [id_inscription])
            return True 