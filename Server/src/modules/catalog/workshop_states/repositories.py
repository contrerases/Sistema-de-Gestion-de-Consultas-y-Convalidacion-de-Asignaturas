"""
Repositorio para WORKSHOP_STATES
Sistema: SGSCT
"""
from typing import List, Optional
from sqlalchemy.orm import Session
from src.modules.catalog.workshop_states.models import WorkshopState
from src.database.repository import BaseRepository


class WorkshopStateRepository(BaseRepository[WorkshopState]):
    
    def __init__(self, db: Session):
        super().__init__(WorkshopState, db)
    
    def get_all(self, skip: int = 0, limit: int = 100) -> List[WorkshopState]:
        return self.db.query(self.model).offset(skip).limit(limit).all()
    
    def get_by_id(self, state_id: int) -> Optional[WorkshopState]:
        return self.db.query(self.model).filter(self.model.id == state_id).first()
    
    def get_by_state(self, state_name: str) -> Optional[WorkshopState]:
        return self.db.query(self.model).filter(
            self.model.workshop_state == state_name
        ).first()
    
    def create(self, workshop_state: WorkshopState) -> WorkshopState:
        self.db.add(workshop_state)
        self.db.commit()
        self.db.refresh(workshop_state)
        return workshop_state
    
    def update(self, workshop_state: WorkshopState) -> WorkshopState:
        self.db.commit()
        self.db.refresh(workshop_state)
        return workshop_state
    
    def delete(self, workshop_state: WorkshopState) -> None:
        self.db.delete(workshop_state)
        self.db.commit()
    
    def count(self) -> int:
        return self.db.query(self.model).count()
