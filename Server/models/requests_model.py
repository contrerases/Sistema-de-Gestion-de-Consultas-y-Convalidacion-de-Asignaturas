from pydantic import BaseModel
from typing import List, Optional
from datetime import datetime

from models.convalidations_model import  ConvalidationUpdate, ConvalidationResponse, ConvaldiationInsert


class RequestInsert(BaseModel):
    id_student: int
    comments: Optional[str] = None 
    id_user_approves: Optional[int] = None
    convalidations: List[ConvaldiationInsert]

class Request(RequestInsert):
    id: int
    
class RequestResponse(Request):
    user_approves: Optional[str]
    rol_student: str
    name_student : str
    rut_student: str
    campus_student: str
    creation_date: Optional[datetime] = None
    revision_date: Optional[datetime] = None
    convalidations: List[ConvalidationResponse]

class RequestUpdate(BaseModel):
    id: int
    comments:Optional[str] 
    id_user_approver: int 
    convalidations: List[ConvalidationUpdate]
