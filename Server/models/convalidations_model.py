from typing import Optional, Text
from datetime import datetime
from pydantic import BaseModel


class ConvalidationBase(BaseModel):
    id: int
    id_student: int
    id_convalidation_type: int
    state: str
    comments: Optional[str]
    creation_date: datetime
    revision_date: Optional[datetime]
    id_user_approves: int
    id_curriculum_course: int
    id_subject_to_convalidate: Optional[int]
    id_workshop_to_convalidate: Optional[int]
    certified_course_name: Optional[str]
    personal_project_name: Optional[str]
    file_data: Optional[bytes]
    file_name: Optional[str]

class ConvalidationResponse(BaseModel):
    id: int
    student_name: str
    student_rol: str
    convalidation_type: str
    state: str
    comments: Optional[Text]
    creation_date: datetime
    revision_date: Optional[datetime]
    approves_user: str
    curriculum_course: str
    subject: Optional[str]
    workshop: Optional[str]
    certified_course_name: Optional[str]
    personal_project_name: Optional[str]
    file_data: Optional[bytes]
    file_name: Optional[str]