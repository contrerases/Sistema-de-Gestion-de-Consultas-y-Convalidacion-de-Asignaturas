from database.connection import get_db_connection
from utils.constants import PROCEDURES
from typing import Optional, List, Dict, Any

def create_convalidation(id_student: int, id_convalidation_type: int, id_curriculum_course: int, id_workshop: Optional[int] = None, activity_name: Optional[str] = None, description: Optional[str] = None, file_name: Optional[str] = None, file_data: Optional[bytes] = None, id_subject: Optional[int] = None, id_department: Optional[int] = None) -> bool:
    with get_db_connection() as conn:
        with conn.cursor() as cursor:
            cursor.callproc(PROCEDURES['create_convalidation'], [id_student, id_convalidation_type, id_curriculum_course, id_workshop, activity_name, description, file_name, file_data, id_subject, id_department])
            return True

def get_convalidations(id_request: Optional[int] = None, id_convalidation: Optional[int] = None, id_convalidation_type: Optional[int] = None, id_convalidation_state: Optional[int] = None, id_curriculum_course: Optional[int] = None, id_student: Optional[int] = None, student_rol: Optional[str] = None, student_rut: Optional[str] = None, student_name: Optional[str] = None, id_reviewed_by: Optional[int] = None, id_workshop: Optional[int] = None, id_subject: Optional[int] = None, id_department: Optional[int] = None, student_campus: Optional[str] = None) -> List[Dict[str, Any]]:
    with get_db_connection() as conn:
        with conn.cursor(dictionary=True) as cursor:
            cursor.callproc(PROCEDURES['get_convalidations'], [id_request, id_convalidation, id_convalidation_type, id_convalidation_state, id_curriculum_course, id_student, student_rol, student_rut, student_name, id_reviewed_by, id_workshop, id_subject, id_department, student_campus])
            return cursor.fetchall()

def review_convalidation(id_convalidation: int, id_convalidation_state: int, review_comments: str, id_reviewed_by: int) -> bool:
    with get_db_connection() as conn:
        with conn.cursor() as cursor:
            cursor.callproc(PROCEDURES['review_convalidation'], [id_convalidation, id_convalidation_state, review_comments, id_reviewed_by])
            return True

def drop_convalidation_while_no_reviewed_by(id_convalidation: int) -> bool:
    with get_db_connection() as conn:
        with conn.cursor() as cursor:
            cursor.callproc(PROCEDURES['drop_convalidation_while_no_reviewed_by'], [id_convalidation])
            return True 