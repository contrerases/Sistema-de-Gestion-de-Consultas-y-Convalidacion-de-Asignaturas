from database.connection import get_db_connection
from utils.constants import PROCEDURES
from typing import Optional, List

# =============================================================================
# FUNCIONES DE NOTIFICACIONES
# =============================================================================

def get_notifications() -> List[dict]:
    """Obtiene lista de notificaciones con datos mínimos para preview"""
    with get_db_connection() as conn:
        with conn.cursor(dictionary=True) as cursor:
            cursor.callproc(PROCEDURES['get_notifications'])
            return cursor.fetchall()

def get_notifications_by_user(id_user: int) -> List[dict]:
    """Obtiene notificaciones de un usuario con datos mínimos"""
    with get_db_connection() as conn:
        with conn.cursor(dictionary=True) as cursor:
            cursor.callproc(PROCEDURES['get_notifications_by_user'], [id_user])
            return cursor.fetchall()

def get_notifications_not_read_by_user(id_user: int) -> List[dict]:
    """Obtiene notificaciones no leídas de un usuario con datos mínimos"""
    with get_db_connection() as conn:
        with conn.cursor(dictionary=True) as cursor:
            cursor.callproc(PROCEDURES['get_notifications_not_read_by_user'], [id_user])
            return cursor.fetchall()

def get_notification_by_id(id_notification: int) -> Optional[dict]:
    """Obtiene una notificación específica con datos completos"""
    with get_db_connection() as conn:
        with conn.cursor(dictionary=True) as cursor:
            cursor.callproc(PROCEDURES['get_notification_by_id'], [id_notification])
            result = cursor.fetchall()
            return result[0] if result else None

def create_notification(id_user: int, notification_type: str, message: str) -> bool:
    """Crea una nueva notificación"""
    with get_db_connection() as conn:
        with conn.cursor() as cursor:
            cursor.callproc(PROCEDURES['create_notification'], [id_user, notification_type, message])
            return True

def mark_notification_read(id_notification: int) -> bool:
    """Marca una notificación como leída"""
    with get_db_connection() as conn:
        with conn.cursor() as cursor:
            cursor.callproc(PROCEDURES['mark_notification_read'], [id_notification])
            return True