"""
Modelo SQLAlchemy para WORKSHOP_STATES
Sistema: SGSCT
"""
from sqlalchemy import Column, Integer, String, Text
from src.database.connection import Base


class WorkshopState(Base):
    __tablename__ = "WORKSHOP_STATES"
    
    id = Column(Integer, primary_key=True, autoincrement=True)
    workshop_state = Column("name", String(255), nullable=False)
    description = Column(Text, nullable=True)
