from fastapi import APIRouter
from services.statistics_service import get_general_stats_service, get_convalidation_stats_service, get_convalidation_state_stats_service, get_convalidation_department_stats_service, get_convalidation_month_stats_service, get_convalidation_resolution_time_stats_service, get_workshop_stats_service, get_activity_stats_service, get_student_stats_service
from schemas.statistics.statistics import DashboardGeneralStatsOut, DashboardConvalidationStatsOut, DashboardConvalidationStateStatsOut, DashboardDepartmentStatsOut, DashboardMonthStatsOut, DashboardAvgResolutionOut, DashboardWorkshopStateStatsOut, DashboardStudentWorkshopsOut, DashboardActivityStatsOut

router = APIRouter(prefix="/stats", tags=["stats"])
 

@router.get("/general", response_model=DashboardGeneralStatsOut)
def get_general_stats():
    return get_general_stats_service()

@router.get("/convalidation", response_model=DashboardConvalidationStatsOut)
def get_convalidation_stats():
    return get_convalidation_stats_service()

@router.get("/convalidation-state", response_model=DashboardConvalidationStateStatsOut)
def get_convalidation_state_stats():
    return get_convalidation_state_stats_service()

@router.get("/convalidation-department", response_model=DashboardDepartmentStatsOut)
def get_convalidation_department_stats():
    return get_convalidation_department_stats_service()

@router.get("/convalidation-month", response_model=DashboardMonthStatsOut)
def get_convalidation_month_stats():
    return get_convalidation_month_stats_service()

@router.get("/convalidation-resolution-time", response_model=DashboardAvgResolutionOut)
def get_convalidation_resolution_time_stats():
    return get_convalidation_resolution_time_stats_service()

@router.get("/workshop", response_model=DashboardWorkshopStateStatsOut)
def get_workshop_stats():
    return get_workshop_stats_service()

@router.get("/student", response_model=DashboardStudentWorkshopsOut)
def get_student_stats():
    return get_student_stats_service() 

@router.get("/activity", response_model=DashboardActivityStatsOut)
def get_activity_stats():
    return get_activity_stats_service()
