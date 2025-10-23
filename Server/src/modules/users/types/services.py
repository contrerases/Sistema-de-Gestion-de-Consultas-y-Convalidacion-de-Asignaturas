"""
Servicio para USER_TYPES
"""

from sqlalchemy.orm import Session
from fastapi import HTTPException
from .models import UserType
from .schemas import UserTypeCreate, UserTypeUpdate, UserTypeResponse
from typing import Dict, Any


class UserTypeServices:
    def __init__(self, db: Session):
        self.db = db

    def get_all(self, page: int = 1, page_size: int = 10) -> Dict[str, Any]:
        total = self.db.query(UserType).count()
        items = (
            self.db.query(UserType)
            .offset((page - 1) * page_size)
            .limit(page_size)
            .all()
        )
        return {
            "total": total,
            "items": [self.to_response(item) for item in items],
            "page": page,
            "page_size": page_size,
        }

    def get_by_id(self, type_id: int) -> UserType:
        user_type = self.db.query(UserType).filter(UserType.id == type_id).first()
        if not user_type:
            raise HTTPException(status_code=404, detail="Tipo de usuario no encontrado")
        return user_type

    def create(self, data: UserTypeCreate) -> UserType:
        user_type = UserType(user_type=data.name)
        self.db.add(user_type)
        self.db.commit()
        self.db.refresh(user_type)
        return user_type

    def update(self, type_id: int, data: UserTypeUpdate) -> UserType:
        user_type = self.get_by_id(type_id)
        setattr(user_type, "name", data.name)
        self.db.commit()
        self.db.refresh(user_type)
        return user_type

    def delete(self, type_id: int) -> None:
        user_type = self.get_by_id(type_id)
        self.db.delete(user_type)
        self.db.commit()

    def to_response(self, user_type: UserType) -> UserTypeResponse:
        return UserTypeResponse(
            id=getattr(user_type, "id"),
            name=getattr(user_type, "name"),
        )
