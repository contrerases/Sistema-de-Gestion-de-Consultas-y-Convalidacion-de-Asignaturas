from database.connection import get_db_connection
from utils.constants import PROCEDURES
from typing import Optional, List, Dict, Any

def get_workshops(id_workshop: Optional[int] = None, name: Optional[str] = None, semester: Optional[str] = None, year: Optional[int] = None, professor: Optional[str] = None, description: Optional[str] = None, inscription_start_date: Optional[str] = None, inscription_end_date: Optional[str] = None, course_start_date: Optional[str] = None, course_end_date: Optional[str] = None, available: Optional[bool] = None, limit_inscriptions: Optional[int] = None, id_workshop_state: Optional[int] = None) -> List[Dict[str, Any]]:
    with get_db_connection() as conn:
        with conn.cursor(dictionary=True) as cursor:
            cursor.callproc(PROCEDURES['get_workshops'], [id_workshop, name, semester, year, professor, description, inscription_start_date, inscription_end_date, course_start_date, course_end_date, available, limit_inscriptions, id_workshop_state])
            return cursor.fetchall()

def create_workshop(name: str, semester: str, year: int, professor: str, description: str, inscription_start_date: str, inscription_end_date: str, course_start_date: str, course_end_date: str, available: bool, limit_inscriptions: int, id_workshop_state: int) -> bool:
    with get_db_connection() as conn:
        with conn.cursor() as cursor:
            cursor.callproc(PROCEDURES['create_workshop'], [name, semester, year, professor, description, inscription_start_date, inscription_end_date, course_start_date, course_end_date, available, limit_inscriptions, id_workshop_state])
            return True

def update_workshop(workshop_id: int, name: str, semester: str, year: int, professor: str, description: str, inscription_start_date: str, inscription_end_date: str, course_start_date: str, course_end_date: str, available: bool, limit_inscriptions: int, id_workshop_state: int) -> bool:
    with get_db_connection() as conn:
        with conn.cursor() as cursor:
            cursor.callproc(PROCEDURES['update_workshop'], [workshop_id, name, semester, year, professor, description, inscription_start_date, inscription_end_date, course_start_date, course_end_date, available, limit_inscriptions, id_workshop_state])
            return True

def delete_workshop(workshop_id: int) -> bool:
    with get_db_connection() as conn:
        with conn.cursor() as cursor:
            cursor.callproc(PROCEDURES['delete_workshop'], [workshop_id])
            return True

def change_workshop_state(workshop_id: int, new_state_id: int, new_inscription_start_date: str, new_inscription_end_date: str, new_course_start_date: str, new_course_end_date: str) -> bool:
    with get_db_connection() as conn:
        with conn.cursor() as cursor:
            cursor.callproc(PROCEDURES['change_workshop_state'], [workshop_id, new_state_id, new_inscription_start_date, new_inscription_end_date, new_course_start_date, new_course_end_date])
            return True 