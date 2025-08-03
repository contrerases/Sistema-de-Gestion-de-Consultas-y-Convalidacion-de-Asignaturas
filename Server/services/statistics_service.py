from fastapi import HTTPException
import mariadb
from crud.statistics import (
    # Funciones de Dashboard
    get_dashboard_general_stats,
    get_dashboard_convalidation_stats,
    get_dashboard_workshop_stats,
    get_dashboard_student_stats,
    get_dashboard_activity_stats,
    # Funciones de Estadísticas Específicas
    get_stats_general,
    get_stats_workshops,
    get_stats_convalidations,
    # Funciones de Catálogos
    get_convalidation_types,
    get_curriculum_courses_types,
    get_workshop_states,
    get_convalidation_states,
    # Funciones de Nuevas Funcionalidades
    get_workshop_tokens_active,
    get_workshop_tokens_expired,
    get_professors_active
)

# =============================================================================
# SERVICIOS DE DASHBOARD
# =============================================================================

def get_dashboard_general_stats_service():
    """Obtiene estadísticas generales del dashboard"""
    try:
        return get_dashboard_general_stats()
    except mariadb.Error as e:
        raise HTTPException(status_code=500, detail=str(e))

def get_dashboard_convalidation_stats_service():
    """Obtiene estadísticas de convalidaciones del dashboard"""
    try:
        return get_dashboard_convalidation_stats()
    except mariadb.Error as e:
        raise HTTPException(status_code=500, detail=str(e))

def get_dashboard_workshop_stats_service():
    """Obtiene estadísticas de talleres del dashboard"""
    try:
        return get_dashboard_workshop_stats()
    except mariadb.Error as e:
        raise HTTPException(status_code=500, detail=str(e))

def get_dashboard_student_stats_service():
    """Obtiene estadísticas de estudiantes del dashboard"""
    try:
        return get_dashboard_student_stats()
    except mariadb.Error as e:
        raise HTTPException(status_code=500, detail=str(e))

def get_dashboard_activity_stats_service():
    """Obtiene estadísticas de actividad del dashboard"""
    try:
        return get_dashboard_activity_stats()
    except mariadb.Error as e:
        raise HTTPException(status_code=500, detail=str(e))

# =============================================================================
# SERVICIOS DE ESTADÍSTICAS ESPECÍFICAS
# =============================================================================

def get_stats_general_service():
    """Obtiene estadísticas generales del sistema"""
    try:
        return get_stats_general()
    except mariadb.Error as e:
        raise HTTPException(status_code=500, detail=str(e))

def get_stats_workshops_service():
    """Obtiene estadísticas detalladas de talleres"""
    try:
        return get_stats_workshops()
    except mariadb.Error as e:
        raise HTTPException(status_code=500, detail=str(e))

def get_stats_convalidations_service():
    """Obtiene estadísticas detalladas de convalidaciones"""
    try:
        return get_stats_convalidations()
    except mariadb.Error as e:
        raise HTTPException(status_code=500, detail=str(e))

# =============================================================================
# SERVICIOS DE CATÁLOGOS
# =============================================================================

def get_convalidation_types_service():
    """Obtiene tipos de convalidación"""
    try:
        return get_convalidation_types()
    except mariadb.Error as e:
        raise HTTPException(status_code=500, detail=str(e))

def get_curriculum_courses_types_service():
    """Obtiene tipos de cursos curriculares"""
    try:
        return get_curriculum_courses_types()
    except mariadb.Error as e:
        raise HTTPException(status_code=500, detail=str(e))

def get_workshop_states_service():
    """Obtiene estados de talleres"""
    try:
        return get_workshop_states()
    except mariadb.Error as e:
        raise HTTPException(status_code=500, detail=str(e))

def get_convalidation_states_service():
    """Obtiene estados de convalidaciones"""
    try:
        return get_convalidation_states()
    except mariadb.Error as e:
        raise HTTPException(status_code=500, detail=str(e))

# =============================================================================
# SERVICIOS DE NUEVAS FUNCIONALIDADES
# =============================================================================

def get_workshop_tokens_active_service():
    """Obtiene tokens activos para subida de notas"""
    try:
        return get_workshop_tokens_active()
    except mariadb.Error as e:
        raise HTTPException(status_code=500, detail=str(e))

def get_workshop_tokens_expired_service():
    """Obtiene tokens expirados para subida de notas"""
    try:
        return get_workshop_tokens_expired()
    except mariadb.Error as e:
        raise HTTPException(status_code=500, detail=str(e))

def get_professors_active_service():
    """Obtiene profesores activos"""
    try:
        return get_professors_active()
    except mariadb.Error as e:
        raise HTTPException(status_code=500, detail=str(e)) 