"""
Modelo SQLAlchemy para DEPARTMENTS
Sistema: SGSCT
"""

from sqlalchemy import Column, Integer, String
from sqlalchemy.orm import relationship
from src.database.base import Base
from src.database.constants import Tables


class Department(Base):
    """Departamentos académicos de la universidad"""

    __tablename__ = Tables.DEPARTMENTS

    id = Column("id", Integer, primary_key=True, autoincrement=True)
    name = Column("name", String(255), nullable=False)

    # Relaciones
    subject = relationship(
        "Subject",
        back_populates="department",
    )
