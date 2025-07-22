from pydantic import BaseModel
from typing import Optional

class WorkshopGradeIn(BaseModel):
    id_workshop: Optional[int] = None
    id_student: Optional[int] = None
    min_grade: Optional[int] = None
    max_grade: Optional[int] = None
    grade: Optional[int] = None 