from database.connection import get_db_connection
from utils.constants import PROCEDURES
from typing import Optional, List, Dict, Any

def get_workshops_inscriptions(id_workshop: Optional[int] = None, id_student: Optional[int] = None, student_rut: Optional[str] = None, student_name: Optional[str] = None, student_rol: Optional[str] = None, id_curriculum_course: Optional[int] = None) -> List[Dict[str, Any]]:
    with get_db_connection() as conn:
        with conn.cursor(dictionary=True) as cursor:
            cursor.callproc(PROCEDURES['get_workshops_inscriptions'], [id_workshop, id_student, student_rut, student_name, student_rol, id_curriculum_course])
            return cursor.fetchall()

def create_workshop_inscription(id_student: int, id_workshop: int, id_curriculum_course: Optional[int], is_convalidated: Optional[bool] = False) -> bool:
    with get_db_connection() as conn:
        with conn.cursor() as cursor:
            cursor.callproc(PROCEDURES['create_workshop_inscription'], [id_student, id_workshop, id_curriculum_course, is_convalidated])
            return True

def update_workshop_inscription(id_inscription: int, id_student: int, id_workshop: int, id_curriculum_course: Optional[int], is_convalidated: Optional[bool] = False) -> bool:
    with get_db_connection() as conn:
        with conn.cursor() as cursor:
            cursor.callproc(PROCEDURES['update_workshop_inscription'], [id_inscription, id_student, id_workshop, id_curriculum_course, is_convalidated])
            return True

def cancel_workshop_inscription(id_inscription: int) -> bool:
    with get_db_connection() as conn:
        with conn.cursor() as cursor:
            cursor.callproc(PROCEDURES['cancel_workshop_inscription'], [id_inscription])
            return True 