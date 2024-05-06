from typing import Optional, Text
from datetime import datetime
from pydantic import BaseModel
from fastapi import UploadFile, File, Form


class ConvalidationBase(BaseModel):
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
    file_data: Optional[UploadFile] = File(None)
    file_name: Optional[str]


class ConvalidationResponse(BaseModel):
    id: int
    student_name: str
    student_rol: str
    convalidation_type: str
    state: str
    comments: Optional[str] = None
    creation_date: datetime
    revision_date: Optional[datetime] = None
    approves_user: str
    curriculum_course: str
    subject: Optional[str] = None
    workshop: Optional[str] = None
    certified_course_name: Optional[str] = None
    personal_project_name: Optional[str] = None
    file_data: Optional[bytes] = None
    file_name: Optional[str] = None
