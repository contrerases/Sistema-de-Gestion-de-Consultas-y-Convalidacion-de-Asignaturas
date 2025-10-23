"""
Modelo SQLAlchemy para Curriculum Course Slot Type
"""

from sqlalchemy import Column, Integer, String
from src.database.base import Base
from src.database.constants import Tables


class CurriculumCourseType(Base):
    __tablename__ = Tables.CURRICULUM_COURSES_TYPES
    id = Column(Integer, primary_key=True, autoincrement=True)
    name = Column(String(255), nullable=False)
