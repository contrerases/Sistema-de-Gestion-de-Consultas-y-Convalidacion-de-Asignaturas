from database.connection import get_db_connection
from utils.constants import PROCEDURES

def get_workshop_grades(workshop_id=None, student_id=None, min_grade=None, max_grade=None):
    with get_db_connection() as conn:
        with conn.cursor(dictionary=True) as cursor:
            cursor.callproc(PROCEDURES['get_workshop_grades'], [workshop_id, student_id, min_grade, max_grade])
            return cursor.fetchall()

def create_workshop_grade(data):
    with get_db_connection() as conn:
        with conn.cursor() as cursor:
            cursor.callproc(PROCEDURES['create_workshop_grade'], [
                data['id_workshop'], data['id_student'], data['grade']
            ])
            return True 