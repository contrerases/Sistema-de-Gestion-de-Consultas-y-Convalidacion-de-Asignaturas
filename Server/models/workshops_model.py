from pydantic import BaseModel
from datetime import datetime

class WorkshopBase(BaseModel):
    id: int
    name: str
    semester : str
    year : int
    professor : str
    initial_date : datetime
    file_data : str | None
    available : bool


class WorkshopPost(BaseModel):
    name: str
    semester : str
    year : int
    professor : str
    initial_date : datetime
    file_data : str | None


class WorkshopResponse(BaseModel):
    id: int
    name: str
    semester : str
    professor : str
    year : int
    initial_date : datetime
    file_data : str | None
    available : bool