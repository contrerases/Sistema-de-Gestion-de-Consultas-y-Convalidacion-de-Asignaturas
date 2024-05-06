from typing import Optional, Text
from datetime import datetime
from pydantic import BaseModel
from fastapi import UploadFile, File


class ConvalidationBase(BaseModel):
    id_student: int
    id_convalidation_type: int
    state: str
    comments: Optional[str] = None
    creation_date: Optional[datetime] = None
    revision_date: Optional[datetime] = None
    id_user_approves: Optional[int] = None 
    id_curriculum_course: int
    id_subject_to_convalidate: Optional[int] = None
    id_workshop_to_convalidate: Optional[int] = None
    certified_course_name: Optional[str] = None
    personal_project_name: Optional[str] = None
    file_data: Optional[UploadFile] = File(None)
    file_name: Optional[str] = None


class ConvalidationResponse(BaseModel):
    id: int
    student_name: str
    student_rol: str
    convalidation_type: str
    state: str
    comments: Optional[str] = None
    creation_date: Optional[datetime] = None
    revision_date: Optional[datetime] = None
    approves_user: Optional[str] = None
    curriculum_course: str
    subject: Optional[str] = None
    workshop: Optional[str] = None
    certified_course_name: Optional[str] = None
    personal_project_name: Optional[str] = None
    file_data: Optional[bytes] = None
    file_name: Optional[str] = None


class ConvalidationUpdate(BaseModel):
    id: int
    state: str
    comments: str