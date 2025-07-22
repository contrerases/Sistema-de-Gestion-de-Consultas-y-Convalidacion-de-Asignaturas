from pydantic import BaseModel, Field
from utils.constants import MAX_LENGTH_NAME

class WorkshopStateOut(BaseModel):
    id: int = Field(..., alias="id_workshop_state")
    name: str = Field(..., max_length=MAX_LENGTH_NAME)

    class Config:
        populate_by_name = True 