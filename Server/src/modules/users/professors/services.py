"""
Servicio del submódulo Professors
Sistema: SGSCT
"""

from sqlalchemy.orm import Session
from src.modules.users.professors.repository import ProfessorRepository
from src.modules.users.professors.schemas import (
    ProfessorCreate,
    ProfessorUpdate,
    ProfessorResponse,
)
from src.modules.users.professors.models import Professor
from src.monitoring.logging import get_logger
from fastapi import HTTPException
from src.core.responses import PaginatedResponse

logger = get_logger(__name__)


class ProfessorServices:
    """Servicio con lógica de negocio de profesores"""

    def __init__(self, db: Session):
        self.repository = ProfessorRepository(db)
        self.db = db

    def get_all(
        self, skip: int = 0, limit: int = 50
    ) -> PaginatedResponse[ProfessorResponse]:
        """Obtiene todos los profesores con paginación"""
        professors = self.repository.get_all(skip=skip, limit=limit)
        total = self.repository.count()

        logger.info(f"Retrieved {len(professors)} professors")

        return PaginatedResponse(
            total=total,
            items=[self._to_response(p) for p in professors],
            skip=skip,
            limit=limit,
        )

    def get_by_id(self, professor_id: int) -> ProfessorResponse:
        """Obtiene un profesor por ID"""
        professor = self.repository.get_by_id(professor_id)
        if not professor:
            raise HTTPException(status_code=404, detail="Profesor no encontrado")
        return self._to_response(professor)

    def create(self, data: ProfessorCreate) -> ProfessorResponse:
        """Crea un nuevo profesor"""
        # Validar email único
        if self.repository.check_email_exists(data.email):
            raise HTTPException(status_code=400, detail="El email ya está registrado")

        # Crear profesor
        professor = Professor(
            name=data.name,
            email=data.email,
        )

        created_professor = self.repository.create(professor)
        logger.info(
            f"Professor created: {created_professor.id} - {created_professor.name}"
        )

        return self._to_response(created_professor)

    def update(self, professor_id: int, data: ProfessorUpdate) -> ProfessorResponse:
        """Actualiza un profesor"""
        professor = self.repository.get_by_id(professor_id)
        if not professor:
            raise HTTPException(status_code=404, detail="Profesor no encontrado")

        # Validar email único si cambió
        if data.email and data.email != professor.email:
            if self.repository.check_email_exists(data.email, exclude_id=professor_id):
                raise HTTPException(
                    status_code=400, detail="El email ya está registrado"
                )

        # Actualizar campos
        if data.name:
            setattr(professor, "name", data.name)
        if data.email:
            setattr(professor, "email", data.email)

        updated_professor = self.repository.update(professor)
        logger.info(f"Professor updated: {updated_professor.id}")

        return self._to_response(updated_professor)

    def delete(self, professor_id: int) -> None:
        """Elimina un profesor"""
        professor = self.repository.get_by_id(professor_id)
        if not professor:
            raise HTTPException(status_code=404, detail="Profesor no encontrado")

        # TODO: Verificar si tiene talleres asociados
        # if self._has_workshops(professor_id):
        #     raise HTTPException(status_code=400, detail="No se puede eliminar profesor con talleres asociados")

        self.repository.delete(professor)
        logger.info(f"Professor deleted: {professor_id}")

    def _to_response(self, professor: Professor) -> ProfessorResponse:
        """Convierte modelo a response"""
        return ProfessorResponse(
            id=getattr(professor, "id"),
            name=getattr(professor, "name"),
            email=getattr(professor, "email"),
        )
