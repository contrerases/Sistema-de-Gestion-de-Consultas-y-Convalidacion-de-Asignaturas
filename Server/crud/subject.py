from database.connection import get_db_connection
from utils.constants import PROCEDURES

def get_subjects(subject_id=None):
    with get_db_connection() as conn:
        with conn.cursor(dictionary=True) as cursor:
            cursor.callproc(PROCEDURES['get_subjects'], [subject_id])
            return cursor.fetchall()

def create_subject(acronym, name, id_department, credits):
    with get_db_connection() as conn:
        with conn.cursor() as cursor:
            cursor.callproc(PROCEDURES['create_subject'], [acronym, name, id_department, credits])
            return True

def update_subject(subject_id, acronym, name, id_department, credits):
    with get_db_connection() as conn:
        with conn.cursor() as cursor:
            cursor.callproc(PROCEDURES['update_subject'], [subject_id, acronym, name, id_department, credits])
            return True

def delete_subject(subject_id):
    with get_db_connection() as conn:
        with conn.cursor() as cursor:
            cursor.callproc(PROCEDURES['delete_subject'], [subject_id])
            return True 