from pydantic import BaseModel
from schemas.auth.auth_user_out import AuthUserOut

class LoginOut(BaseModel):
    access_token: str
    token_type: str
    user: AuthUserOut