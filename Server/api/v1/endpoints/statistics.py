from fastapi import APIRouter
from typing import List, Dict, Any
from schemas.statistics.stats_general_out import StatsGeneralOut
from schemas.statistics.stats_workshops_out import StatsWorkshopsOut
from schemas.statistics.stats_convalidations_out import StatsConvalidationsOut
from services.statistics_service import (
    get_dashboard_general_stats_service,
    get_dashboard_convalidation_stats_service,
    get_dashboard_convalidation_state_stats_service,
    get_dashboard_convalidation_department_stats_service,
    get_dashboard_convalidation_month_stats_service,
    get_dashboard_convalidation_resolution_time_stats_service,
    get_dashboard_workshop_stats_service,
    get_dashboard_student_stats_service,
    get_dashboard_activity_stats_service
)

router = APIRouter(prefix="/stats", tags=["stats"])

@router.get("/general-stats/", response_model=Dict[str, Any])
def get_general_stats():
    """Obtiene estadísticas generales del sistema"""
    return get_dashboard_general_stats_service()

@router.get("/convalidation-stats/", response_model=List[Dict[str, Any]])
def get_convalidation_stats():
    """Obtiene estadísticas de convalidaciones por tipo"""
    return get_dashboard_convalidation_stats_service()

@router.get("/convalidation-state-stats/", response_model=List[Dict[str, Any]])
def get_convalidation_state_stats():
    """Obtiene estadísticas de convalidaciones por estado"""
    return get_dashboard_convalidation_state_stats_service()

@router.get("/convalidation-department-stats/", response_model=List[Dict[str, Any]])
def get_convalidation_department_stats():
    """Obtiene estadísticas de convalidaciones por departamento"""
    return get_dashboard_convalidation_department_stats_service()

@router.get("/convalidation-month-stats/", response_model=List[Dict[str, Any]])
def get_convalidation_month_stats():
    """Obtiene estadísticas de convalidaciones por mes"""
    return get_dashboard_convalidation_month_stats_service()

@router.get("/convalidation-resolution-time-stats/", response_model=Dict[str, Any])
def get_convalidation_resolution_time_stats():
    """Obtiene estadísticas de tiempo de resolución de convalidaciones"""
    return get_dashboard_convalidation_resolution_time_stats_service()

@router.get("/workshop-stats/", response_model=List[Dict[str, Any]])
def get_workshop_stats():
    """Obtiene estadísticas de talleres por estado"""
    return get_dashboard_workshop_stats_service()

@router.get("/student-stats/", response_model=List[Dict[str, Any]])
def get_student_stats():
    """Obtiene estadísticas de estudiantes"""
    return get_dashboard_student_stats_service()

@router.get("/activity-stats/", response_model=Dict[str, Any])
def get_activity_stats():
    """Obtiene estadísticas de actividad del sistema"""
    return get_dashboard_activity_stats_service()
