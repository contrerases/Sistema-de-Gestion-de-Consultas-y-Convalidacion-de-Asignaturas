"""
Servicio de lógica de negocio para CAMPUS
Sistema: SGSCT
"""
import logging
from typing import Dict, Any
from sqlalchemy.orm import Session
from src.modules.catalog.campus.repositories import CampusRepository
from src.modules.catalog.campus.schemas import CampusCreate, CampusUpdate, CampusResponse
from src.core.exceptions import NotFoundException, ValidationException

logger = logging.getLogger(__name__)


class CampusService:
    """Servicio para gestión de campus"""
    
    def __init__(self, db: Session):
        self.db = db
        self.repository = CampusRepository(db)
    
    def get_all(self, page: int = 1, page_size: int = 20) -> Dict[str, Any]:
        """Obtiene todos los campus paginados"""
        skip = (page - 1) * page_size
        campus_list = self.repository.get_all(skip=skip, limit=page_size)
        total = self.repository.count()
        
        return {
            "items": [CampusResponse.model_validate(campus) for campus in campus_list],
            "page": page,
            "page_size": page_size,
            "total": total
        }
    
    def get_by_id(self, campus_id: int) -> CampusResponse:
        """Obtiene un campus por ID"""
        campus = self.repository.get_by_id(campus_id)
        
        if not campus:
            raise NotFoundException(f"Campus con ID {campus_id} no encontrado")
        
        return CampusResponse.model_validate(campus)
    
    def create(self, data: CampusCreate) -> CampusResponse:
        """Crea un nuevo campus"""
        existing = self.repository.get_by_acronym(data.acronym)
        if existing:
            raise ValidationException(
                message="Ya existe un campus con ese acrónimo",
                details=[{"field": "acronym", "message": "Acrónimo duplicado"}]
            )
        
        campus = self.repository.create(
            acronym=data.acronym,
            name=data.name,
            location=data.location
        )
        return CampusResponse.model_validate(campus)
    
    def update(self, campus_id: int, data: CampusUpdate) -> CampusResponse:
        """Actualiza un campus"""
        existing = self.repository.get_by_id(campus_id)
        if not existing:
            raise NotFoundException(f"Campus con ID {campus_id} no encontrado")
        
        acronym_check = self.repository.get_by_acronym(data.acronym)
        if acronym_check and acronym_check.id != campus_id:
            raise ValidationException(
                message="Ya existe otro campus con ese acrónimo",
                details=[{"field": "acronym", "message": "Acrónimo duplicado"}]
            )
        
        campus = self.repository.update(campus_id, data.acronym, data.name, data.location)
        return CampusResponse.model_validate(campus)
    
    def delete(self, campus_id: int) -> None:
        """Elimina un campus"""
        existing = self.repository.get_by_id(campus_id)
        if not existing:
            raise NotFoundException(f"Campus con ID {campus_id} no encontrado")
        
        success = self.repository.delete(campus_id)
        if not success:
            raise ValidationException("No se pudo eliminar el campus")
