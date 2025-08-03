from database.connection import get_db_connection
from utils.constants import PROCEDURES
from typing import Optional, List

# =============================================================================
# FUNCIONES PREVIEW (datos mínimos para listas)
# =============================================================================

def get_workshop_tokens_active() -> List[dict]:
    """Obtiene lista de tokens activos"""
    with get_db_connection() as conn:
        with conn.cursor(dictionary=True) as cursor:
            cursor.callproc(PROCEDURES['get_workshop_tokens_active'])
            return cursor.fetchall()

def get_workshop_tokens_expired() -> List[dict]:
    """Obtiene lista de tokens expirados"""
    with get_db_connection() as conn:
        with conn.cursor(dictionary=True) as cursor:
            cursor.callproc(PROCEDURES['get_workshop_tokens_expired'])
            return cursor.fetchall()

# =============================================================================
# FUNCIONES COMPLETE (datos completos para detalles)
# =============================================================================

def create_workshop_token(id_workshop: int, token: str, id_professor: int, expiration_at: str, created_by: int) -> bool:
    """Crea un nuevo token para un taller"""
    with get_db_connection() as conn:
        with conn.cursor() as cursor:
            cursor.callproc(PROCEDURES['create_workshop_token'], [id_workshop, token, id_professor, expiration_at, created_by])
            return True

def use_workshop_token(token: str) -> bool:
    """Usa un token de taller"""
    with get_db_connection() as conn:
        with conn.cursor() as cursor:
            cursor.callproc(PROCEDURES['use_workshop_token'], [token])
            return True 