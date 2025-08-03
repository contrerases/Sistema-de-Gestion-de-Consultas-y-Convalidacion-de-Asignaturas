from database.connection import get_db_connection
from utils.constants import PROCEDURES
from typing import Optional, List

def login(email: str, password: str) -> Optional[dict]:
    """Autentica un usuario"""
    with get_db_connection() as conn:
        with conn.cursor(dictionary=True) as cursor:
            cursor.callproc(PROCEDURES['login'], [email, password])
            result = cursor.fetchall()
            return result[0] if result else None

def logout(user_id: int) -> bool:
    """Cierra la sesión de un usuario"""
    with get_db_connection() as conn:
        with conn.cursor() as cursor:
            cursor.callproc(PROCEDURES['logout'], [user_id])
            return True

def change_password(user_id: int, old_password: str, new_password: str) -> bool:
    """Cambia la contraseña de un usuario"""
    with get_db_connection() as conn:
        with conn.cursor() as cursor:
            cursor.callproc(PROCEDURES['change_password'], [user_id, old_password, new_password])
            return True

def reset_password(email: str, new_password: str) -> bool:
    """Resetea la contraseña de un usuario"""
    with get_db_connection() as conn:
        with conn.cursor() as cursor:
            cursor.callproc(PROCEDURES['reset_password'], [email, new_password])
            return True

def get_user_by_email(email: str) -> Optional[dict]:
    """Obtiene un usuario por email"""
    with get_db_connection() as conn:
        with conn.cursor(dictionary=True) as cursor:
            cursor.callproc(PROCEDURES['get_user_by_email'], [email])
            result = cursor.fetchall()
            return result[0] if result else None 