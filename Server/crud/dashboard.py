from database.connection import get_db_connection
from utils.constants import PROCEDURES

def get_statistics():
    with get_db_connection() as conn:
        with conn.cursor(dictionary=True) as cursor:
            # General stats
            cursor.callproc(PROCEDURES['get_dashboard_general_stats'])
            general_stats = cursor.fetchall()
            cursor.nextset()
            # Convalidation stats
            cursor.callproc(PROCEDURES['get_dashboard_convalidation_stats'])
            convalidation_type_stats = cursor.fetchall()
            cursor.nextset()
            convalidation_state_stats = cursor.fetchall()
            cursor.nextset()
            department_stats = cursor.fetchall()
            cursor.nextset()
            month_stats = cursor.fetchall()
            cursor.nextset()
            avg_resolution = cursor.fetchall()
            cursor.nextset()
            # Workshop stats
            cursor.callproc(PROCEDURES['get_dashboard_workshop_stats'])
            workshop_state_stats = cursor.fetchall()
            cursor.nextset()
            # Student stats
            cursor.callproc(PROCEDURES['get_dashboard_student_stats'])
            student_workshops = cursor.fetchall()
            cursor.nextset()
            # Activity stats
            cursor.callproc(PROCEDURES['get_dashboard_activity_stats'])
            activity_stats = cursor.fetchall()
            cursor.nextset()
            activity_peaks = cursor.fetchall()
            return {
                "general_stats": general_stats,
                "convalidation_type_stats": convalidation_type_stats,
                "convalidation_state_stats": convalidation_state_stats,
                "department_stats": department_stats,
                "month_stats": month_stats,
                "avg_resolution": avg_resolution,
                "workshop_state_stats": workshop_state_stats,
                "student_workshops": student_workshops,
                "activity_stats": activity_stats,
                "activity_peaks": activity_peaks
            } 