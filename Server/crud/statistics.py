from database.connection import get_db_connection
from utils.constants import PROCEDURES
from typing import Optional, List, Dict, Any

# =============================================================================
# FUNCIONES DE DASHBOARD
# =============================================================================

def get_dashboard_general_stats() -> dict:
    """Obtiene estadísticas generales del dashboard"""
    with get_db_connection() as conn:
        with conn.cursor(dictionary=True) as cursor:
            cursor.callproc(PROCEDURES['get_dashboard_general_stats'])
            result = cursor.fetchall()
            return result[0] if result else {}

def get_dashboard_convalidation_stats() -> dict:
    """Obtiene estadísticas de convalidaciones del dashboard"""
    with get_db_connection() as conn:
        with conn.cursor(dictionary=True) as cursor:
            cursor.callproc(PROCEDURES['get_dashboard_convalidation_stats'])
            result = cursor.fetchall()
            return result[0] if result else {}

def get_dashboard_workshop_stats() -> dict:
    """Obtiene estadísticas de talleres del dashboard"""
    with get_db_connection() as conn:
        with conn.cursor(dictionary=True) as cursor:
            cursor.callproc(PROCEDURES['get_dashboard_workshop_stats'])
            result = cursor.fetchall()
            return result[0] if result else {}

def get_dashboard_student_stats() -> dict:
    """Obtiene estadísticas de estudiantes del dashboard"""
    with get_db_connection() as conn:
        with conn.cursor(dictionary=True) as cursor:
            cursor.callproc(PROCEDURES['get_dashboard_student_stats'])
            result = cursor.fetchall()
            return result[0] if result else {}

def get_dashboard_activity_stats() -> dict:
    """Obtiene estadísticas de actividad del dashboard"""
    with get_db_connection() as conn:
        with conn.cursor(dictionary=True) as cursor:
            cursor.callproc(PROCEDURES['get_dashboard_activity_stats'])
            result = cursor.fetchall()
            return result[0] if result else {}

# =============================================================================
# FUNCIONES DE ESTADÍSTICAS ESPECÍFICAS
# =============================================================================

def get_stats_general() -> dict:
    """Obtiene estadísticas generales del sistema"""
    with get_db_connection() as conn:
        with conn.cursor(dictionary=True) as cursor:
            cursor.callproc(PROCEDURES['get_stats_general'])
            result = cursor.fetchall()
            return result[0] if result else {}

def get_stats_workshops() -> List[dict]:
    """Obtiene estadísticas detalladas de talleres"""
    with get_db_connection() as conn:
        with conn.cursor(dictionary=True) as cursor:
            cursor.callproc(PROCEDURES['get_stats_workshops'])
            return cursor.fetchall()

def get_stats_convalidations() -> List[dict]:
    """Obtiene estadísticas detalladas de convalidaciones"""
    with get_db_connection() as conn:
        with conn.cursor(dictionary=True) as cursor:
            cursor.callproc(PROCEDURES['get_stats_convalidations'])
            return cursor.fetchall()

# =============================================================================
# FUNCIONES DE CATÁLOGOS
# =============================================================================

def get_convalidation_types() -> List[dict]:
    """Obtiene tipos de convalidación"""
    with get_db_connection() as conn:
        with conn.cursor(dictionary=True) as cursor:
            cursor.callproc(PROCEDURES['get_convalidation_types'])
            return cursor.fetchall()

def get_curriculum_courses_types() -> List[dict]:
    """Obtiene tipos de cursos curriculares"""
    with get_db_connection() as conn:
        with conn.cursor(dictionary=True) as cursor:
            cursor.callproc(PROCEDURES['get_curriculum_courses_types'])
            return cursor.fetchall()

def get_workshop_states() -> List[dict]:
    """Obtiene estados de talleres"""
    with get_db_connection() as conn:
        with conn.cursor(dictionary=True) as cursor:
            cursor.callproc(PROCEDURES['get_workshop_states'])
            return cursor.fetchall()

def get_convalidation_states() -> List[dict]:
    """Obtiene estados de convalidaciones"""
    with get_db_connection() as conn:
        with conn.cursor(dictionary=True) as cursor:
            cursor.callproc(PROCEDURES['get_convalidation_states'])
            return cursor.fetchall()

# =============================================================================
# FUNCIONES DE NUEVAS FUNCIONALIDADES
# =============================================================================

def get_workshop_tokens_active() -> List[dict]:
    """Obtiene tokens activos para subida de notas"""
    with get_db_connection() as conn:
        with conn.cursor(dictionary=True) as cursor:
            cursor.callproc(PROCEDURES['get_workshop_tokens_active'])
            return cursor.fetchall()

def get_workshop_tokens_expired() -> List[dict]:
    """Obtiene tokens expirados para subida de notas"""
    with get_db_connection() as conn:
        with conn.cursor(dictionary=True) as cursor:
            cursor.callproc(PROCEDURES['get_workshop_tokens_expired'])
            return cursor.fetchall()

def get_professors_active() -> List[dict]:
    """Obtiene profesores activos"""
    with get_db_connection() as conn:
        with conn.cursor(dictionary=True) as cursor:
            cursor.callproc(PROCEDURES['get_professors_active'])
            return cursor.fetchall()

