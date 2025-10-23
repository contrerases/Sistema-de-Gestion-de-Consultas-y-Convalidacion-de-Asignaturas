"""
Servicio de lógica de negocio para CAMPUS
Sistema: SGSCT
"""

from typing import Dict, Any
from fastapi import HTTPException
from sqlalchemy.orm import Session
from src.modules.academic.campus.schemas import (
    CampusResponse,
    CampusCreate,
    CampusUpdate,
)
from src.modules.academic.campus.repository import CampusRepository
from src.monitoring.logging import get_logger

logger = get_logger(__name__)


class CampusServices:
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
            "items": [self.to_response(campus) for campus in campus_list],
            "page": page,
            "page_size": page_size,
            "total": total,
        }

    def get_by_id(self, campus_id: int) -> CampusResponse:
        """Obtiene un campus por ID"""
        campus = self.repository.get_by_id(campus_id)

        if not campus:
            raise HTTPException(
                status_code=404, detail=f"Campus con ID {campus_id} no encontrado"
            )

        return CampusResponse.model_validate(campus)

    def create(self, data: CampusCreate) -> CampusResponse:
        """Crea un nuevo campus"""
        existing = self.repository.get_by_acronym(data.acronym)
        if existing:
            raise HTTPException(
                status_code=400, detail="Ya existe un campus con ese acrónimo"
            )

        campus = self.repository.create(
            acronym=data.acronym, name=data.name, location=data.location
        )
        return CampusResponse.model_validate(campus)

    def update(self, campus_id: int, data: CampusUpdate) -> CampusResponse:
        """Actualiza un campus"""
        campus = self.repository.get_by_id(campus_id)
        if not campus:
            raise HTTPException(
                status_code=404, detail=f"Campus con ID {campus_id} no encontrado"
            )

        campus_check = self.repository.get_by_acronym(data.acronym)
        if campus_check and getattr(campus_check, "id", None) != campus_id:
            raise HTTPException(
                status_code=400, detail="Ya existe otro campus con ese acrónimo"
            )

        campus = self.repository.update(
            campus_id, data.acronym, data.name, data.location
        )
        return CampusResponse.model_validate(campus)

    def delete(self, campus_id: int) -> None:
        """Elimina un campus"""
        existing = self.repository.get_by_id(campus_id)
        if not existing:
            raise HTTPException(
                status_code=404, detail=f"Campus con ID {campus_id} no encontrado"
            )

        success = self.repository.delete(campus_id)
        if not success:
            raise HTTPException(status_code=400, detail="No se pudo eliminar el campus")

    def to_response(self, campus: Any) -> CampusResponse:
        """Convierte un modelo Campus a CampusResponse"""
        return CampusResponse(
            id=campus.id,
            acronym=campus.acronym,
            name=campus.name,
            location=campus.location,
        )
