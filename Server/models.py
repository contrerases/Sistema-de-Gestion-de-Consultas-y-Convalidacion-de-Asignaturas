from typing import Optional, Text
from datetime import datetime
from pydantic import BaseModel


class Administrator(BaseModel):
    id: int
    first_name: str
    second_name: str
    first_last_name: str
    second_last_name: str
    email: str
    password: str


class Student(BaseModel):
    rol: str
    verificator_number: str
    first_name: str
    second_name: str
    first_last_name: str
    second_last_name: str
    email: str
    password: str


class Subject(BaseModel):
    id: int
    name: str
    type: str


class Course(BaseModel):
    id: int
    acronym: str
    name: str


class Convalidation(BaseModel):
    id: int
    rol: str
    id_origin_course: int
    id_destination_course: int
    state: str
    comments: Optional[Text]
    creation_date: datetime
    approval_date: Optional[datetime]
    user_approves: int
