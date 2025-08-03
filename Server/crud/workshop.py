from database.connection import get_db_connection
from utils.constants import PROCEDURES
from typing import Optional, List, Dict, Any

# =============================================================================
# FUNCIONES DE TALLERES
# =============================================================================

def get_workshops() -> List[dict]:
    """Obtiene lista de talleres con datos mínimos para preview"""
    with get_db_connection() as conn:
        with conn.cursor(dictionary=True) as cursor:
            cursor.callproc(PROCEDURES['get_workshops'])
            return cursor.fetchall()

def get_workshops_by_state(id_workshop_state: int) -> List[dict]:
    """Obtiene talleres por estado con datos mínimos"""
    with get_db_connection() as conn:
        with conn.cursor(dictionary=True) as cursor:
            cursor.callproc(PROCEDURES['get_workshops_by_state'], [id_workshop_state])
            return cursor.fetchall()

def get_workshops_by_professor(id_professor: int) -> List[dict]:
    """Obtiene talleres por profesor con datos mínimos"""
    with get_db_connection() as conn:
        with conn.cursor(dictionary=True) as cursor:
            cursor.callproc(PROCEDURES['get_workshops_by_professor'], [id_professor])
            return cursor.fetchall()

def search_workshops(search_term: str) -> List[dict]:
    """Busca talleres por término de búsqueda con datos mínimos"""
    with get_db_connection() as conn:
        with conn.cursor(dictionary=True) as cursor:
            cursor.callproc(PROCEDURES['search_workshops'], [search_term])
            return cursor.fetchall()

def get_workshop_by_id(id_workshop: int) -> Optional[dict]:
    """Obtiene un taller específico con datos completos"""
    with get_db_connection() as conn:
        with conn.cursor(dictionary=True) as cursor:
            cursor.callproc(PROCEDURES['get_workshop_by_id'], [id_workshop])
            result = cursor.fetchall()
            return result[0] if result else None

def create_workshop(name: str, semester: str, year: int, professor: str, description: str, inscription_start_date: str, inscription_end_date: str, course_start_date: str, course_end_date: str, available: bool, limit_inscriptions: int, id_workshop_state: int) -> bool:
    """Crea un nuevo taller"""
    with get_db_connection() as conn:
        with conn.cursor() as cursor:
            cursor.callproc(PROCEDURES['create_workshop'], [name, semester, year, professor, description, inscription_start_date, inscription_end_date, course_start_date, course_end_date, available, limit_inscriptions, id_workshop_state])
            return True

def update_workshop(workshop_id: int, name: str, semester: str, year: int, professor: str, description: str, inscription_start_date: str, inscription_end_date: str, course_start_date: str, course_end_date: str, available: bool, limit_inscriptions: int, id_workshop_state: int) -> bool:
    """Actualiza un taller existente"""
    with get_db_connection() as conn:
        with conn.cursor() as cursor:
            cursor.callproc(PROCEDURES['update_workshop'], [workshop_id, name, semester, year, professor, description, inscription_start_date, inscription_end_date, course_start_date, course_end_date, available, limit_inscriptions, id_workshop_state])
            return True

def delete_workshop(workshop_id: int) -> bool:
    """Elimina un taller"""
    with get_db_connection() as conn:
        with conn.cursor() as cursor:
            cursor.callproc(PROCEDURES['delete_workshop'], [workshop_id])
            return True

def change_workshop_state(workshop_id: int, new_state_id: int, new_inscription_start_date: str, new_inscription_end_date: str, new_course_start_date: str, new_course_end_date: str) -> bool:
    """Cambia el estado de un taller"""
    with get_db_connection() as conn:
        with conn.cursor() as cursor:
            cursor.callproc(PROCEDURES['change_workshop_state'], [workshop_id, new_state_id, new_inscription_start_date, new_inscription_end_date, new_course_start_date, new_course_end_date])
            return True 