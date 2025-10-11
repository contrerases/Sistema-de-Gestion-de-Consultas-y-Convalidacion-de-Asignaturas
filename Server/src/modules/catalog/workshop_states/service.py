"""
Lógica de negocio para WORKSHOP_STATES
Sistema: SGSCT
"""
from typing import Dict, List
from sqlalchemy.orm import Session
from src.modules.catalog.workshop_states.repositories import WorkshopStateRepository
from src.modules.catalog.workshop_states.schemas import (
    WorkshopStateCreate, 
    WorkshopStateUpdate, 
    WorkshopStateResponse
)
from src.modules.catalog.workshop_states.models import WorkshopState
from src.core.exceptions import NotFoundException, ValidationException
from src.monitoring.logging import get_logger

logger = get_logger(__name__)


class WorkshopStateService:
    
    def __init__(self, db: Session):
        self.repository = WorkshopStateRepository(db)
    
    def get_all(self, page: int = 1, page_size: int = 20) -> Dict:
        skip = (page - 1) * page_size
        states_db = self.repository.get_all(skip=skip, limit=page_size)
        total = self.repository.count()
        
        return {
            "items": [WorkshopStateResponse.model_validate(s) for s in states_db],
            "page": page,
            "page_size": page_size,
            "total": total
        }
    
    def get_by_id(self, state_id: int) -> WorkshopStateResponse:
        state_db = self.repository.get_by_id(state_id)
        if not state_db:
            raise NotFoundException(f"Estado de taller con ID {state_id} no encontrado")
        
        return WorkshopStateResponse.model_validate(state_db)
    
    def create(self, data: WorkshopStateCreate) -> WorkshopStateResponse:
        existing = self.repository.get_by_state(data.workshop_state)
        if existing:
            raise ValidationException(
                f"Ya existe un estado de taller con el nombre '{data.workshop_state}'"
            )
        
        new_state = WorkshopState(**data.model_dump())
        created = self.repository.create(new_state)
        
        return WorkshopStateResponse.model_validate(created)
    
    def update(self, state_id: int, data: WorkshopStateUpdate) -> WorkshopStateResponse:
        state_db = self.repository.get_by_id(state_id)
        if not state_db:
            raise NotFoundException(f"Estado de taller con ID {state_id} no encontrado")
        
        if data.workshop_state:
            existing = self.repository.get_by_state(data.workshop_state)
            if existing and existing.id != state_id:
                raise ValidationException(
                    f"Ya existe otro estado de taller con el nombre '{data.workshop_state}'"
                )
            state_db.workshop_state = data.workshop_state
        
        if data.description is not None:
            state_db.description = data.description
        
        updated = self.repository.update(state_db)
        
        return WorkshopStateResponse.model_validate(updated)
    
    def delete(self, state_id: int) -> None:
        state_db = self.repository.get_by_id(state_id)
        if not state_db:
            raise NotFoundException(f"Estado de taller con ID {state_id} no encontrado")
        
        self.repository.delete(state_db)
