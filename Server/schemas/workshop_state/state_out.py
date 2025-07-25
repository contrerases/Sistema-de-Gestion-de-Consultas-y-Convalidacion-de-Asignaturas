from pydantic import BaseModel, Field
from utils.constants import MAX_LENGTH_NAME

class WorkshopStateOut(BaseModel):
    id_workshop_state: int = Field(..., alias="id_workshop_state")
    workshop_state: str = Field(..., max_length=MAX_LENGTH_NAME)

    class Config:
        populate_by_name = True 