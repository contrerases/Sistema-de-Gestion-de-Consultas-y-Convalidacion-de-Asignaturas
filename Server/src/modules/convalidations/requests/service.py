"""
Servicio de Requests
Sistema: SGSCT
"""
from typing import Dict, Optional
from sqlalchemy.orm import Session
from src.modules.convalidations.requests.repositories import RequestRepository
from src.modules.convalidations.requests.schemas import RequestCreate, RequestUpdateState, RequestResponse
from src.modules.convalidations.constants import MSG_REQUEST_NOT_FOUND, MSG_REQUEST_HAS_CONVALIDATIONS
from src.core.exceptions import NotFoundException, ValidationException
from src.monitoring.logging import get_logger

logger = get_logger(__name__)


class RequestService:
    """Servicio para gestión de solicitudes de convalidación"""
    
    def __init__(self, db: Session):
        self.db = db
        self.repository = RequestRepository(db)
    
    def get_all(self, page: int = 1, page_size: int = 20, state_id: Optional[int] = None, student_id: Optional[int] = None) -> Dict:
        """Obtiene todas las solicitudes paginadas con filtros"""
        skip = (page - 1) * page_size
        requests_db = self.repository.get_all(skip=skip, limit=page_size, state_id=state_id, student_id=student_id)
        total = self.repository.count(state_id=state_id, student_id=student_id)
        
        return {
            "items": [RequestResponse.model_validate(r) for r in requests_db],
            "page": page,
            "page_size": page_size,
            "total": total
        }
    
    def get_by_id(self, request_id: int) -> RequestResponse:
        """Obtiene una solicitud por ID"""
        request = self.repository.get_by_id(request_id)
        if not request:
            raise NotFoundException(MSG_REQUEST_NOT_FOUND)
        
        return RequestResponse.model_validate(request)
    
    def get_by_student(self, student_id: int, page: int = 1, page_size: int = 20) -> Dict:
        """Obtiene solicitudes de un estudiante"""
        skip = (page - 1) * page_size
        requests_db = self.repository.get_by_student(student_id, skip=skip, limit=page_size)
        total = self.repository.count(student_id=student_id)
        
        return {
            "items": [RequestResponse.model_validate(r) for r in requests_db],
            "page": page,
            "page_size": page_size,
            "total": total
        }
    
    def create(self, data: RequestCreate) -> RequestResponse:
        """Crea una nueva solicitud"""
        logger.info(f"Creando solicitud para estudiante {data.id_student}")
        
        request = self.repository.create(
            student_id=data.id_student,
            state_id=data.id_request_state
        )
        
        logger.info(f"Solicitud creada con ID {request.id}")
        return RequestResponse.model_validate(request)
    
    def update_state(self, request_id: int, data: RequestUpdateState) -> RequestResponse:
        """Actualiza el estado de una solicitud"""
        existing = self.repository.get_by_id(request_id)
        if not existing:
            raise NotFoundException(MSG_REQUEST_NOT_FOUND)
        
        logger.info(f"Actualizando estado de solicitud {request_id}")
        
        request = self.repository.update_state(request_id, data.id_request_state)
        return RequestResponse.model_validate(request)
    
    def delete(self, request_id: int) -> None:
        """Elimina una solicitud"""
        existing = self.repository.get_by_id(request_id)
        if not existing:
            raise NotFoundException(MSG_REQUEST_NOT_FOUND)
        
        # Validar que no tenga convalidaciones asociadas
        if existing.convalidations:
            raise ValidationException(MSG_REQUEST_HAS_CONVALIDATIONS)
        
        logger.info(f"Eliminando solicitud {request_id}")
        self.repository.delete(request_id)
