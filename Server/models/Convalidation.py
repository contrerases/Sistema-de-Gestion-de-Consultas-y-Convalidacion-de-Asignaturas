from typing import Optional, Text
from datetime import datetime
from pydantic import BaseModel

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
