"""
Modelo SQLAlchemy para CURRICULUM_COURSE_SLOTS
"""
from sqlalchemy import Column, Integer, String, ForeignKey
from sqlalchemy.orm import relationship
from src.core.database import Base


class CurriculumCourseSlot(Base):
    """
    Curriculum course slots (casillas curriculares)
    Espacios en el currículum que los estudiantes deben llenar
    con talleres aprobados o convalidaciones
    """
    __tablename__ = "CURRICULUM_COURSE_SLOTS"

    id = Column(Integer, primary_key=True, autoincrement=True)
    name = Column(String(255), nullable=False)
    id_curriculum_course_type = Column(Integer, ForeignKey("CURRICULUM_COURSES_TYPES.id"), nullable=False)

    # Relaciones
    course_type = relationship("CurriculumCourseType")
