from pydantic import BaseModel
from typing import List, Generic, TypeVar

T = TypeVar("T")


class PaginatedResponse(BaseModel, Generic[T]):
    total: int
    items: List[T]
    skip: int
    limit: int
