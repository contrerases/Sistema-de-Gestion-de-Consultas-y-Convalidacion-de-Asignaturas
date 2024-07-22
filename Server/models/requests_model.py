from pydantic import BaseModel
from typing import List, Optional
from datetime import datetime

from models.convalidations_model import Convalidation

class Request(BaseModel):
    id: int
    id_student: int
    creation_date: datetime
    revision_date: Optional[datetime] = None
    comments: Optional[str] = None
    id_user_approves: Optional[int] = None
    convalidations: List[Convalidation]
    
class RequestResponse(Request):
    rol_student: str
    rut_student: str
    campus_student: str


