"""
Modelos de Workshops
Sistema: SGSCT
"""
from sqlalchemy import Column, Integer, String, ForeignKey, DECIMAL, TIMESTAMP, Date, Text, Boolean
from sqlalchemy.orm import relationship
from sqlalchemy.sql import func
from src.database.base import Base
from src.database.tables import Tables


class Workshop(Base):
    """Modelo para la tabla WORKSHOPS"""
    __tablename__ = Tables.WORKSHOPS

    id = Column(Integer, primary_key=True, autoincrement=True)
    name = Column("name", String(255), nullable=False)
    description = Column("description", String(1000), nullable=True)
    id_campus = Column("id_campus", Integer, ForeignKey(f"{Tables.CAMPUS}.id"), nullable=False)
    id_workshop_state = Column("id_workshop_state", Integer, ForeignKey(f"{Tables.WORKSHOP_STATES}.id"), nullable=False)
    id_department = Column("id_department", Integer, ForeignKey(f"{Tables.DEPARTMENTS}.id"), nullable=False)
    syllabus_path = Column("syllabus_path", String(500), nullable=True)
    slug = Column("slug", String(255), unique=True, nullable=False)
    max_students = Column("max_students", Integer, nullable=False)
    min_students = Column("min_students", Integer, nullable=False)
    inscription_start = Column("inscription_start", Date, nullable=False)
    inscription_end = Column("inscription_end", Date, nullable=False)
    course_start = Column("course_start", Date, nullable=False)
    course_end = Column("course_end", Date, nullable=False)
    
    # Relaciones
    campus = relationship("Campus")
    workshop_state = relationship("WorkshopState")
    department = relationship("Department")
    inscriptions = relationship("WorkshopInscription", back_populates="workshop")
