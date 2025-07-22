from database.connection import get_db_connection
from utils.constants import PROCEDURES

def create_notification(data):
    with get_db_connection() as conn:
        with conn.cursor() as cursor:
            cursor.callproc(PROCEDURES['create_notification'], [
                data.get('user_type'),
                data['notification_type'],
                data['message']
            ])
            return True

def get_notifications(id_user=None, notification_type=None, is_read=None, is_sent=None, user_type=None, limit=None):
    with get_db_connection() as conn:
        with conn.cursor(dictionary=True) as cursor:
            cursor.callproc(PROCEDURES['get_notifications'], [id_user, notification_type, is_read, is_sent, user_type, limit])
            return cursor.fetchall()

def mark_notification_read(id_notification, id_user):
    with get_db_connection() as conn:
        with conn.cursor() as cursor:
            cursor.callproc(PROCEDURES['mark_notification_read'], [id_notification, id_user])
            return True 

def get_notifications_not_read_by_id_user(id_user):
    with get_db_connection() as conn:
        with conn.cursor(dictionary=True) as cursor:
            cursor.callproc(PROCEDURES['get_notifications'], [id_user, None, 0, None, None, None])
            return cursor.fetchall()