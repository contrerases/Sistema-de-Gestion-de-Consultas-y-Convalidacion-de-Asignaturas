from database.connection import get_db_connection
from utils.constants import PROCEDURES
from typing import Optional, List

# =============================================================================
# FUNCIONES PREVIEW (datos mínimos para listas)
# =============================================================================

def get_professors_active() -> List[dict]:
    """Obtiene lista de profesores activos"""
    with get_db_connection() as conn:
        with conn.cursor(dictionary=True) as cursor:
            cursor.callproc(PROCEDURES['get_professors_active'])
            return cursor.fetchall()

# =============================================================================
# FUNCIONES COMPLETE (datos completos para detalles)
# =============================================================================

def get_professor_by_id(id_professor: int) -> Optional[dict]:
    """Obtiene un profesor específico por ID"""
    with get_db_connection() as conn:
        with conn.cursor(dictionary=True) as cursor:
            cursor.callproc(PROCEDURES['get_professor_by_id'], [id_professor])
            result = cursor.fetchall()
            return result[0] if result else None

def create_professor(name: str, email: str) -> bool:
    """Crea un nuevo profesor"""
    with get_db_connection() as conn:
        with conn.cursor() as cursor:
            cursor.callproc(PROCEDURES['create_professor'], [name, email])
            return True

def update_professor(id_professor: int, name: str, email: str) -> bool:
    """Actualiza un profesor existente"""
    with get_db_connection() as conn:
        with conn.cursor() as cursor:
            cursor.callproc(PROCEDURES['update_professor'], [id_professor, name, email])
            return True 