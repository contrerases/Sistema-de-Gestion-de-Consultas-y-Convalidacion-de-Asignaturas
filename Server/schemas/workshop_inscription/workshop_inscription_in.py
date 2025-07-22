from pydantic import BaseModel
from typing import Optional

class WorkshopInscriptionIn(BaseModel):
    id_student: int
    id_workshop: int
    id_curriculum_course: Optional[int] = None
    is_convalidated: Optional[bool] = False 