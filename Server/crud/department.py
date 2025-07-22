from database.connection import get_db_connection
from utils.constants import PROCEDURES

def get_departments(department_id=None):
    with get_db_connection() as conn:
        with conn.cursor(dictionary=True) as cursor:
            cursor.callproc(PROCEDURES['get_departments'], [department_id])
            return cursor.fetchall()

def create_department(name):
    with get_db_connection() as conn:
        with conn.cursor() as cursor:
            cursor.callproc(PROCEDURES['create_department'], [name])
            return True

def update_department(department_id, name):
    with get_db_connection() as conn:
        with conn.cursor() as cursor:
            cursor.callproc(PROCEDURES['update_department'], [department_id, name])
            return True

def delete_department(department_id):
    with get_db_connection() as conn:
        with conn.cursor() as cursor:
            cursor.callproc(PROCEDURES['delete_department'], [department_id])
            return True 