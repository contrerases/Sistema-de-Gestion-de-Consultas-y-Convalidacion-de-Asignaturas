"""
Modelo SQLAlchemy para Curriculum Course Slot Base
"""

from sqlalchemy import Column, Integer, String, ForeignKey
from sqlalchemy.orm import relationship
from src.database.base import Base
from src.database.constants import Tables


class CurriculumCourseSlot(Base):
    __tablename__ = Tables.CURRICULUM_COURSE_SLOTS
    id = Column(Integer, primary_key=True, autoincrement=True)
    name = Column(String(255), nullable=False)
    id_curriculum_course_type = Column(
        Integer,
        ForeignKey('CURRICULUM_COURSES_TYPES.id', ondelete="RESTRICT", onupdate="CASCADE"),
        nullable=False
    )
    curriculum_course_type = relationship("CurriculumCourseType")
