"""
Modelo de Requests (Solicitudes)
Sistema: SGSCT
"""
from sqlalchemy import Column, Integer, ForeignKey, TIMESTAMP
from sqlalchemy.orm import relationship
from sqlalchemy.sql import func
from src.database.base import Base
from src.database.tables import Tables


class Request(Base):
    """Modelo para la tabla REQUESTS"""
    __tablename__ = Tables.REQUESTS

    id = Column(Integer, primary_key=True, autoincrement=True)
    id_student = Column("id_student", Integer, ForeignKey("USERS.id"), nullable=False)
    sent_at = Column("sent_at", TIMESTAMP, nullable=True, server_default=func.current_timestamp())
    id_reviewed_by = Column("id_reviewed_by", Integer, ForeignKey("USERS.id"), nullable=True)
    reviewed_at = Column("reviewed_at", TIMESTAMP, nullable=True)
    
    # Relaciones
    student = relationship("User", foreign_keys=[id_student])
    reviewed_by = relationship("User", foreign_keys=[id_reviewed_by])
    convalidations = relationship("Convalidation", back_populates="request")
