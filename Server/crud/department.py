from database.connection import get_db_connection
from utils.constants import PROCEDURES
from typing import Optional, List

def get_departments(id_department: Optional[int] = None) -> List[dict]:
    with get_db_connection() as conn:
        with conn.cursor(dictionary=True) as cursor:
            cursor.callproc(PROCEDURES['get_departments'], [id_department])
            return cursor.fetchall()

def create_department(department):
    with get_db_connection() as conn:
        with conn.cursor() as cursor:
            cursor.callproc(PROCEDURES['create_department'], [department])
            return True

def update_department(id_department, department):
    with get_db_connection() as conn:
        with conn.cursor() as cursor:
            cursor.callproc(PROCEDURES['update_department'], [id_department, department])
            return True

def delete_department(id_department):
    with get_db_connection() as conn:
        with conn.cursor() as cursor:
            cursor.callproc(PROCEDURES['delete_department'], [id_department])
            return True 