from database.connection import get_db_connection
from utils.constants import PROCEDURES
 
def get_all_convalidation_types():
    with get_db_connection() as conn:
        with conn.cursor(dictionary=True) as cursor:
            cursor.callproc(PROCEDURES['get_convalidation_types'])
            return cursor.fetchall() 