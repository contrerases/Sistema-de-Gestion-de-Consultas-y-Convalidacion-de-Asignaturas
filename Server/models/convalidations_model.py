from typing import Optional
from datetime import datetime
from pydantic import BaseModel


class Convalidation(BaseModel):
    id: int
    id_request: int
    id_convalidation_type: int
    state: str
    id_curriculum_course: int
    id_subject_to_convalidate: Optional[int] = None
    id_workshop_to_convalidate: Optional[int] = None
    certified_course_name: Optional[str] = None
    personal_project_name: Optional[str] = None
    file_data: Optional[bytes] = None
    file_name: Optional[str] = None
