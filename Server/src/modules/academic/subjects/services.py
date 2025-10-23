"""
Servicio de lógica de negocio para SUBJECTS
Sistema: SGSCT
"""

from typing import Dict, Any
from sqlalchemy.orm import Session
from src.modules.academic.subjects.repository import SubjectRepository
from src.modules.academic.subjects.schemas import (
    SubjectCreate,
    SubjectUpdate,
    SubjectResponse,
)

from src.modules.academic.departments.repository import DepartmentRepository
from fastapi import HTTPException, status
from src.monitoring.logging import get_logger

logger = get_logger(__name__)


class SubjectServices:
    """Servicio para gestión de asignaturas"""

    def __init__(self, db: Session):
        self.db = db
        self.repository = SubjectRepository(db)
        self.department_repository = DepartmentRepository(db)

    def get_all(self, page: int = 1, page_size: int = 20) -> Dict[str, Any]:
        """Obtiene todas las asignaturas paginadas"""
        skip = (page - 1) * page_size
        subjects = self.repository.get_all(skip=skip, limit=page_size)
        total = self.repository.count()

        return {
            "items": [self._to_response(subject) for subject in subjects],
            "page": page,
            "page_size": page_size,
            "total": total,
        }

    def get_by_id(self, subject_id: int) -> SubjectResponse:
        """Obtiene una asignatura por ID"""
        subject = self.repository.get_by_id(subject_id)

        if not subject:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail=f"Asignatura con ID {subject_id} no encontrada",
            )

        return self._to_response(subject)

    def get_by_department(
        self, department_id: int, page: int = 1, page_size: int = 20
    ) -> Dict[str, Any]:
        """Obtiene asignaturas de un departamento"""
        # Verificar que el departamento existe
        department = self.department_repository.get_by_id(department_id)
        if not department:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail=f"Departamento con ID {department_id} no encontrado",
            )

        skip = (page - 1) * page_size
        subjects = self.repository.get_by_department(
            department_id, skip=skip, limit=page_size
        )
        total = self.repository.count_by_department(department_id)

        return {
            "items": [self._to_response(subject) for subject in subjects],
            "page": page,
            "page_size": page_size,
            "total": total,
        }

    def create(self, data: SubjectCreate) -> SubjectResponse:
        """Crea una nueva asignatura"""
        # Verificar que el departamento existe
        department = self.department_repository.get_by_id(data.id_department)
        if not department:
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail="Departamento no encontrado",
            )

        # Verificar que no exista una asignatura con el mismo acrónimo
        existing = self.repository.get_by_acronym(data.acronym)
        if existing:
            raise HTTPException(
                status_code=status.HTTP_409_CONFLICT,
                detail="Ya existe una asignatura con ese acrónimo",
            )

        subject = self.repository.create(
            acronym=data.acronym,
            name=data.name,
            id_department=data.id_department,
            credits=data.credits,
        )

        logger.info(
            f"Asignatura creada: {data.acronym} - {data.name} (ID: {subject.id})"
        )
        return self._to_response(subject)

    def update(self, subject_id: int, data: SubjectUpdate) -> SubjectResponse:
        """Actualiza una asignatura"""
        # Verificar que existe
        existing = self.repository.get_by_id(subject_id)
        if not existing:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail=f"Asignatura con ID {subject_id} no encontrada",
            )

        # Verificar que el departamento existe
        department = self.department_repository.get_by_id(data.id_department)
        if not department:
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail="Departamento no encontrado",
            )

        # Verificar que el nuevo acrónimo no esté en uso por otra asignatura
        acronym_check = self.repository.get_by_acronym(data.acronym)
        if acronym_check is not None and getattr(acronym_check, "id") != subject_id:
            raise HTTPException(
                status_code=status.HTTP_409_CONFLICT,
                detail="Ya existe otra asignatura con ese acrónimo",
            )

        subject = self.repository.update(
            subject_id=subject_id,
            acronym=data.acronym,
            name=data.name,
            id_department=data.id_department,
            credits=data.credits,
        )

        logger.info(f"Asignatura actualizada: ID {subject_id} -> {data.acronym}")
        return self._to_response(subject)

    def delete(self, subject_id: int) -> None:
        """Elimina una asignatura"""
        existing = self.repository.get_by_id(subject_id)
        if not existing:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail=f"Asignatura con ID {subject_id} no encontrada",
            )

        logger.warning(f"Asignatura eliminada: {existing.acronym} (ID: {subject_id})")

        success = self.repository.delete(subject_id)
        if not success:
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail="No se pudo eliminar la asignatura",
            )

    def _to_response(self, subject) -> SubjectResponse:
        """Convierte modelo ORM a schema de respuesta"""
        return SubjectResponse(
            id=subject.id,
            acronym=subject.acronym,
            name=subject.name,
            id_department=subject.id_department,
            department_name=subject.department.name,
            credits=subject.credits,
        )
