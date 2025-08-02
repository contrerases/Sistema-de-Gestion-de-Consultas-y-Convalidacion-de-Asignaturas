from pydantic import BaseModel

class StatsGeneralOut(BaseModel):
    total_students: int
    total_admins: int
    total_workshops: int
    total_requests: int
    total_convalidations: int
    total_inscriptions: int
    total_grades: int
    workshops_inscription: int
    workshops_in_progress: int
    workshops_finished: int
    convalidations_pending: int
    convalidations_approved: int
    convalidations_rejected: int 