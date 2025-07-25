from database.connection import get_db_connection
from utils.constants import PROCEDURES

def get_general_stats():
    with get_db_connection() as conn:
        with conn.cursor(dictionary=True) as cursor:
            cursor.callproc(PROCEDURES['get_general_stats'])
            return cursor.fetchall()

def get_convalidation_stats():
    with get_db_connection() as conn:
        with conn.cursor(dictionary=True) as cursor:
            cursor.callproc(PROCEDURES['get_convalidation_stats'])
            return cursor.fetchall()

def get_convalidation_state_stats():
    with get_db_connection() as conn:
        with conn.cursor(dictionary=True) as cursor:
            cursor.callproc(PROCEDURES['get_convalidation_state_stats'])
            return cursor.fetchall()

def get_convalidation_department_stats():
    with get_db_connection() as conn:
        with conn.cursor(dictionary=True) as cursor:
            cursor.callproc(PROCEDURES['get_convalidation_department_stats'])
            return cursor.fetchall()

def get_convalidation_month_stats():
    with get_db_connection() as conn:
        with conn.cursor(dictionary=True) as cursor:
            cursor.callproc(PROCEDURES['get_convalidation_month_stats'])
            return cursor.fetchall()

def get_convalidation_resolution_time_stats():
    with get_db_connection() as conn:
        with conn.cursor(dictionary=True) as cursor:
            cursor.callproc(PROCEDURES['get_convalidation_resolution_time_stats'])
            return cursor.fetchall()

def get_workshop_state_stats():
    with get_db_connection() as conn:
        with conn.cursor(dictionary=True) as cursor:
            cursor.callproc(PROCEDURES['get_workshop_state_stats'])
            return cursor.fetchall()

def get_workshop_stats():
    with get_db_connection() as conn:
        with conn.cursor(dictionary=True) as cursor:
            cursor.callproc(PROCEDURES['get_workshop_stats'])
            return cursor.fetchall()

def get_student_stats():
    with get_db_connection() as conn:
        with conn.cursor(dictionary=True) as cursor:
            cursor.callproc(PROCEDURES['get_student_stats'])
            return cursor.fetchall()
            

def get_activity_stats():
    with get_db_connection() as conn:
        with conn.cursor(dictionary=True) as cursor:
            cursor.callproc(PROCEDURES['get_activity_stats'])
            return cursor.fetchall()

