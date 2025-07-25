from pydantic import BaseModel
from typing import Optional
 
class ConvalidationStateOut(BaseModel):
    id_convalidation_state: int
    convalidation_state: str
    description: Optional[str] = None 