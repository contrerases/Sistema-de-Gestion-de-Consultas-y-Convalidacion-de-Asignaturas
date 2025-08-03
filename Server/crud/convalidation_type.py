from database.connection import get_db_connection
from utils.constants import PROCEDURES
from typing import List

def get_convalidation_types() -> List[dict]:
    """Obtiene lista de tipos de convalidación"""
    with get_db_connection() as conn:
        with conn.cursor(dictionary=True) as cursor:
            cursor.callproc(PROCEDURES['get_convalidation_types'])
            return cursor.fetchall() 