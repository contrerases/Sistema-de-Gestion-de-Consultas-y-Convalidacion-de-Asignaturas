from database.connection import get_db_connection
from utils.constants import PROCEDURES
from typing import Optional, List

def get_departments() -> List[dict]:
    """Obtiene lista de departamentos"""
    with get_db_connection() as conn:
        with conn.cursor(dictionary=True) as cursor:
            cursor.callproc(PROCEDURES['get_departments'])
            return cursor.fetchall()

def create_department(name: str) -> bool:
    """Crea un nuevo departamento"""
    with get_db_connection() as conn:
        with conn.cursor() as cursor:
            cursor.callproc(PROCEDURES['create_department'], [name])
            return True

def update_department(department_id: int, name: str) -> bool:
    """Actualiza un departamento existente"""
    with get_db_connection() as conn:
        with conn.cursor() as cursor:
            cursor.callproc(PROCEDURES['update_department'], [department_id, name])
            return True

def delete_department(department_id: int) -> bool:
    """Elimina un departamento"""
    with get_db_connection() as conn:
        with conn.cursor() as cursor:
            cursor.callproc(PROCEDURES['delete_department'], [department_id])
            return True 