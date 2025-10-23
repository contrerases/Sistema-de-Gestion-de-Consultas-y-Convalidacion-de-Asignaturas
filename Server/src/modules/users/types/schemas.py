"""
Schemas Pydantic para USER_TYPES
"""

from pydantic import BaseModel


class UserTypeBase(BaseModel):
    name: str


class UserTypeCreate(UserTypeBase):
    pass


class UserTypeUpdate(UserTypeBase):
    pass


class UserTypeResponse(UserTypeBase):
    id: int

    class Config:
        from_attributes = True
