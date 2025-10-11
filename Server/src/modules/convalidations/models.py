"""
Modelos de Convalidaciones
Sistema: SGSCT
"""
from sqlalchemy import Column, Integer, String, ForeignKey, DECIMAL, TIMESTAMP, Text
from sqlalchemy.orm import relationship
from sqlalchemy.sql import func
from src.database.base import Base
from src.database.tables import Tables


class Convalidation(Base):
    """Modelo para la tabla CONVALIDATIONS"""
    __tablename__ = Tables.CONVALIDATIONS

    id = Column(Integer, primary_key=True, autoincrement=True)
    id_request = Column("id_request", Integer, ForeignKey("REQUESTS.id"), nullable=False)
    id_convalidation_type = Column("id_convalidation_type", Integer, ForeignKey("CONVALIDATION_TYPES.id"), nullable=False)
    id_convalidation_state = Column("id_convalidation_state", Integer, ForeignKey("CONVALIDATION_STATES.id"), nullable=False)
    id_curriculum_course = Column("id_curriculum_course", Integer, ForeignKey("CURRICULUM_COURSE_SLOTS.id"), nullable=False)
    review_comments = Column("review_comments", Text, nullable=True)
    
    # Relaciones
    request = relationship("Request", back_populates="convalidations")
    convalidation_type = relationship("ConvalidationType")
    convalidation_state = relationship("ConvalidationState")
    curriculum_course = relationship("CurriculumCourseSlot")


class ConvalidationSubject(Base):
    """Modelo para la tabla CONVALIDATIONS_SUBJECTS"""
    __tablename__ = Tables.CONVALIDATIONS_SUBJECTS

    id_convalidation = Column("id_convalidation", Integer, ForeignKey("CONVALIDATIONS.id"), primary_key=True)
    id_subject = Column("id_subject", Integer, ForeignKey("SUBJECTS.id"), nullable=False)
    
    # Relaciones
    convalidation = relationship("Convalidation")
    subject = relationship("Subject")


class ConvalidationWorkshop(Base):
    """Modelo para la tabla CONVALIDATIONS_WORKSHOPS"""
    __tablename__ = Tables.CONVALIDATIONS_WORKSHOPS

    id_convalidation = Column("id_convalidation", Integer, ForeignKey("CONVALIDATIONS.id"), primary_key=True)
    id_workshop = Column("id_workshop", Integer, ForeignKey("WORKSHOPS.id"), nullable=False)
    workshop_grade = Column("workshop_grade", DECIMAL(5, 2), nullable=True)
    
    # Relaciones
    convalidation = relationship("Convalidation")
    workshop = relationship("Workshop")


class ConvalidationExternalActivity(Base):
    """Modelo para la tabla CONVALIDATIONS_EXTERNAL_ACTIVITIES"""
    __tablename__ = Tables.CONVALIDATIONS_EXTERNAL_ACTIVITIES

    id_convalidation = Column("id_convalidation", Integer, ForeignKey("CONVALIDATIONS.id"), primary_key=True)
    activity_name = Column("activity_name", String(255), nullable=False)
    institution_name = Column("institution_name", String(255), nullable=True)
    description = Column("description", Text, nullable=True)
    file_path = Column("file_path", String(500), nullable=True)
    
    # Relaciones
    convalidation = relationship("Convalidation")
