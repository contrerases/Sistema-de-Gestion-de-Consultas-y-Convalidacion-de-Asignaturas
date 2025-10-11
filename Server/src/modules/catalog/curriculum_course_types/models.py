"""
Modelo SQLAlchemy para CURRICULUM_COURSES_TYPES
Sistema: SGSCT
"""
from sqlalchemy import Column, Integer, String
from src.database.base import Base
from src.database.tables import Tables


class CurriculumCourseType(Base):
    __tablename__ = Tables.CURRICULUM_COURSES_TYPES
    
    id = Column(Integer, primary_key=True, autoincrement=True)
    curriculum_course_type = Column("name", String(255), nullable=False)
