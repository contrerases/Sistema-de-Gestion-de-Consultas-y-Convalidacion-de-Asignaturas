from database.connection import get_db_connection
from utils.constants import PROCEDURES
from typing import Optional, List

def create_notification(user_type: Optional[str], notification_type: str, message: str) -> bool:
    with get_db_connection() as conn:
        with conn.cursor() as cursor:
            cursor.callproc(PROCEDURES['create_notification'], [user_type, notification_type, message])
            return True

def get_notifications(id_user: Optional[int] = None, notification_type: Optional[str] = None, is_read: Optional[int] = None, is_sent: Optional[int] = None, user_type: Optional[str] = None, limit: Optional[int] = None) -> List[dict]:
    with get_db_connection() as conn:
        with conn.cursor(dictionary=True) as cursor:
            cursor.callproc(PROCEDURES['get_notifications'], [id_user, notification_type, is_read, is_sent, user_type, limit])
            return cursor.fetchall()

def mark_notification_read(id_notification: int, id_user: int) -> bool:
    with get_db_connection() as conn:
        with conn.cursor() as cursor:
            cursor.callproc(PROCEDURES['mark_notification_read'], [id_notification, id_user])
            return True