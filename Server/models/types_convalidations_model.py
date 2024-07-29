from pydantic import BaseModel


class TypeConvaldiationsBase(BaseModel):
    id: int
    name: str

class TypeConvaldiationsResponse(TypeConvaldiationsBase):
    pass


class TypeConvaldiationsInsert(BaseModel):
    name: str