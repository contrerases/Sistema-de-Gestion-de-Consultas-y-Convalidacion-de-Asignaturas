from database.connection import get_db_connection
from utils.constants import PROCEDURES
from typing import Optional, List, Dict, Any

def get_workshop_grades(id_workshop: Optional[int] = None, id_student: Optional[int] = None, rut_student: Optional[str] = None, semester: Optional[str] = None) -> List[Dict[str, Any]]:
    with get_db_connection() as conn:
        with conn.cursor(dictionary=True) as cursor:
            cursor.callproc(PROCEDURES['get_workshop_grades'], [id_workshop, id_student, rut_student, semester])
            return cursor.fetchall()

def create_workshop_grade(id_workshop: int, id_student: int, grade: int) -> bool:
    with get_db_connection() as conn:
        with conn.cursor() as cursor:
            cursor.callproc(PROCEDURES['create_workshop_grade'], [id_workshop, id_student, grade])
            return True

def update_workshop_grade(id_grade: int, id_workshop: int, id_student: int, grade: int) -> bool:
    with get_db_connection() as conn:
        with conn.cursor() as cursor:
            cursor.callproc(PROCEDURES['update_workshop_grade'], [id_grade, id_workshop, id_student, grade])
            return True

def delete_workshop_grade(id_grade: int) -> bool:
    with get_db_connection() as conn:
        with conn.cursor() as cursor:
            cursor.callproc(PROCEDURES['delete_workshop_grade'], [id_grade])
            return True 