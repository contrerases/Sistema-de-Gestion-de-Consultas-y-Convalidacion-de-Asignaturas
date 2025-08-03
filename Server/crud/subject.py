from database.connection import get_db_connection
from utils.constants import PROCEDURES
from typing import Optional, List

def get_subjects() -> List[dict]:
    """Obtiene lista de asignaturas"""
    with get_db_connection() as conn:
        with conn.cursor(dictionary=True) as cursor:
            cursor.callproc(PROCEDURES['get_subjects'])
            return cursor.fetchall()

def get_subjects_by_department(id_department: int) -> List[dict]:
    """Obtiene asignaturas por departamento"""
    with get_db_connection() as conn:
        with conn.cursor(dictionary=True) as cursor:
            cursor.callproc(PROCEDURES['get_subjects_by_department'], [id_department])
            return cursor.fetchall()

def create_subject(acronym: str, name: str, credits: int, id_department: int) -> bool:
    """Crea una nueva asignatura"""
    with get_db_connection() as conn:
        with conn.cursor() as cursor:
            cursor.callproc(PROCEDURES['create_subject'], [acronym, name, credits, id_department])
            return True

def update_subject(subject_id: int, acronym: str, name: str, credits: int, id_department: int) -> bool:
    """Actualiza una asignatura existente"""
    with get_db_connection() as conn:
        with conn.cursor() as cursor:
            cursor.callproc(PROCEDURES['update_subject'], [subject_id, acronym, name, credits, id_department])
            return True

def delete_subject(subject_id: int) -> bool:
    """Elimina una asignatura"""
    with get_db_connection() as conn:
        with conn.cursor() as cursor:
            cursor.callproc(PROCEDURES['delete_subject'], [subject_id])
            return True 