from typing import List, Optional
from database.connection import get_db_connection
from schemas.admin.admin_in import AdminIn
from utils.constants import PROCEDURES

# CREATE

def create_admin(admin: AdminIn, password_hash: str) -> bool:
    with get_db_connection() as conn:
        with conn.cursor() as cursor:
            cursor.callproc(
                PROCEDURES['create_administrator'], [
                    admin.first_names,
                    admin.last_names,
                    admin.campus,
                    admin.email,
                    password_hash
                ]
            )
            return True

# READ (única función para get_administrators)
def get_administrators(id_admin: Optional[int] = None, campus: Optional[str] = None, email: Optional[str] = None) -> List[dict]:
    with get_db_connection() as conn:
        with conn.cursor(dictionary=True) as cursor:
            cursor.callproc(PROCEDURES['get_administrators'], [id_admin, campus, email]) 
            return cursor.fetchall()

# UPDATE

def update_admin(admin_id: int, admin: AdminIn, password_hash: Optional[str] = None) -> bool:
    with get_db_connection() as conn:
        with conn.cursor(dictionary=True) as cursor:
            cursor.callproc(
                PROCEDURES['update_administrator'],
                [
                    admin_id,
                    admin.first_names,
                    admin.last_names,
                    admin.campus,
                    admin.email,
                    password_hash if password_hash else admin.password
                ]
            )
            conn.commit()
            return cursor.rowcount > 0

# DELETE

def delete_admin(admin_id: int) -> bool:
    with get_db_connection() as conn:
        with conn.cursor(dictionary=True) as cursor:
            cursor.callproc(PROCEDURES['delete_administrator'], [admin_id])
            conn.commit()
            return cursor.rowcount > 0 