from pydantic import BaseModel
from typing import Optional
 
class ConvalidationStateOut(BaseModel):
    id: int
    name: str
    description: Optional[str] = None 