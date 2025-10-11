"""
Servicio de Convalidations
Sistema: SGSCT
"""
from typing import List, Optional
from sqlalchemy.orm import Session
from src.modules.convalidations.repositories import ConvalidationRepository
from src.modules.convalidations.schemas import (
    ConvalidationSubjectCreate,
    ConvalidationWorkshopCreate,
    ConvalidationExternalActivityCreate,
    ConvalidationUpdate,
    ConvalidationApprove,
    ConvalidationReject
)
from src.modules.convalidations.constants import (
    MSG_REQUIRES_REQUEST,
    MSG_SLOT_ALREADY_CONVALIDATED,
    MSG_FILE_REQUIRED_EXTERNAL,
    MSG_CONVALIDATION_NOT_FOUND,
    MSG_CONVALIDATION_CREATED,
    MSG_CONVALIDATION_UPDATED,
    MSG_CONVALIDATION_APPROVED,
    MSG_CONVALIDATION_REJECTED,
    MSG_CONVALIDATION_DELETED
)
from src.core.exceptions import NotFoundException, ValidationException
from src.monitoring.logging import get_logger

logger = get_logger(__name__)


class ConvalidationService:
    """Servicio con lógica de negocio de convalidaciones"""
    
    def __init__(self, db: Session):
        self.repository = ConvalidationRepository(db)
    
    # ========================================================================
    # READ OPERATIONS
    # ========================================================================
    
    def get_all(
        self,
        page: int = 1,
        page_size: int = 50,
        state_id: Optional[int] = None,
        type_id: Optional[int] = None,
        request_id: Optional[int] = None
    ):
        """Obtiene todas las convalidaciones con paginación"""
        skip = (page - 1) * page_size
        convalidations = self.repository.get_all(
            skip=skip,
            limit=page_size,
            state_id=state_id,
            type_id=type_id,
            request_id=request_id
        )
        total = self.repository.count(
            state_id=state_id,
            type_id=type_id,
            request_id=request_id
        )
        
        logger.info(f"Retrieved {len(convalidations)} convalidations (page {page})")
        return {
            "items": convalidations,
            "total": total,
            "page": page,
            "page_size": page_size
        }
    
    def get_by_id(self, convalidation_id: int):
        """Obtiene una convalidación por ID"""
        convalidation = self.repository.get_by_id(convalidation_id)
        if not convalidation:
            raise NotFoundException(MSG_CONVALIDATION_NOT_FOUND)
        return convalidation
    
    def get_by_request(self, request_id: int):
        """Obtiene convalidaciones de una solicitud"""
        convalidations = self.repository.get_by_request(request_id)
        logger.info(f"Retrieved {len(convalidations)} convalidations for request {request_id}")
        return convalidations
    
    # ========================================================================
    # CREATE OPERATIONS - WITH VALIDATION
    # ========================================================================
    
    def create_subject(self, data: ConvalidationSubjectCreate):
        """Crea una convalidación de asignatura"""
        # Validar que existe la solicitud (FK validation en DB)
        
        # Validar que el slot no esté ya convalidado
        if data.id_curriculum_course:
            self._validate_slot_not_convalidated(
                data.id_request,
                data.id_curriculum_course
            )
        
        convalidation = self.repository.create_subject(
            request_id=data.id_request,
            state_id=data.id_convalidation_state,
            subject_id=data.id_subject,
            curriculum_course_id=data.id_curriculum_course,
            review_comments=data.review_comments
        )
        
        logger.info(f"Created subject convalidation: {convalidation.id}")
        return convalidation
    
    def create_workshop(self, data: ConvalidationWorkshopCreate):
        """Crea una convalidación de taller"""
        # Validar que el slot no esté ya convalidado
        if data.id_curriculum_course:
            self._validate_slot_not_convalidated(
                data.id_request,
                data.id_curriculum_course
            )
        
        convalidation = self.repository.create_workshop(
            request_id=data.id_request,
            state_id=data.id_convalidation_state,
            workshop_id=data.id_workshop,
            curriculum_course_id=data.id_curriculum_course,
            workshop_grade=data.workshop_grade,
            review_comments=data.review_comments
        )
        
        logger.info(f"Created workshop convalidation: {convalidation.id}")
        return convalidation
    
    def create_external_activity(
        self,
        data: ConvalidationExternalActivityCreate,
        file_path: Optional[str] = None
    ):
        """Crea una convalidación de actividad externa"""
        # Validar que se subió un archivo (requerido)
        if not file_path:
            raise ValidationException(MSG_FILE_REQUIRED_EXTERNAL)
        
        # Validar que el slot no esté ya convalidado
        if data.id_curriculum_course:
            self._validate_slot_not_convalidated(
                data.id_request,
                data.id_curriculum_course
            )
        
        convalidation = self.repository.create_external_activity(
            request_id=data.id_request,
            state_id=data.id_convalidation_state,
            activity_name=data.activity_name,
            curriculum_course_id=data.id_curriculum_course,
            institution_name=data.institution_name,
            description=data.description,
            file_path=file_path,
            review_comments=data.review_comments
        )
        
        logger.info(f"Created external activity convalidation: {convalidation.id}")
        return convalidation
    
    # ========================================================================
    # UPDATE OPERATIONS
    # ========================================================================
    
    def update(self, convalidation_id: int, data: ConvalidationUpdate):
        """Actualiza una convalidación"""
        convalidation = self.repository.update(
            convalidation_id=convalidation_id,
            state_id=data.id_convalidation_state,
            review_comments=data.review_comments
        )
        
        if not convalidation:
            raise NotFoundException(MSG_CONVALIDATION_NOT_FOUND)
        
        logger.info(f"Updated convalidation: {convalidation_id}")
        return convalidation
    
    def approve(self, convalidation_id: int, data: ConvalidationApprove):
        """Aprueba una convalidación"""
        convalidation = self.repository.approve(
            convalidation_id=convalidation_id,
            approved_by=data.approved_by,
            review_comments=data.review_comments
        )
        
        if not convalidation:
            raise NotFoundException(MSG_CONVALIDATION_NOT_FOUND)
        
        logger.info(f"Approved convalidation: {convalidation_id} by user {data.approved_by}")
        return convalidation
    
    def reject(self, convalidation_id: int, data: ConvalidationReject):
        """Rechaza una convalidación"""
        convalidation = self.repository.reject(
            convalidation_id=convalidation_id,
            reason=data.reason
        )
        
        if not convalidation:
            raise NotFoundException(MSG_CONVALIDATION_NOT_FOUND)
        
        logger.info(f"Rejected convalidation: {convalidation_id}")
        return convalidation
    
    # ========================================================================
    # DELETE OPERATIONS
    # ========================================================================
    
    def delete(self, convalidation_id: int):
        """Elimina una convalidación"""
        success = self.repository.delete(convalidation_id)
        if not success:
            raise NotFoundException(MSG_CONVALIDATION_NOT_FOUND)
        
        logger.info(f"Deleted convalidation: {convalidation_id}")
        return {"message": MSG_CONVALIDATION_DELETED}
    
    # ========================================================================
    # PRIVATE VALIDATION METHODS
    # ========================================================================
    
    def _validate_slot_not_convalidated(self, request_id: int, slot_id: int):
        """Valida que el estudiante no haya convalidado ya el slot"""
        from src.modules.convalidations.requests.models import Request
        
        # Obtener id_student desde request_id
        request = self.repository.db.query(Request).filter(Request.id == request_id).first()
        if not request:
            raise NotFoundException(MSG_REQUIRES_REQUEST)
        
        # Verificar si ya existe convalidación para este slot
        existing = self.repository.check_slot_convalidated(request.id_student, slot_id)
        if existing:
            # Solo lanzar excepción si la convalidación está aprobada o en trámite
            if existing.id_convalidation_state in [3, 4, 6, 7]:  # PENDIENTE, EN_REVISION, APROBADA_DE, APROBADA_DC
                raise ValidationException(MSG_SLOT_ALREADY_CONVALIDATED)
