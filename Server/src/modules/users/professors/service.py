"""
Servicio del submódulo Professors
Sistema: SGSCT
"""
from typing import Dict
from sqlalchemy.orm import Session
from src.modules.users.professors.repositories import ProfessorRepository
from src.modules.users.professors.schemas import (
    ProfessorCreate,
    ProfessorUpdate,
    ProfessorResponse
)
from src.modules.users.models import Professor
from src.modules.users.constants import (
    MSG_PROFESSOR_NOT_FOUND,
    MSG_PROFESSOR_EMAIL_EXISTS,
    MSG_PROFESSOR_HAS_WORKSHOPS
)
from src.core.exceptions import NotFoundException, ValidationException
from src.monitoring.logging import get_logger

logger = get_logger(__name__)


class ProfessorService:
    """Servicio con lógica de negocio de profesores"""
    
    def __init__(self, db: Session):
        self.repository = ProfessorRepository(db)
        self.db = db
    
    def get_all(
        self,
        page: int = 1,
        page_size: int = 50
    ) -> Dict:
        """Obtiene todos los profesores con paginación"""
        skip = (page - 1) * page_size
        professors = self.repository.get_all(skip=skip, limit=page_size)
        total = self.repository.count()
        
        logger.info(f"Retrieved {len(professors)} professors (page {page})")
        
        return {
            "items": [self._to_response(p) for p in professors],
            "total": total,
            "page": page,
            "page_size": page_size
        }
    
    def get_by_id(self, professor_id: int) -> ProfessorResponse:
        """Obtiene un profesor por ID"""
        professor = self.repository.get_by_id(professor_id)
        if not professor:
            raise NotFoundException(MSG_PROFESSOR_NOT_FOUND)
        return self._to_response(professor)
    
    def get_by_email(self, email: str) -> ProfessorResponse:
        """Obtiene un profesor por email"""
        professor = self.repository.get_by_email(email)
        if not professor:
            raise NotFoundException(MSG_PROFESSOR_NOT_FOUND)
        return self._to_response(professor)
    
    def create(self, data: ProfessorCreate) -> ProfessorResponse:
        """Crea un nuevo profesor"""
        # Validar email único si se proporciona
        if data.email_professor:
            if self.repository.check_email_exists(data.email_professor):
                raise ValidationException(MSG_PROFESSOR_EMAIL_EXISTS)
        
        professor = Professor(
            name_professor=data.name_professor,
            email_professor=data.email_professor
        )
        
        created_professor = self.repository.create(professor)
        logger.info(f"Professor created: {created_professor.id} - {created_professor.name_professor}")
        
        return self._to_response(created_professor)
    
    def update(self, professor_id: int, data: ProfessorUpdate) -> ProfessorResponse:
        """Actualiza un profesor"""
        professor = self.repository.get_by_id(professor_id)
        if not professor:
            raise NotFoundException(MSG_PROFESSOR_NOT_FOUND)
        
        # Validar email único si se actualiza
        if data.email_professor and data.email_professor != professor.email_professor:
            if self.repository.check_email_exists(data.email_professor, exclude_id=professor_id):
                raise ValidationException(MSG_PROFESSOR_EMAIL_EXISTS)
            professor.email_professor = data.email_professor
        
        # Actualizar campos
        if data.name_professor:
            professor.name_professor = data.name_professor
        
        updated_professor = self.repository.update(professor)
        logger.info(f"Professor updated: {updated_professor.id}")
        
        return self._to_response(updated_professor)
    
    def delete(self, professor_id: int) -> None:
        """Elimina un profesor"""
        professor = self.repository.get_by_id(professor_id)
        if not professor:
            raise NotFoundException(MSG_PROFESSOR_NOT_FOUND)
        
        # Validar que no tenga talleres asignados
        if self.repository.has_workshops(professor_id):
            raise ValidationException(MSG_PROFESSOR_HAS_WORKSHOPS)
        
        self.repository.delete(professor)
        logger.info(f"Professor deleted: {professor_id}")
    
    def _to_response(self, professor: Professor) -> ProfessorResponse:
        """Convierte modelo a response"""
        return ProfessorResponse(
            id=professor.id,
            name_professor=professor.name_professor,
            email_professor=professor.email_professor
        )
