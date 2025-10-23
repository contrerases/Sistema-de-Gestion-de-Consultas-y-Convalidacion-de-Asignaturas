"""
Modelos del submódulo Professors
Sistema: SGSCT
"""

from sqlalchemy import Column, Integer, String
from src.database.base import Base
from src.database.constants import Tables


class Professor(Base):
    """
    Modelo PROFESSORS - Información de profesores
    Tabla independiente para profesores de talleres
    """

    __tablename__ = Tables.PROFESSORS

    id = Column(Integer, primary_key=True, autoincrement=True)
    name = Column(String(255), nullable=False)
    email = Column(String(255), nullable=False, unique=True)

    def __repr__(self):
        return f"<Professor(id={self.id}, name='{self.name}', email='{self.email}')>"
