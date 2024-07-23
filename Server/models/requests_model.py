from pydantic import BaseModel
from typing import List, Optional
from datetime import datetime

from models.convalidations_model import Convalidation


class RequestInsert(BaseModel):
    id_student: int
    creation_date: datetime
    revision_date: Optional[datetime] = None
    comments: Optional[str] = None
    id_user_approves: Optional[int] = None
    convalidations: List[Convalidation]

class Request(RequestInsert):
    id: int
    
class RequestResponse(Request):
    rol_student: str
    rut_student: str
    campus_student: str


