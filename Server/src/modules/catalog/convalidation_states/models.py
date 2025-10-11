"""
Modelo SQLAlchemy para CONVALIDATION_STATES
Sistema: SGSCT
"""
from sqlalchemy import Column, Integer, String, Text
from src.database.base import Base
from src.database.tables import Tables


class ConvalidationState(Base):
    __tablename__ = Tables.CONVALIDATION_STATES
    
    id = Column(Integer, primary_key=True, autoincrement=True)
    convalidation_state = Column("name", String(255), nullable=False)
    description = Column(Text, nullable=True)
