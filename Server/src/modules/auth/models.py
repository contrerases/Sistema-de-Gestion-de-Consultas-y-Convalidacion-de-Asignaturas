"""
Modelos ORM de autenticación
Sistema: SGSCT

NOTA: Solo contiene el modelo AuthUser (credenciales).
El modelo User está en src/modules/users/models.py
"""
from sqlalchemy import Column, Integer, String
from sqlalchemy.orm import relationship
from src.database.base import Base
from src.database.tables import Tables
from src.core.constants import DBLength


class AuthUser(Base):
    """
    Modelo AUTH_USERS - Credenciales de autenticación
    Solo almacena email y password_hash para login
    """
    __tablename__ = Tables.AUTH_USERS
    
    id = Column(Integer, primary_key=True, autoincrement=True)
    email = Column(String(DBLength.EMAIL), nullable=False, unique=True, index=True)
    password_hash = Column(String(DBLength.PASSWORD_HASH), nullable=False)
    
    # Relación 1:1 con User (definido en users/models.py)
    user = relationship("User", back_populates="auth_user", uselist=False, cascade="all, delete-orphan")
    
    def __repr__(self):
        return f"<AuthUser(id={self.id}, email='{self.email}')>"
