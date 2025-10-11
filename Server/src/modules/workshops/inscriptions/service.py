"""
Servicio de Inscriptions
Sistema: SGSCT
"""
from typing import Dict, Optional
from sqlalchemy.orm import Session
from src.modules.workshops.inscriptions.repositories import InscriptionRepository
from src.modules.workshops.inscriptions.schemas import InscriptionCreate, InscriptionResponse
from src.modules.workshops.constants import CHECK_CAPACITY_BEFORE_INSCRIPTION, MSG_ALREADY_INSCRIBED, MSG_WORKSHOP_FULL
from src.core.exceptions import NotFoundException, ValidationException
from src.monitoring.logging import get_logger

logger = get_logger(__name__)


class InscriptionService:
    """Servicio para gestión de inscripciones"""
    
    def __init__(self, db: Session):
        self.db = db
        self.repository = InscriptionRepository(db)
    
    def get_all(self, page: int = 1, page_size: int = 20, workshop_id: Optional[int] = None, student_id: Optional[int] = None) -> Dict:
        """Obtiene todas las inscripciones con filtros"""
        skip = (page - 1) * page_size
        inscriptions_db = self.repository.get_all(skip=skip, limit=page_size, workshop_id=workshop_id, student_id=student_id)
        total = self.repository.count(workshop_id=workshop_id, student_id=student_id)
        
        return {
            "items": [InscriptionResponse.model_validate(i) for i in inscriptions_db],
            "page": page,
            "page_size": page_size,
            "total": total
        }
    
    def get_by_id(self, inscription_id: int) -> InscriptionResponse:
        """Obtiene una inscripción por ID"""
        inscription = self.repository.get_by_id(inscription_id)
        if not inscription:
            raise NotFoundException(f"Inscripción con ID {inscription_id} no encontrada")
        
        return InscriptionResponse.model_validate(inscription)
    
    def get_by_workshop(self, workshop_id: int, page: int = 1, page_size: int = 20) -> Dict:
        """Obtiene inscripciones de un taller"""
        skip = (page - 1) * page_size
        inscriptions_db = self.repository.get_by_workshop(workshop_id, skip=skip, limit=page_size)
        total = self.repository.count(workshop_id=workshop_id)
        
        return {
            "items": [InscriptionResponse.model_validate(i) for i in inscriptions_db],
            "page": page,
            "page_size": page_size,
            "total": total
        }
    
    def get_by_student(self, student_id: int, page: int = 1, page_size: int = 20) -> Dict:
        """Obtiene inscripciones de un estudiante"""
        skip = (page - 1) * page_size
        inscriptions_db = self.repository.get_by_student(student_id, skip=skip, limit=page_size)
        total = self.repository.count(student_id=student_id)
        
        return {
            "items": [InscriptionResponse.model_validate(i) for i in inscriptions_db],
            "page": page,
            "page_size": page_size,
            "total": total
        }
    
    def create(self, data: InscriptionCreate) -> InscriptionResponse:
        """Crea una nueva inscripción"""
        # Validar que no esté ya inscrito
        existing = self.repository.check_existing(data.id_student, data.id_workshop)
        if existing:
            raise ValidationException(MSG_ALREADY_INSCRIBED)
        
        # Validar capacidad del taller
        if CHECK_CAPACITY_BEFORE_INSCRIPTION:
            from src.modules.workshops.models import Workshop
            workshop = self.db.query(Workshop).filter(Workshop.id == data.id_workshop).first()
            if workshop:
                current_count = self.repository.count_by_workshop(data.id_workshop)
                if current_count >= workshop.max_students:
                    raise ValidationException(MSG_WORKSHOP_FULL)
        
        logger.info(f"Creando inscripción para estudiante {data.id_student} en taller {data.id_workshop}")
        
        inscription = self.repository.create(
            student_id=data.id_student,
            workshop_id=data.id_workshop,
            curriculum_course_id=data.id_curriculum_course
        )
        
        # Auto-crear REQUEST y CONVALIDATION si tiene slot
        if data.id_curriculum_course:
            logger.info(f"Inscripción con convalidación para slot {data.id_curriculum_course}")
            self._auto_create_convalidation(
                student_id=data.id_student,
                workshop_id=data.id_workshop,
                curriculum_course_id=data.id_curriculum_course
            )
        
        return InscriptionResponse.model_validate(inscription)
    
    def delete(self, inscription_id: int) -> None:
        """Elimina una inscripción"""
        existing = self.repository.get_by_id(inscription_id)
        if not existing:
            raise NotFoundException(f"Inscripción con ID {inscription_id} no encontrada")
        
        logger.info(f"Eliminando inscripción {inscription_id}")
        self.repository.delete(inscription_id)
    
    # ========================================================================
    # AUTO-CREATE CONVALIDATION LOGIC
    # ========================================================================
    
    def _auto_create_convalidation(
        self,
        student_id: int,
        workshop_id: int,
        curriculum_course_id: int
    ) -> None:
        """
        Auto-crea REQUEST y CONVALIDATION de taller cuando se inscribe con slot.
        Estados iniciales: REQUEST = EN_TRAMITE (1), CONVALIDATION = PENDIENTE_DE (3)
        """
        from src.modules.convalidations.requests.models import Request
        from src.modules.convalidations.models import Convalidation, ConvalidationWorkshop
        from datetime import datetime
        
        try:
            # 1. Crear REQUEST
            request = Request(
                id_student=student_id,
                id_request_state=1,  # EN_TRAMITE
                sent_at=datetime.now()
            )
            self.db.add(request)
            self.db.flush()  # Obtener ID del request
            
            logger.info(f"Auto-creado REQUEST {request.id} para estudiante {student_id}")
            
            # 2. Crear CONVALIDATION
            convalidation = Convalidation(
                id_request=request.id,
                id_convalidation_type=3,  # TALLER_DI
                id_convalidation_state=3,  # PENDIENTE_DE
                id_curriculum_course=curriculum_course_id,
                review_comments="Convalidación auto-generada por inscripción a taller"
            )
            self.db.add(convalidation)
            self.db.flush()  # Obtener ID de la convalidación
            
            logger.info(f"Auto-creada CONVALIDATION {convalidation.id} para taller {workshop_id}")
            
            # 3. Crear especialización CONVALIDATION_WORKSHOP
            convalidation_workshop = ConvalidationWorkshop(
                id_convalidation=convalidation.id,
                id_workshop=workshop_id,
                workshop_grade=None  # Se llenará cuando se califique
            )
            self.db.add(convalidation_workshop)
            self.db.commit()
            
            logger.info(f"Convalidación completa creada: REQUEST {request.id} -> CONVALIDATION {convalidation.id}")
            
        except Exception as e:
            self.db.rollback()
            logger.error(f"Error al auto-crear convalidación: {str(e)}")
            # No lanzar excepción para no bloquear la inscripción
            # La convalidación se podrá crear manualmente después
