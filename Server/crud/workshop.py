from database.connection import get_db_connection
from utils.constants import PROCEDURES

def get_workshops(semester=None, year=None, available=None, id_workshop_state=None):
    with get_db_connection() as conn:
        with conn.cursor(dictionary=True) as cursor:
            cursor.callproc(PROCEDURES['get_workshops'], [semester, year, available, id_workshop_state])
            return cursor.fetchall()

def create_workshop(data):
    with get_db_connection() as conn:
        with conn.cursor() as cursor:
            cursor.callproc(PROCEDURES['create_workshop'], [
                data['name'], data['semester'], data['year'], data['professor'], data['description'],
                data['inscription_start_date'], data['inscription_end_date'],
                data['course_start_date'], data['course_end_date'], data['available'],
                data['limit_inscriptions'], data['id_workshop_state']
            ])
            return True

def update_workshop(workshop_id, data):
    with get_db_connection() as conn:
        with conn.cursor() as cursor:
            cursor.callproc(PROCEDURES['update_workshop'], [
                workshop_id, data['name'], data['semester'], data['year'], data['professor'], data['description'],
                data['inscription_start_date'], data['inscription_end_date'],
                data['course_start_date'], data['course_end_date'], data['available'],
                data['limit_inscriptions'], data['id_workshop_state']
            ])
            return True

def delete_workshop(workshop_id):
    with get_db_connection() as conn:
        with conn.cursor() as cursor:
            cursor.callproc(PROCEDURES['delete_workshop'], [workshop_id])
            return True

def set_state_workshop(workshop_id, new_state_id, new_inscription_start_date, new_inscription_end_date, new_course_start_date, new_course_end_date):
    with get_db_connection() as conn:
        with conn.cursor() as cursor:
            cursor.callproc(PROCEDURES['change_workshop_state'], [
                workshop_id, new_state_id, new_inscription_start_date, new_inscription_end_date, new_course_start_date, new_course_end_date
            ])
            return True 