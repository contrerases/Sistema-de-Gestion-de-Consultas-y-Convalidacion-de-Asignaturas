from pydantic import BaseModel


class WorkshopBase(BaseModel):
    id: int
    name: str

class WorkshopPost(BaseModel):
    name: str