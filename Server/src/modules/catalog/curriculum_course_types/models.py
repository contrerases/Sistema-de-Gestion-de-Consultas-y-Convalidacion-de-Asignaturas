"""
Modelo SQLAlchemy para CURRICULUM_COURSES_TYPES
Sistema: SGSCT
"""
from sqlalchemy import Column, Integer, String
from src.database.connection import Base


class CurriculumCourseType(Base):
    __tablename__ = "CURRICULUM_COURSES_TYPES"
    
    id = Column(Integer, primary_key=True, autoincrement=True)
    curriculum_course_type = Column("name", String(255), nullable=False)
