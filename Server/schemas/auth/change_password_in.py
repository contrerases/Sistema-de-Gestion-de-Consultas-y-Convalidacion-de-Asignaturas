from pydantic import BaseModel

class ChangePasswordIn(BaseModel):
    user_id: int
    current_password: str
    new_password: str