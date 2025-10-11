"""
Modelo de Grades
Sistema: SGSCT
"""
from sqlalchemy import Column, Integer, ForeignKey, TIMESTAMP
from sqlalchemy.orm import relationship
from sqlalchemy.sql import func
from src.database.base import Base
from src.database.tables import Tables


class WorkshopGrade(Base):
    """Modelo para la tabla WORKSHOPS_GRADES"""
    __tablename__ = Tables.WORKSHOPS_GRADES

    id = Column(Integer, primary_key=True, autoincrement=True)
    id_student = Column("id_student", Integer, ForeignKey("USERS.id"), nullable=False)
    id_workshop = Column("id_workshop", Integer, ForeignKey("WORKSHOPS.id"), nullable=False)
    grade = Column("grade", Integer, nullable=False)
    evaluated_at = Column("evaluated_at", TIMESTAMP, nullable=False, server_default=func.current_timestamp())
    
    # Relaciones
    student = relationship("User")
    workshop = relationship("Workshop")
