from database.connection import get_db_connection
from utils.constants import PROCEDURES
from typing import Optional, List, Dict, Any

# =============================================================================
# FUNCIONES DE CONVALIDACIONES
# =============================================================================

def get_convalidations() -> List[dict]:
    """Obtiene lista de convalidaciones con datos mínimos para preview"""
    with get_db_connection() as conn:
        with conn.cursor(dictionary=True) as cursor:
            cursor.callproc(PROCEDURES['get_convalidations'])
            return cursor.fetchall()

def get_convalidations_pending() -> List[dict]:
    """Obtiene convalidaciones pendientes con datos mínimos"""
    with get_db_connection() as conn:
        with conn.cursor(dictionary=True) as cursor:
            cursor.callproc(PROCEDURES['get_convalidations_pending'])
            return cursor.fetchall()

def get_convalidations_by_student(id_student: int) -> List[dict]:
    """Obtiene convalidaciones de un estudiante con datos mínimos"""
    with get_db_connection() as conn:
        with conn.cursor(dictionary=True) as cursor:
            cursor.callproc(PROCEDURES['get_convalidations_by_student'], [id_student])
            return cursor.fetchall()

def get_convalidations_by_student_rut(student_rut: str) -> List[dict]:
    """Obtiene convalidaciones por RUT del estudiante con datos mínimos"""
    with get_db_connection() as conn:
        with conn.cursor(dictionary=True) as cursor:
            cursor.callproc(PROCEDURES['get_convalidations_by_student_rut'], [student_rut])
            return cursor.fetchall()

def get_convalidations_by_student_rol(student_rol: str) -> List[dict]:
    """Obtiene convalidaciones por ROL del estudiante con datos mínimos"""
    with get_db_connection() as conn:
        with conn.cursor(dictionary=True) as cursor:
            cursor.callproc(PROCEDURES['get_convalidations_by_student_rol'], [student_rol])
            return cursor.fetchall()

def get_convalidations_by_student_name(student_name: str) -> List[dict]:
    """Obtiene convalidaciones por nombre del estudiante con datos mínimos"""
    with get_db_connection() as conn:
        with conn.cursor(dictionary=True) as cursor:
            cursor.callproc(PROCEDURES['get_convalidations_by_student_name'], [student_name])
            return cursor.fetchall()

def get_convalidations_by_reviewed_by(id_reviewed_by: int) -> List[dict]:
    """Obtiene convalidaciones revisadas por un administrador con datos mínimos"""
    with get_db_connection() as conn:
        with conn.cursor(dictionary=True) as cursor:
            cursor.callproc(PROCEDURES['get_convalidations_by_reviewed_by'], [id_reviewed_by])
            return cursor.fetchall()

def get_convalidations_by_curriculum_course(id_curriculum_course: int) -> List[dict]:
    """Obtiene convalidaciones por curso curricular con datos mínimos"""
    with get_db_connection() as conn:
        with conn.cursor(dictionary=True) as cursor:
            cursor.callproc(PROCEDURES['get_convalidations_by_curriculum_course'], [id_curriculum_course])
            return cursor.fetchall()

def get_convalidations_by_workshop(id_workshop: int) -> List[dict]:
    """Obtiene convalidaciones por taller con datos mínimos"""
    with get_db_connection() as conn:
        with conn.cursor(dictionary=True) as cursor:
            cursor.callproc(PROCEDURES['get_convalidations_by_workshop'], [id_workshop])
            return cursor.fetchall()

def get_convalidations_by_activity(id_activity: int) -> List[dict]:
    """Obtiene convalidaciones por actividad con datos mínimos"""
    with get_db_connection() as conn:
        with conn.cursor(dictionary=True) as cursor:
            cursor.callproc(PROCEDURES['get_convalidations_by_activity'], [id_activity])
            return cursor.fetchall()

def get_convalidations_by_type(id_convalidation_type: int) -> List[dict]:
    """Obtiene convalidaciones por tipo con datos mínimos"""
    with get_db_connection() as conn:
        with conn.cursor(dictionary=True) as cursor:
            cursor.callproc(PROCEDURES['get_convalidations_by_type'], [id_convalidation_type])
            return cursor.fetchall()

def get_convalidations_by_state(id_convalidation_state: int) -> List[dict]:
    """Obtiene convalidaciones por estado con datos mínimos"""
    with get_db_connection() as conn:
        with conn.cursor(dictionary=True) as cursor:
            cursor.callproc(PROCEDURES['get_convalidations_by_state'], [id_convalidation_state])
            return cursor.fetchall()

def get_convalidation_by_id(id_convalidation: int) -> Optional[dict]:
    """Obtiene una convalidación específica con datos completos"""
    with get_db_connection() as conn:
        with conn.cursor(dictionary=True) as cursor:
            cursor.callproc(PROCEDURES['get_convalidation_by_id'], [id_convalidation])
            result = cursor.fetchall()
            return result[0] if result else None

def create_convalidation(id_student: int, id_convalidation_type: int, id_curriculum_course: int, id_workshop: Optional[int] = None, activity_name: Optional[str] = None, description: Optional[str] = None, file_name: Optional[str] = None, file_data: Optional[bytes] = None, id_subject: Optional[int] = None, id_department: Optional[int] = None) -> bool:
    """Crea una nueva convalidación"""
    with get_db_connection() as conn:
        with conn.cursor() as cursor:
            cursor.callproc(PROCEDURES['create_convalidation'], [id_student, id_convalidation_type, id_curriculum_course, id_workshop, activity_name, description, file_name, file_data, id_subject, id_department])
            return True

def review_convalidation(id_convalidation: int, id_convalidation_state: int, review_comments: str, id_reviewed_by: int) -> bool:
    """Revisa una convalidación"""
    with get_db_connection() as conn:
        with conn.cursor() as cursor:
            cursor.callproc(PROCEDURES['review_convalidation'], [id_convalidation, id_convalidation_state, review_comments, id_reviewed_by])
            return True

def drop_convalidation_while_no_reviewed_by(id_convalidation: int) -> bool:
    """Elimina una convalidación que no ha sido revisada"""
    with get_db_connection() as conn:
        with conn.cursor() as cursor:
            cursor.callproc(PROCEDURES['drop_convalidation_while_no_reviewed_by_id'], [id_convalidation])
            return True

def filter_convalidations(filters: Dict[str, Any]) -> List[dict]:
    """Filtra convalidaciones según criterios específicos"""
    with get_db_connection() as conn:
        with conn.cursor(dictionary=True) as cursor:
            # Convertir filtros a parámetros del procedure
            params = [
                filters.get('id_student'),
                filters.get('id_convalidation_type'),
                filters.get('id_convalidation_state'),
                filters.get('id_curriculum_course'),
                filters.get('student_rut'),
                filters.get('student_name'),
                filters.get('id_reviewed_by'),
                filters.get('id_workshop'),
                filters.get('id_subject'),
                filters.get('id_department'),
                filters.get('student_campus')
            ]
            cursor.callproc(PROCEDURES['filter_convalidations'], params)
            return cursor.fetchall() 