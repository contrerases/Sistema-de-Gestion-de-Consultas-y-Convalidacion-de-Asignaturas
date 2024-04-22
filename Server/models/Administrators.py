from pydantic import BaseModel

class Administrator(BaseModel):
    id: int
    first_name: str
    second_name: str
    first_last_name: str
    second_last_name: str
    email: str
    password: str
