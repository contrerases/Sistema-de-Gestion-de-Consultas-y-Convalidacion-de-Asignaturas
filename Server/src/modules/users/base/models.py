"""
Modelos del módulo Users
Sistema: SGSCT

Contiene:
- User: Información de usuarios del sistema (vinculado a AuthUser)
- Professor: Profesores de talleres (tabla independiente)
"""

from sqlalchemy import Column, Integer, String, ForeignKey
from sqlalchemy.orm import relationship
from src.database.base import Base
from src.database.constants import Tables
from src.database.helpers import getTablePrimaryKey





class User(Base):
    """
    Modelo USERS - Información del usuario
    Vinculado a AuthUser (auth/models.py) mediante relación 1:1
    """

    __tablename__ = Tables.USERS

    id = Column(
        Integer,
        ForeignKey(
            getTablePrimaryKey(Tables.AUTH_USERS),
            ondelete="CASCADE",
            onupdate="CASCADE",
        ),
        primary_key=True,
    )
    full_name = Column(String(255), nullable=False)
    id_campus = Column(
        Integer,
        ForeignKey(
            getTablePrimaryKey(Tables.CAMPUS), ondelete="RESTRICT", onupdate="CASCADE"
        ),
        nullable=False,
    )
    id_user_type = Column(
        Integer,
        ForeignKey(
            getTablePrimaryKey(Tables.USER_TYPES),
            ondelete="RESTRICT",
            onupdate="CASCADE",
        ),
        nullable=False,
    )
    rol_student = Column(String(11), unique=True, nullable=True)
    rut_student = Column(String(12), unique=True, nullable=True)

    # NOTA: La validación de formato para rol_student y rut_student se realiza a nivel de base de datos (CHECK) y debe reforzarse en la capa de validación (Pydantic o similar).

    # Relaciones
    # Usar referencia string para evitar ciclo de importación con AuthUser
    auth_user = relationship("AuthUser", back_populates="user")
    campus = relationship("Campus")
    
    user_type = relationship("UserType")

    def __repr__(self):
        return f"<User(id={self.id}, full_name='{self.full_name}')>"

    @property
    def is_student(self) -> bool:
        """Verifica si el usuario es estudiante"""
        from src.core.enums import UserType as UserTypeEnum

        return self.user_type.user_type == UserTypeEnum.STUDENT.value

    @property
    def is_admin(self) -> bool:
        """Verifica si el usuario es administrador"""
        from src.core.enums import UserType as UserTypeEnum

        return self.user_type.user_type == UserTypeEnum.ADMINISTRATOR.value
