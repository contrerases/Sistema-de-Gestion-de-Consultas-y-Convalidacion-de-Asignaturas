"""
Modelo SQLAlchemy para CONVALIDATION_TYPES
Sistema: SGSCT
"""
from sqlalchemy import Column, Integer, String
from src.database.base import Base
from src.database.tables import Tables


class ConvalidationType(Base):
    __tablename__ = Tables.CONVALIDATION_TYPES
    
    id = Column(Integer, primary_key=True, autoincrement=True)
    convalidation_type = Column("name", String(255), nullable=False)
