"""
Modelo SQLAlchemy para SUBJECTS
Sistema: SGSCT
"""

from sqlalchemy import Column, Integer, String, ForeignKey
from sqlalchemy.orm import relationship
from src.database.base import Base
from src.database.constants import Tables
from src.database.helpers import getTablePrimaryKey


class Subject(Base):
    """Asignaturas de la universidad"""

    __tablename__ = Tables.SUBJECTS

    id = Column("id", Integer, primary_key=True, autoincrement=True)
    acronym = Column("acronym", String(255), nullable=False)
    name = Column("name", String(255), nullable=False)
    id_department = Column(
        "id_department",
        Integer,
        ForeignKey(getTablePrimaryKey(Tables.DEPARTMENTS)),
        nullable=False,
    )
    credits = Column("credits", Integer, nullable=False)

    # Relaciones
    department = relationship(
        "Department",
        back_populates="subject",
    )
