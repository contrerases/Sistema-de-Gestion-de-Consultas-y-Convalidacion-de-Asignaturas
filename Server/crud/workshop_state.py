from database.connection import get_db_connection
from utils.constants import PROCEDURES
from typing import List

def get_workshop_states() -> List[dict]:
    """Obtiene lista de estados de talleres"""
    with get_db_connection() as conn:
        with conn.cursor(dictionary=True) as cursor:
            cursor.callproc(PROCEDURES['get_workshop_states'])
            return cursor.fetchall() 