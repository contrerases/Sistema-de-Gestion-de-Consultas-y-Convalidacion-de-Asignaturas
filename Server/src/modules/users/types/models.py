"""
Modelos para USER_TYPES
"""

from sqlalchemy import Column, Integer, String
from src.database.base import Base
from src.database.constants import Tables


class UserType(Base):
    __tablename__ = Tables.USER_TYPES

    id = Column(Integer, primary_key=True, autoincrement=True)
    name = Column(String(50), unique=True, nullable=False)

    def __repr__(self):
        return f"<UserType(id={self.id}, name='{self.name}')>"
