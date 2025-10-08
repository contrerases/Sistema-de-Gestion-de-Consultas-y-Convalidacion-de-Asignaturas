"""
Modelos ORM de autenticación
Sistema: SGSCT
"""
from sqlalchemy import Column, Integer, String, ForeignKey
from sqlalchemy.orm import relationship
from src.database.base import Base
from src.core.constants import DBLength


class AuthUser(Base):
    """
    Modelo AUTH_USERS - Credenciales de autenticación
    """
    __tablename__ = "AUTH_USERS"
    
    id = Column(Integer, primary_key=True, autoincrement=True)
    email = Column(String(DBLength.EMAIL), nullable=False, unique=True, index=True)
    password_hash = Column(String(DBLength.PASSWORD_HASH), nullable=False)
    salt = Column(String(DBLength.SALT), nullable=False)
    
    # Relación 1:1 con User
    user = relationship("User", back_populates="auth_user", uselist=False, cascade="all, delete-orphan")
    
    def __repr__(self):
        return f"<AuthUser(id={self.id}, email='{self.email}')>"


class User(Base):
    """
    Modelo USERS - Información del usuario
    """
    __tablename__ = "USERS"
    
    id = Column(Integer, ForeignKey("AUTH_USERS.id", ondelete="CASCADE", onupdate="CASCADE"), primary_key=True)
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
