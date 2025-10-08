"""
Modelo UserType
Sistema: SGSCT
"""
from sqlalchemy import Column, Integer, String
from src.database.base import Base


class UserType(Base):
    """Modelo USER_TYPES - Tipos de usuario del sistema"""
    __tablename__ = "USER_TYPES"
    
    id = Column(Integer, primary_key=True, autoincrement=True)
    user_type = Column(String(50), nullable=False, unique=True, index=True)
    
    def __repr__(self):
        return f"<UserType(id={self.id}, type='{self.user_type}')>"
