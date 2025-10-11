"""
Repositorio del submódulo Administrators
Sistema: SGSCT
"""
from typing import List, Optional
from sqlalchemy.orm import Session, joinedload
from src.modules.users.models import User
from src.modules.users.constants import TYPE_ADMINISTRATOR


class AdministratorRepository:
    """Repositorio para operaciones CRUD de administradores"""
    
    def __init__(self, db: Session):
        self.db = db
    
    def get_all(
        self,
        skip: int = 0,
        limit: int = 100,
        campus_id: Optional[int] = None
    ) -> List[User]:
        """Obtiene todos los administradores con filtros"""
        query = self.db.query(User).options(
            joinedload(User.auth_user),
            joinedload(User.campus),
            joinedload(User.user_type)
        ).filter(User.id_user_type == TYPE_ADMINISTRATOR)
        
        if campus_id:
            query = query.filter(User.id_campus == campus_id)
        
        return query.order_by(User.full_name.asc()).offset(skip).limit(limit).all()
    
    def get_by_id(self, admin_id: int) -> Optional[User]:
        """Obtiene un administrador por ID"""
        return (
            self.db.query(User)
            .options(
                joinedload(User.auth_user),
                joinedload(User.campus),
                joinedload(User.user_type)
            )
            .filter(User.id == admin_id, User.id_user_type == TYPE_ADMINISTRATOR)
            .first()
        )
    
    def count(self, campus_id: Optional[int] = None) -> int:
        """Cuenta el total de administradores"""
        query = self.db.query(User).filter(User.id_user_type == TYPE_ADMINISTRATOR)
        
        if campus_id:
            query = query.filter(User.id_campus == campus_id)
        
        return query.count()
    
    def create(self, user: User) -> User:
        """Crea un nuevo administrador"""
        self.db.add(user)
        self.db.commit()
        self.db.refresh(user)
        return user
    
    def update(self, user: User) -> User:
        """Actualiza un administrador"""
        self.db.commit()
        self.db.refresh(user)
        return user
    
    def delete(self, user: User) -> None:
        """Elimina un administrador"""
        self.db.delete(user)
        self.db.commit()
