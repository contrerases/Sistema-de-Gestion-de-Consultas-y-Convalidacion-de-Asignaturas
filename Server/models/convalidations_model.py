from typing import Optional
from datetime import datetime
from pydantic import BaseModel


class Convalidation(BaseModel):
    id: int
    id_request: int
    state: str

    id_convalidation_type: int
    convalidation_type : str

    id_curriculum_course: int
    curriculum_course: str

    id_subject_to_convalidate: Optional[int] = None
    subject: Optional[str] = None

    id_workshop_to_convalidate: Optional[int] = None
    workshop: Optional[str] = None

    certified_course_name: Optional[str] = None
    personal_project_name: Optional[str] = None
    
    file_data: Optional[bytes] = None
    file_name: Optional[str] = None

class ConvalidationUpdate(BaseModel):
    id: int
    state: str
