from database.connection import get_db_connection
from utils.constants import PROCEDURES

def get_students(student_id=None):
    with get_db_connection() as conn:
        with conn.cursor(dictionary=True) as cursor:
            cursor.callproc(PROCEDURES['get_students'], [student_id])
            return cursor.fetchall()

def create_student(first_names, last_names, campus, rol_student, rut_student, campus_student, email, password_hash):
    with get_db_connection() as conn:
        with conn.cursor() as cursor:
            cursor.callproc(PROCEDURES['create_student'], [first_names, last_names, campus, rol_student, rut_student, campus_student, email, password_hash])
            return True

def update_student(student_id, first_names, last_names, campus, rol_student, rut_student, campus_student, email, password_hash):
    with get_db_connection() as conn:
        with conn.cursor() as cursor:
            cursor.callproc(PROCEDURES['update_student'], [student_id, first_names, last_names, campus, rol_student, rut_student, campus_student, email, password_hash])
            return True

def delete_student(student_id):
    with get_db_connection() as conn:
        with conn.cursor() as cursor:
            cursor.callproc(PROCEDURES['delete_student'], [student_id])
            return True 