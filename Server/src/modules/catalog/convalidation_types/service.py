"""
Lógica de negocio para CONVALIDATION_TYPES
Sistema: SGSCT
"""
import logging
from typing import Dict, List
from sqlalchemy.orm import Session
from src.modules.catalog.convalidation_types.repositories import ConvalidationTypeRepository
from src.modules.catalog.convalidation_types.schemas import (
    ConvalidationTypeCreate, 
    ConvalidationTypeUpdate, 
    ConvalidationTypeResponse
)

logger = logging.getLogger(__name__)
from src.modules.catalog.convalidation_types.models import ConvalidationType
from src.core.exceptions import NotFoundException, ValidationException


class ConvalidationTypeService:
    
    def __init__(self, db: Session):
        self.repository = ConvalidationTypeRepository(db)
    
    def get_all(self, page: int = 1, page_size: int = 20) -> Dict:
        skip = (page - 1) * page_size
        types_db = self.repository.get_all(skip=skip, limit=page_size)
        total = self.repository.count()
        
        return {
            "items": [ConvalidationTypeResponse.model_validate(t) for t in types_db],
            "page": page,
            "page_size": page_size,
            "total": total
        }
    
    def get_by_id(self, type_id: int) -> ConvalidationTypeResponse:
        type_db = self.repository.get_by_id(type_id)
        if not type_db:
            raise NotFoundException(f"Tipo de convalidación con ID {type_id} no encontrado")
        
        return ConvalidationTypeResponse.model_validate(type_db)
    
    def create(self, data: ConvalidationTypeCreate) -> ConvalidationTypeResponse:
        existing = self.repository.get_by_type(data.convalidation_type)
        if existing:
            raise ValidationException(
                f"Ya existe un tipo de convalidación con el nombre '{data.convalidation_type}'"
            )
        
        new_type = ConvalidationType(**data.model_dump())
        created = self.repository.create(new_type)
        
        return ConvalidationTypeResponse.model_validate(created)
    
    def update(self, type_id: int, data: ConvalidationTypeUpdate) -> ConvalidationTypeResponse:
        type_db = self.repository.get_by_id(type_id)
        if not type_db:
            raise NotFoundException(f"Tipo de convalidación con ID {type_id} no encontrado")
        
        if data.convalidation_type:
            existing = self.repository.get_by_type(data.convalidation_type)
            if existing and existing.id != type_id:
                raise ValidationException(
                    f"Ya existe otro tipo de convalidación con el nombre '{data.convalidation_type}'"
                )
            type_db.convalidation_type = data.convalidation_type
        
        updated = self.repository.update(type_db)
        
        return ConvalidationTypeResponse.model_validate(updated)
    
    def delete(self, type_id: int) -> None:
        type_db = self.repository.get_by_id(type_id)
        if not type_db:
            raise NotFoundException(f"Tipo de convalidación con ID {type_id} no encontrado")
        
        self.repository.delete(type_db)
