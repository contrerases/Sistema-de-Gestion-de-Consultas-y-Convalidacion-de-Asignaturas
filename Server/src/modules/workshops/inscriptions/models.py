"""
Modelo de Inscriptions
Sistema: SGSCT
"""
from sqlalchemy import Column, Integer, ForeignKey, TIMESTAMP, Boolean
from sqlalchemy.orm import relationship
from sqlalchemy.sql import func
from src.database.base import Base
from src.database.tables import Tables


class WorkshopInscription(Base):
    """Modelo para la tabla WORKSHOPS_INSCRIPTIONS"""
    __tablename__ = Tables.WORKSHOPS_INSCRIPTIONS

    id = Column(Integer, primary_key=True, autoincrement=True)
    id_student = Column("id_student", Integer, ForeignKey("USERS.id"), nullable=False)
    id_workshop = Column("id_workshop", Integer, ForeignKey("WORKSHOPS.id"), nullable=False)
    id_curriculum_course = Column("id_curriculum_course", Integer, ForeignKey("CURRICULUM_COURSE_SLOTS.id"), nullable=True)
    is_convalidated = Column("is_convalidated", Boolean, nullable=False, default=False)
    inscription_at = Column("inscription_at", TIMESTAMP, nullable=False, server_default=func.current_timestamp())
    
    # Relaciones
    student = relationship("User")
    workshop = relationship("Workshop", back_populates="inscriptions")
    curriculum_course = relationship("CurriculumCourseSlot")
