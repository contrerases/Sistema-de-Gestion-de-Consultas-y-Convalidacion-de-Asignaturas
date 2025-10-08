"""
Repositorio base genérico
Sistema: SGSCT
"""
from typing import TypeVar, Generic, Optional, List, Type
from sqlalchemy.orm import Session
from src.database.connection import Base

T = TypeVar('T', bound=Base)


class BaseRepository(Generic[T]):
    
    def __init__(self, model: Type[T], db: Session):
        self.model = model
        self.db = db
