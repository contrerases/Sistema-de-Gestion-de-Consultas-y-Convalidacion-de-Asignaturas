from pydantic import BaseModel
from typing import Optional
from datetime import datetime

class WorkshopSearch(BaseModel):
    id_workshop: Optional[int] = None
    name: Optional[str] = None
    semester: Optional[str] = None
    year: Optional[int] = None
    professor: Optional[str] = None
    description: Optional[str] = None
    inscription_start_date: Optional[datetime] = None
    inscription_end_date: Optional[datetime] = None
    course_start_date: Optional[datetime] = None
    course_end_date: Optional[datetime] = None
    available: Optional[bool] = None
    limit_inscriptions: Optional[int] = None
    id_workshop_state: Optional[int] = None 