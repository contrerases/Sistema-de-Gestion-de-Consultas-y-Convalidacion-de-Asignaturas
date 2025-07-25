from pydantic import BaseModel
from typing import Optional

class WorkshopInscriptionIn(BaseModel):
    id_workshop: int
    id_student: int
    is_convalidated: Optional[bool] = False
    id_curriculum_course: Optional[int] = None 