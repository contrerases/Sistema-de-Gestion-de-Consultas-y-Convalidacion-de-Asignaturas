"""
Modelo SQLAlchemy para CONVALIDATION_TYPES
Sistema: SGSCT
"""
from sqlalchemy import Column, Integer, String
from src.database.connection import Base


class ConvalidationType(Base):
    __tablename__ = "CONVALIDATION_TYPES"
    
    id = Column(Integer, primary_key=True, autoincrement=True)
    convalidation_type = Column("name", String(255), nullable=False)
