"""
Repositorio para USER_TYPES
Sistema: SGSCT
"""
from typing import Optional, List
from sqlalchemy.orm import Session
from src.modules.catalog.user_types.models import UserType


class UserTypeRepository:
    """Repositorio para operaciones CRUD de tipos de usuario"""
    
    def __init__(self, db: Session):
        self.db = db
    
    def get_all(self, skip: int = 0, limit: int = 100) -> List[UserType]:
        """Obtiene todos los tipos de usuario con paginación"""
        return self.db.query(UserType).order_by(UserType.id.asc()).offset(skip).limit(limit).all()
    
    def get_by_id(self, user_type_id: int) -> Optional[UserType]:
        """Obtiene un tipo de usuario por ID"""
        return self.db.query(UserType).filter(UserType.id == user_type_id).first()
    
    def get_by_type(self, user_type: str) -> Optional[UserType]:
        """Obtiene un tipo de usuario por nombre"""
        return self.db.query(UserType).filter(UserType.user_type == user_type).first()
    
    def create(self, user_type: str) -> UserType:
        """Crea un nuevo tipo de usuario"""
        new_type = UserType(user_type=user_type)
        self.db.add(new_type)
        self.db.commit()
        self.db.refresh(new_type)
        return new_type
    
    def update(self, user_type_id: int, user_type: str) -> Optional[UserType]:
        """Actualiza un tipo de usuario"""
        type_obj = self.get_by_id(user_type_id)
        if type_obj:
            type_obj.user_type = user_type
            self.db.commit()
            self.db.refresh(type_obj)
        return type_obj
    
    def delete(self, user_type_id: int) -> bool:
        """Elimina un tipo de usuario"""
        type_obj = self.get_by_id(user_type_id)
        if type_obj:
            self.db.delete(type_obj)
            self.db.commit()
            return True
        return False
    
    def count(self) -> int:
        """Cuenta total de tipos de usuario"""
        return self.db.query(UserType).count()
