"""
Repositorio para CONVALIDATION_STATES
Sistema: SGSCT
"""
from typing import List, Optional
from sqlalchemy.orm import Session
from src.modules.catalog.convalidation_states.models import ConvalidationState
from src.database.repository import BaseRepository


class ConvalidationStateRepository(BaseRepository[ConvalidationState]):
    
    def __init__(self, db: Session):
        super().__init__(ConvalidationState, db)
    
    def get_all(self, skip: int = 0, limit: int = 100) -> List[ConvalidationState]:
        return self.db.query(self.model).offset(skip).limit(limit).all()
    
    def get_by_id(self, state_id: int) -> Optional[ConvalidationState]:
        return self.db.query(self.model).filter(self.model.id == state_id).first()
    
    def get_by_state(self, state_name: str) -> Optional[ConvalidationState]:
        return self.db.query(self.model).filter(
            self.model.convalidation_state == state_name
        ).first()
    
    def create(self, convalidation_state: ConvalidationState) -> ConvalidationState:
        self.db.add(convalidation_state)
        self.db.commit()
        self.db.refresh(convalidation_state)
        return convalidation_state
    
    def update(self, convalidation_state: ConvalidationState) -> ConvalidationState:
        self.db.commit()
        self.db.refresh(convalidation_state)
        return convalidation_state
    
    def delete(self, convalidation_state: ConvalidationState) -> None:
        self.db.delete(convalidation_state)
        self.db.commit()
    
    def count(self) -> int:
        return self.db.query(self.model).count()
