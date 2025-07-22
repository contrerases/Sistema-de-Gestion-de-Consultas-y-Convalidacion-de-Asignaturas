from database.connection import get_db_connection
from utils.constants import PROCEDURES
from typing import List, Dict, Any, Optional

# CREATE

def create_convalidation(data: dict) -> bool:
    with get_db_connection() as conn:
        with conn.cursor() as cursor:
            cursor.callproc(
                PROCEDURES['create_convalidation'], [
                    data['id_student'],
                    data['id_convalidation_type'],
                    data['id_curriculum_course'],
                    data.get('id_workshop'),
                    data.get('activity_name'),
                    data.get('description'),
                    data.get('file_name'),
                    data.get('file_data'),
                    data.get('id_subject'),
                    data.get('id_department')
                ]
            )
            return True

# GET CONVALIDATIONS (con filtros)
def get_convalidations(filters: dict) -> List[Dict[str, Any]]:
    with get_db_connection() as conn:
        with conn.cursor(dictionary=True) as cursor:
            cursor.callproc(
                PROCEDURES['get_convalidations'], [
                    filters.get('id_request'),
                    filters.get('id_convalidation'),
                    filters.get('id_convalidation_type'),
                    filters.get('id_convalidation_state'),
                    filters.get('id_curriculum_course'),
                    filters.get('id_student'),
                    filters.get('student_rol'),
                    filters.get('student_rut'),
                    filters.get('student_name'),
                    filters.get('id_reviewed_by'),
                    filters.get('id_workshop'),
                    filters.get('id_subject'),
                    filters.get('id_department'),
                    filters.get('student_campus')
                ]
            )
            return cursor.fetchall()

# GET CONVALIDATION BY STUDENT (rol, rut, id)
def get_convalidation_by_student(id_student: Optional[int]=None, student_rol: Optional[str]=None, student_rut: Optional[str]=None) -> List[Dict[str, Any]]:
    filters = {
        'id_student': id_student,
        'student_rol': student_rol,
        'student_rut': student_rut
    }
    return get_convalidations(filters)

# GET CONVALIDATION PENDING
def get_convalidation_pending() -> List[Dict[str, Any]]:
    filters = {'id_convalidation_state': 1}  # Suponiendo que 1 es el estado 'ENVIADA' o pendiente
    return get_convalidations(filters)

# REVIEW CONVALIDATION
def review_convalidation(id_convalidation: int, id_convalidation_state: int, review_comments: str, id_reviewed_by: int) -> bool:
    with get_db_connection() as conn:
        with conn.cursor() as cursor:
            cursor.callproc(
                PROCEDURES['review_convalidation'], [
                    id_convalidation,
                    id_convalidation_state,
                    review_comments,
                    id_reviewed_by
                ]
            )
            return True 