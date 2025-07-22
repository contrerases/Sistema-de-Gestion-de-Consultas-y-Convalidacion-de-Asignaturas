from typing import Optional
from database.connection import get_db_connection
from utils.constants import PROCEDURES

# LOGIN

def login(email: str, password_hash: str) -> Optional[dict]:
    with get_db_connection() as conn:
        with conn.cursor(dictionary=True) as cursor:
            cursor.callproc(PROCEDURES['login'], [email, password_hash])
            row = cursor.fetchone()
            return row if row else None

# LOGOUT (opcional, solo registra evento)
def logout(user_id: int) -> bool:
    with get_db_connection() as conn:
        with conn.cursor(dictionary=True) as cursor:
            cursor.callproc(PROCEDURES['logout'], [user_id])
            return True

# CHANGE PASSWORD
def change_password(user_id: int, current_password_hash: str, new_password_hash: str) -> bool:
    with get_db_connection() as conn:
        with conn.cursor(dictionary=True) as cursor:
            cursor.callproc(PROCEDURES['change_password'], [user_id, current_password_hash, new_password_hash])
            return cursor.rowcount > 0

# GET USER BY EMAIL
def get_user_by_email(email: str) -> Optional[dict]:
    with get_db_connection() as conn:
        with conn.cursor(dictionary=True) as cursor:
            cursor.callproc(PROCEDURES['get_user_by_email'], [email])
            row = cursor.fetchone()
            return row if row else None

# GET USER BY ID

def get_user_by_id(user_id: int) -> Optional[dict]:
    with get_db_connection() as conn:
        with conn.cursor(dictionary=True) as cursor:
            cursor.execute("SELECT * FROM vw_auth_users WHERE id_auth_user = %s", (user_id,))
            row = cursor.fetchone()
            return row if row else None 