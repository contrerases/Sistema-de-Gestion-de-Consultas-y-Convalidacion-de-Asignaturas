"""
Repositorio para CONVALIDATION_TYPES
Sistema: SGSCT
"""
from typing import List, Optional
from sqlalchemy.orm import Session
from src.modules.catalog.convalidation_types.models import ConvalidationType
from src.database.repository import BaseRepository


class ConvalidationTypeRepository(BaseRepository[ConvalidationType]):
    
    def __init__(self, db: Session):
        super().__init__(ConvalidationType, db)
    
    def get_all(self, skip: int = 0, limit: int = 100) -> List[ConvalidationType]:
        return self.db.query(self.model).order_by(self.model.id.asc()).offset(skip).limit(limit).all()
    
    def get_by_id(self, type_id: int) -> Optional[ConvalidationType]:
        return self.db.query(self.model).filter(self.model.id == type_id).first()
    
    def get_by_type(self, type_name: str) -> Optional[ConvalidationType]:
        return self.db.query(self.model).filter(
            self.model.convalidation_type == type_name
        ).first()
    
    def create(self, convalidation_type: ConvalidationType) -> ConvalidationType:
        self.db.add(convalidation_type)
        self.db.commit()
        self.db.refresh(convalidation_type)
        return convalidation_type
    
    def update(self, convalidation_type: ConvalidationType) -> ConvalidationType:
        self.db.commit()
        self.db.refresh(convalidation_type)
        return convalidation_type
    
    def delete(self, convalidation_type: ConvalidationType) -> None:
        self.db.delete(convalidation_type)
        self.db.commit()
    
    def count(self) -> int:
        return self.db.query(self.model).count()
