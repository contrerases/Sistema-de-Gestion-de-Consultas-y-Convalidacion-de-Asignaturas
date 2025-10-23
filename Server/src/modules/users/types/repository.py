"""
Repositorio para USER_TYPES
"""

from sqlalchemy.orm import Session
from .models import UserType
from typing import List, Optional


class UserTypeRepository:
    def __init__(self, db: Session):
        self.db = db

    def get_all(self, skip: int = 0, limit: int = 100) -> List[UserType]:
        return self.db.query(UserType).offset(skip).limit(limit).all()

    def get_by_id(self, type_id: int) -> Optional[UserType]:
        return self.db.query(UserType).filter(UserType.id == type_id).first()

    def create(self, user_type: str) -> UserType:
        obj = UserType(user_type=user_type)
        self.db.add(obj)
        self.db.commit()
        self.db.refresh(obj)
        return obj

    def update(self, type_id: int, user_type: str) -> Optional[UserType]:
        obj = self.get_by_id(type_id)
        if obj:
            obj.user_type = user_type
            self.db.commit()
            self.db.refresh(obj)
        return obj

    def delete(self, type_id: int) -> bool:
        obj = self.get_by_id(type_id)
        if obj:
            self.db.delete(obj)
            self.db.commit()
            return True
        return False
