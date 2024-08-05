from typing import Optional
from datetime import datetime
from pydantic import BaseModel


class ConvaldiationInsert(BaseModel):
    id_convalidation_type: int
    id_curriculum_course: int
    id_subject_to_convalidate: Optional[int] = None
    id_workshop_to_convalidate: Optional[int] = None
    certified_course_name: Optional[str] = None
    personal_project_name: Optional[str] = None
    file_data: Optional[bytes] = None
    file_name: Optional[str] = None

class Convalidation(ConvaldiationInsert):
    id: int
    id_request: int
    state: str



class ConvalidationResponse(Convalidation):
    convalidation_type : str
    curriculum_course: str
    subject: Optional[str] = None
    workshop: Optional[str] = None

 
  

class ConvalidationUpdate(BaseModel):
    id: int
    state: str
