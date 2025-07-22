from pydantic import BaseModel
 
class ConvalidationTypeOut(BaseModel):
    id: int
    name: str 