"""
Modelo SQLAlchemy para SUBJECTS
Sistema: SGSCT
"""
from sqlalchemy import Column, Integer, String, ForeignKey
from sqlalchemy.orm import relationship
from src.database.connection import Base


class Subject(Base):
    """Asignaturas de la universidad"""
    
    __tablename__ = "SUBJECTS"
    
    id = Column(Integer, primary_key=True, autoincrement=True)
    acronym = Column(String(255), nullable=False)
    name = Column(String(255), nullable=False)
    id_department = Column("id_department", Integer, ForeignKey("DEPARTMENTS.id"), nullable=False)
    credits = Column(Integer, nullable=False)
    
    # Relaciones
    department = relationship("Department", back_populates="subjects")
