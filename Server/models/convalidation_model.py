from typing import Optional, Text
from datetime import datetime
from pydantic import BaseModel



class ConvalidationBase(BaseModel):
    id : int
    id_student: int
    convalidation_type: int
    id_generic_course: int
    id_specific_course: int
    state: str = "Enviada"
    comments: Optional[str] = None
    creation_date: datetime
    revision_date: Optional[datetime] = None
    user_approves: int
    file: Optional[bytes]
    file_name: Optional[str]

class ConvalidationResponse(BaseModel):
    id : int
    rol_student: str
    convalidation_type: str
    name_generic_course: str
    name_specific_course: str
    state: str
    comments: Optional[str] = None
    creation_date: datetime
    revision_date: Optional[datetime] = None
    user_approves_name: str
    file: Optional[bytes]
    file_name: Optional[str]