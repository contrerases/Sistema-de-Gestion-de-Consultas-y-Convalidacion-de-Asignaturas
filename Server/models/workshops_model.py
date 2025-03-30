from pydantic import BaseModel
from datetime import datetime
from typing import Literal


class WorkshopBase(BaseModel):
    id: int
    name: str
    semester : int
    year : int
    professor : str
    initial_date : datetime
    inscription_deadline : datetime
    file_data : str | None
    available : bool
    state : str


class WorkshopPost(BaseModel):
    name: str
    semester : int
    year : int
    professor : str
    initial_date : datetime
    inscription_deadline : datetime
    file_data : str | None
    


class WorkshopResponse(BaseModel):
    id: int
    name: str
    semester : str
    professor : str
    year : int
    initial_date : datetime
    inscription_deadline : datetime
    file_data : str | None
    available : bool
    state : str