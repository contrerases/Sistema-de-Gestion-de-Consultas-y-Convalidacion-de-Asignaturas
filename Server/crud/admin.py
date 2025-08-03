from database.connection import get_db_connection
from utils.constants import PROCEDURES
from typing import Optional, List

# =============================================================================
# FUNCIONES DE ADMINISTRADORES
# =============================================================================

def get_admins() -> List[dict]:
    """Obtiene lista de administradores con datos mínimos para preview"""
    with get_db_connection() as conn:
        with conn.cursor(dictionary=True) as cursor:
            cursor.callproc(PROCEDURES['get_admins'])
            return cursor.fetchall()

def get_admin_by_id(id_admin: int) -> Optional[dict]:
    """Obtiene un administrador por ID con datos mínimos"""
    with get_db_connection() as conn:
        with conn.cursor(dictionary=True) as cursor:
            cursor.callproc(PROCEDURES['get_admin_by_id'], [id_admin])
            result = cursor.fetchall()
            return result[0] if result else None

def get_admins_by_campus(campus: str) -> List[dict]:
    """Obtiene administradores por campus con datos mínimos"""
    with get_db_connection() as conn:
        with conn.cursor(dictionary=True) as cursor:
            cursor.callproc(PROCEDURES['get_admins_by_campus'], [campus])
            return cursor.fetchall()

def get_admin_by_email(email: str) -> Optional[dict]:
    """Obtiene un administrador por email con datos mínimos"""
    with get_db_connection() as conn:
        with conn.cursor(dictionary=True) as cursor:
            cursor.callproc(PROCEDURES['get_admin_by_email'], [email])
            result = cursor.fetchall()
            return result[0] if result else None

def get_admin_complete(id_admin: int) -> Optional[dict]:
    """Obtiene un administrador por ID con datos completos"""
    with get_db_connection() as conn:
        with conn.cursor(dictionary=True) as cursor:
            cursor.callproc(PROCEDURES['get_admin_complete'], [id_admin])
            result = cursor.fetchall()
            return result[0] if result else None

def create_administrator(first_names, last_names, campus, email, password_hash):
    """Crea un nuevo administrador"""
    with get_db_connection() as conn:
        with conn.cursor() as cursor:
            cursor.callproc(PROCEDURES['create_administrator'], [first_names, last_names, campus, email, password_hash])
            return True

def update_administrator(admin_id, first_names, last_names, campus, email, password_hash):
    """Actualiza un administrador existente"""
    with get_db_connection() as conn:
        with conn.cursor() as cursor:
            cursor.callproc(PROCEDURES['update_administrator'], [admin_id, first_names, last_names, campus, email, password_hash])
            return True

def delete_administrator(admin_id):
    """Elimina un administrador"""
    with get_db_connection() as conn:
        with conn.cursor() as cursor:
            cursor.callproc(PROCEDURES['delete_administrator'], [admin_id])
            return True 