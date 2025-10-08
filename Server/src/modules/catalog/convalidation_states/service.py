"""
Lógica de negocio para CONVALIDATION_STATES
Sistema: SGSCT
"""
import logging
from typing import Dict, List
from sqlalchemy.orm import Session
from src.modules.catalog.convalidation_states.repositories import ConvalidationStateRepository
from src.modules.catalog.convalidation_states.schemas import (
    ConvalidationStateCreate, 
    ConvalidationStateUpdate, 
    ConvalidationStateResponse
)

logger = logging.getLogger(__name__)
from src.modules.catalog.convalidation_states.models import ConvalidationState
from src.core.exceptions import NotFoundException, ValidationException


class ConvalidationStateService:
    
    def __init__(self, db: Session):
        self.repository = ConvalidationStateRepository(db)
    
    def get_all(self, page: int = 1, page_size: int = 20) -> Dict:
        skip = (page - 1) * page_size
        states_db = self.repository.get_all(skip=skip, limit=page_size)
        total = self.repository.count()
        
        return {
            "items": [ConvalidationStateResponse.model_validate(s) for s in states_db],
            "page": page,
            "page_size": page_size,
            "total": total
        }
    
    def get_by_id(self, state_id: int) -> ConvalidationStateResponse:
        state_db = self.repository.get_by_id(state_id)
        if not state_db:
            raise NotFoundException(f"Estado de convalidación con ID {state_id} no encontrado")
        
        return ConvalidationStateResponse.model_validate(state_db)
    
    def create(self, data: ConvalidationStateCreate) -> ConvalidationStateResponse:
        existing = self.repository.get_by_state(data.convalidation_state)
        if existing:
            raise ValidationException(
                f"Ya existe un estado de convalidación con el nombre '{data.convalidation_state}'"
            )
        
        new_state = ConvalidationState(**data.model_dump())
        created = self.repository.create(new_state)
        
        return ConvalidationStateResponse.model_validate(created)
    
    def update(self, state_id: int, data: ConvalidationStateUpdate) -> ConvalidationStateResponse:
        state_db = self.repository.get_by_id(state_id)
        if not state_db:
            raise NotFoundException(f"Estado de convalidación con ID {state_id} no encontrado")
        
        if data.convalidation_state:
            existing = self.repository.get_by_state(data.convalidation_state)
            if existing and existing.id != state_id:
                raise ValidationException(
                    f"Ya existe otro estado de convalidación con el nombre '{data.convalidation_state}'"
                )
            state_db.convalidation_state = data.convalidation_state
        
        if data.description is not None:
            state_db.description = data.description
        
        updated = self.repository.update(state_db)
        
        return ConvalidationStateResponse.model_validate(updated)
    
    def delete(self, state_id: int) -> None:
        state_db = self.repository.get_by_id(state_id)
        if not state_db:
            raise NotFoundException(f"Estado de convalidación con ID {state_id} no encontrado")
        
        self.repository.delete(state_db)
