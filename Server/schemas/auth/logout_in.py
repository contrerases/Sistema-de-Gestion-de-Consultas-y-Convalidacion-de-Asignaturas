from pydantic import BaseModel

class LogoutIn(BaseModel):
    user_id: int