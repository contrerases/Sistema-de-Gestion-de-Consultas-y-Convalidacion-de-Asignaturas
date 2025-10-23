"""
Modelos ORM de autenticación
Sistema: SGSCT

NOTA: Solo contiene el modelo AuthUser (credenciales).
El modelo User está en src/modules/users/models.py
"""

from sqlalchemy import Column, Integer, String
from sqlalchemy.orm import relationship
from src.database.base import Base
from src.database.constants import Tables


class AuthUser(Base):

    # Relación 1:1 con User (evita import directo para no crear ciclo)
    user = relationship("User", back_populates="auth_user", uselist=False)
    """
    Modelo AUTH_USERS - Credenciales de autenticación
    Solo almacena email y password_hash para login
    """

    __tablename__ = Tables.AUTH_USERS

    id = Column(Integer, primary_key=True, autoincrement=True)
    email = Column(String(255), nullable=False, unique=True, index=True)
    password_hash = Column(String(255), nullable=False)

    

    def __repr__(self):
        return f"<AuthUser(id={self.id}, email='{self.email}')>"
