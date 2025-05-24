from pydantic import BaseModel
from datetime import datetime
from typing import  Optional


class WorkshopBase(BaseModel):
    id: int
    name: str
    semester : int
    year : int
    professor : str
    initial_date : datetime
    inscription_deadline : datetime
    file_data : Optional[str]
    available : bool
    state : str


class WorkshopPost(BaseModel):
    name: str
    semester : int
    year : int
    professor : str
    initial_date : datetime
    inscription_deadline : datetime
    file_data : Optional[str]
    


class WorkshopResponse(BaseModel):
    id: int
    name: str
    semester : str
    professor : str
    year : int
    initial_date : datetime
    Inscription_deadline: Optional[datetime] = None 
    file_data : Optional[str] = None
    available : bool
    state: Optional[str] = None

class WorkshopUpdateAvailable(BaseModel):
    id: int
    available: bool
