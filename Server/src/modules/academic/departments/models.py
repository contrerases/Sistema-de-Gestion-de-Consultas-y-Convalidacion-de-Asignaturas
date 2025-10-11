"""
Modelo SQLAlchemy para DEPARTMENTS
Sistema: SGSCT
"""
from sqlalchemy import Column, Integer, String
from sqlalchemy.orm import relationship
from src.database.base import Base
from src.database.tables import Tables


class Department(Base):
    """Departamentos académicos de la universidad"""
    
    __tablename__ = Tables.DEPARTMENTS
    
    id = Column(Integer, primary_key=True, autoincrement=True)
    name = Column(String(255), nullable=False)
    
    # Relaciones
    subjects = relationship("Subject", back_populates="department")
