"""
Modelo de Tokens
Sistema: SGSCT
"""
from sqlalchemy import Column, Integer, String, ForeignKey, TIMESTAMP, Boolean
from sqlalchemy.orm import relationship
from sqlalchemy.sql import func
from src.database.base import Base
from src.database.tables import Tables


class WorkshopToken(Base):
    """Modelo para la tabla WORKSHOPS_TOKENS"""
    __tablename__ = Tables.WORKSHOPS_TOKENS

    id = Column(Integer, primary_key=True, autoincrement=True)
    id_workshop = Column("id_workshop", Integer, ForeignKey(f"{Tables.WORKSHOPS}.id"), nullable=False)
    token = Column("token", String(255), unique=True, nullable=False)
    id_professor = Column("id_professor", Integer, ForeignKey("PROFESSORS.id"), nullable=False)
    expiration_at = Column("expiration_at", TIMESTAMP, nullable=False)
    created_at = Column("created_at", TIMESTAMP, nullable=True, server_default=func.current_timestamp())
    used_at = Column("used_at", TIMESTAMP, nullable=True)
    created_by = Column("created_by", Integer, ForeignKey("USERS.id"), nullable=False)
    is_used = Column("is_used", Boolean, nullable=True, default=False)
    
    # Relaciones
    workshop = relationship("Workshop")
    professor = relationship("Professor", foreign_keys=[id_professor])
    creator = relationship("User", foreign_keys=[created_by])
