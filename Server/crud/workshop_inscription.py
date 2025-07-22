from database.connection import get_db_connection
from utils.constants import PROCEDURES

def get_workshops_inscriptions(workshop_id=None, student_id=None, is_convalidated=None, curriculum_course_id=None):
    with get_db_connection() as conn:
        with conn.cursor(dictionary=True) as cursor:
            cursor.callproc(PROCEDURES['get_workshops_inscriptions'], [workshop_id, student_id, is_convalidated, curriculum_course_id])
            return cursor.fetchall()

def create_workshop_inscription(data):
    with get_db_connection() as conn:
        with conn.cursor() as cursor:
            cursor.callproc(PROCEDURES['create_workshop_inscription'], [
                data['id_student'], data['id_workshop'], data.get('id_curriculum_course'), data.get('is_convalidated', False)
            ])
            return True

def cancel_workshop_inscription(inscription_id, student_id):
    with get_db_connection() as conn:
        with conn.cursor() as cursor:
            cursor.callproc(PROCEDURES['cancel_workshop_inscription'], [inscription_id, student_id])
            return True

def unregister_workshop_after_start(workshop_id):
    with get_db_connection() as conn:
        with conn.cursor() as cursor:
            cursor.callproc(PROCEDURES['unregister_workshop_after_start'], [workshop_id])
            return True 