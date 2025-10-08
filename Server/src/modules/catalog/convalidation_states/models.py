"""
Modelo SQLAlchemy para CONVALIDATION_STATES
Sistema: SGSCT
"""
from sqlalchemy import Column, Integer, String, Text
from src.database.connection import Base


class ConvalidationState(Base):
    __tablename__ = "CONVALIDATION_STATES"
    
    id = Column(Integer, primary_key=True, autoincrement=True)
    convalidation_state = Column("name", String(255), nullable=False)
    description = Column(Text, nullable=True)
