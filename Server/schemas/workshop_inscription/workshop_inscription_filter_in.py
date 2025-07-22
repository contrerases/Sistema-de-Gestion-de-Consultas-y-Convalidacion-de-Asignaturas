from pydantic import BaseModel
from typing import Optional

class WorkshopInscriptionFilterIn(BaseModel):
    id_inscription: Optional[int] = None
    id_student: Optional[int] = None
    id_workshop: Optional[int] = None
    id_curriculum_course: Optional[int] = None
    is_convalidated: Optional[bool] = None 