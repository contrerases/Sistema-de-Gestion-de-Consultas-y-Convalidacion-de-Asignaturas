"""
Modelo Campus
Sistema: SGSCT
"""

from sqlalchemy import Column, Integer, String
from src.database.base import Base
from src.database.constants import Tables


class Campus(Base):
    """Modelo CAMPUS - Campus"""

    __tablename__ = Tables.CAMPUS

    id = Column("id", Integer, primary_key=True, autoincrement=True)
    acronym = Column("acronym", String(255), nullable=False, unique=True, index=True)
    name = Column("name", String(255), nullable=False)
    location = Column("location", String(255), nullable=False)
