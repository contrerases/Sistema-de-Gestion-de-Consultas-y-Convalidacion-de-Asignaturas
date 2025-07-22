from pydantic import BaseModel

class DashboardGeneralStatsOut(BaseModel):
    total_convalidations: int
    approved_convalidations: int
    rejected_convalidations: int
    pending_convalidations: int
    workshops_in_progress: int
    workshops_finished: int
    convalidations_this_month: int

class DashboardConvalidationStatsOut(BaseModel):
    convalidation_type: str
    total: int

class DashboardConvalidationStateStatsOut(BaseModel):
    convalidation_state: str
    total: int

class DashboardDepartmentStatsOut(BaseModel):
    department: str
    total: int

class DashboardMonthStatsOut(BaseModel):
    year: int
    month: int
    total: int

class DashboardAvgResolutionOut(BaseModel):
    avg_resolution_days: float

class DashboardWorkshopStateStatsOut(BaseModel):
    workshop_state: str
    total: int

class DashboardStudentWorkshopsOut(BaseModel):
    id_student: int
    first_names: str
    last_names: str
    total_workshops: int

class DashboardActivityStatsOut(BaseModel):
    requests_last_week: int
    requests_last_month: int

class DashboardActivityPeakOut(BaseModel):
    day: str
    total: int 