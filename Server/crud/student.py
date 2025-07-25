from database.connection import get_db_connection
from utils.constants import PROCEDURES
from typing import Optional, List

def get_students(student_id: Optional[int] = None, rut_student: Optional[str] = None, first_names: Optional[str] = None, rol_student: Optional[str] = None) -> List[dict]:
    with get_db_connection() as conn:
        with conn.cursor(dictionary=True) as cursor:
            cursor.callproc(PROCEDURES['get_students'], [student_id, rut_student, first_names, rol_student])
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