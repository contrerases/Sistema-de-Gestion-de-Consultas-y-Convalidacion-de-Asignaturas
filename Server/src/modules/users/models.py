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
from src.database.tables import Tables
from src.core.constants import DBLength


class User(Base):
    """
    Modelo USERS - Información del usuario
    Vinculado a AuthUser (auth/models.py) mediante relación 1:1
    """
    __tablename__ = Tables.USERS
    
    id = Column(Integer, ForeignKey(f"{Tables.AUTH_USERS}.id", ondelete="CASCADE", onupdate="CASCADE"), primary_key=True)
    full_name = Column(String(DBLength.FULL_NAME), nullable=False)
    id_campus = Column(Integer, ForeignKey("CAMPUS.id", ondelete="RESTRICT", onupdate="CASCADE"), nullable=False)
    id_user_type = Column(Integer, ForeignKey("USER_TYPES.id", ondelete="RESTRICT", onupdate="CASCADE"), nullable=False)
    rol_student = Column(String(DBLength.ROL), nullable=True)
    rut_student = Column(String(DBLength.RUT), nullable=True)
    
    # Relaciones
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


class Professor(Base):
    """
    Modelo PROFESSORS - Profesores de talleres
    Tabla independiente, no vinculada a AUTH_USERS
    """
    __tablename__ = Tables.PROFESSORS
    
    id = Column(Integer, primary_key=True, autoincrement=True)
    name = Column(String(DBLength.FULL_NAME), nullable=False)
    email = Column(String(DBLength.EMAIL), nullable=False, unique=True, index=True)
    
    def __repr__(self):
        return f"<Professor(id={self.id}, name='{self.name}')>"
