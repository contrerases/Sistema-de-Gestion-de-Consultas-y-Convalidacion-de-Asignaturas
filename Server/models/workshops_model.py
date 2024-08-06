from pydantic import BaseModel
import datetime


class WorkshopBase(BaseModel):
    id: int
    name: str
    semester : str
    year : int
    initial_date : datetime
    file_data : str
    available : bool


class WorkshopPost(BaseModel):
    name: str
    semester : str
    year : int
    initial_date : datetime
    file_data : str
    available : bool

class WorkshopResponse(BaseModel):
    id: int
    name: str
    semester : str
    year : int
    initial_date : datetime
    file_data : str
    available : bool