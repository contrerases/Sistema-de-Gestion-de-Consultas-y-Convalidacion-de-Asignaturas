from pydantic import BaseModel
from typing import Optional

class WorkshopInscriptionCreateIn(BaseModel):
    id_student: int
    id_workshop: int
    id_curriculum_course: Optional[int] = None
    is_convalidated: bool = False 