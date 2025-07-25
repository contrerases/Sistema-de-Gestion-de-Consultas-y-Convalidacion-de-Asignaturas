from pydantic import BaseModel
 
class ConvalidationTypeOut(BaseModel):
    id_convalidation_type: int
    convalidation_type: str 