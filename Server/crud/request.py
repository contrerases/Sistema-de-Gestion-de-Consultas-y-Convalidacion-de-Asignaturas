from database.connection import get_db_connection
from utils.constants import PROCEDURES
from typing import Optional, List

# =============================================================================
# FUNCIONES DE SOLICITUDES
# =============================================================================

def get_requests() -> List[dict]:
    """Obtiene lista de solicitudes con datos mínimos para preview"""
    with get_db_connection() as conn:
        with conn.cursor(dictionary=True) as cursor:
            cursor.callproc(PROCEDURES['get_requests'])
            return cursor.fetchall()

def get_requests_by_student(id_student: int) -> List[dict]:
    """Obtiene las solicitudes de un estudiante específico"""
    with get_db_connection() as conn:
        with conn.cursor(dictionary=True) as cursor:
            cursor.callproc(PROCEDURES['get_requests'], [None, id_student, None])
            return cursor.fetchall()

def get_request_by_id(id_request: int) -> Optional[dict]:
    """Obtiene una solicitud específica por ID con datos completos"""
    with get_db_connection() as conn:
        with conn.cursor(dictionary=True) as cursor:
            cursor.callproc(PROCEDURES['get_request_by_id'], [id_request])
            result = cursor.fetchall()
            return result[0] if result else None

def get_request_convalidations(id_request: int) -> List[dict]:
    """Obtiene las convalidaciones de una solicitud específica"""
    with get_db_connection() as conn:
        with conn.cursor(dictionary=True) as cursor:
            cursor.callproc(PROCEDURES['get_request_convalidations'], [id_request])
            return cursor.fetchall() 