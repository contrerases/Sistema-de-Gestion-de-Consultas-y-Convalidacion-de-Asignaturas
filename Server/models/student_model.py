from pydantic import BaseModel

class Student(BaseModel):
    rol: str
    verificator_number: str
    first_name: str
    second_name: str
    first_last_name: str
    second_last_name: str
    email: str
    password: str
