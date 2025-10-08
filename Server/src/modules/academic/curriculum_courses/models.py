"""
Modelo SQLAlchemy para CURRICULUM_COURSE_SLOTS
Sistema: SGSCT
"""
from sqlalchemy import Column, Integer, String, ForeignKey
from sqlalchemy.orm import relationship
from src.database.connection import Base


class CurriculumCourseSlot(Base):
    """Casillas curriculares que los estudiantes deben completar"""
    
    __tablename__ = "CURRICULUM_COURSE_SLOTS"

    id = Column(Integer, primary_key=True, autoincrement=True)
    name = Column(String(255), nullable=False)
    id_curriculum_course_type = Column(Integer, ForeignKey("CURRICULUM_COURSES_TYPES.id"), nullable=False)

    # Relación con tipo de curso curricular (del módulo catalog)
    # Nota: La relación completa se configurará cuando se cree el modelo en catalog
    # course_type = relationship("CurriculumCourseType", back_populates="slots")
