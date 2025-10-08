"""
Modelo Campus
Sistema: SGSCT
"""
from sqlalchemy import Column, Integer, String
from src.database.base import Base


class Campus(Base):
    """Modelo CAMPUS - Campus universitarios"""
    __tablename__ = "CAMPUS"
    
    id = Column(Integer, primary_key=True, autoincrement=True)
    acronym = Column(String(10), nullable=False, unique=True, index=True)
    name = Column(String(255), nullable=False)
    location = Column(String(255), nullable=False)
    
    def __repr__(self):
        return f"<Campus(id={self.id}, acronym='{self.acronym}', name='{self.name}')>"
