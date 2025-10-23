"""
Repositorio para SUBJECTS
Sistema: SGSCT
"""

from typing import Optional, List
from sqlalchemy.orm import Session, joinedload
from src.modules.academic.subjects.models import Subject


class SubjectRepository:
    """Repositorio para operaciones CRUD de asignaturas"""

    def __init__(self, db: Session):
        self.db = db

    def get_all(self, skip: int = 0, limit: int = 100) -> List[Subject]:
        """Obtiene todas las asignaturas con paginación"""
        return (
            self.db.query(Subject)
            .options(joinedload(Subject.department))
            .order_by(Subject.acronym.asc())
            .offset(skip)
            .limit(limit)
            .all()
        )

    def get_by_id(self, subject_id: int) -> Optional[Subject]:
        """Obtiene una asignatura por ID"""
        return (
            self.db.query(Subject)
            .options(joinedload(Subject.department))
            .filter(Subject.id == subject_id)
            .first()
        )

    def get_by_acronym(self, acronym: str) -> Optional[Subject]:
        """Obtiene una asignatura por acrónimo"""
        return (
            self.db.query(Subject)
            .options(joinedload(Subject.department))
            .filter(Subject.acronym == acronym)
            .first()
        )

    def get_by_department(
        self, department_id: int, skip: int = 0, limit: int = 100
    ) -> List[Subject]:
        """Obtiene asignaturas de un departamento"""
        return (
            self.db.query(Subject)
            .options(joinedload(Subject.department))
            .filter(Subject.id_department == department_id)
            .order_by(Subject.acronym.asc())
            .offset(skip)
            .limit(limit)
            .all()
        )

    def create(
        self, acronym: str, name: str, id_department: int, credits: int
    ) -> Subject:
        """Crea una nueva asignatura"""
        subject = Subject(
            acronym=acronym, name=name, id_department=id_department, credits=credits
        )
        self.db.add(subject)
        self.db.refresh(subject)
        return subject

    def update(
        self, subject_id: int, acronym: str, name: str, id_department: int, credits: int
    ) -> Optional[Subject]:
        """Actualiza una asignatura"""
        subject = self.get_by_id(subject_id)
        if subject:
            setattr(subject, "acronym", acronym)
            setattr(subject, "name", name)
            setattr(subject, "id_department", id_department)
            setattr(subject, "credits", credits)
            self.db.refresh(subject)
        return subject

    def delete(self, subject_id: int) -> bool:
        """Elimina una asignatura"""
        subject = self.get_by_id(subject_id)
        if subject:
            self.db.delete(subject)
            return True
        return False

    def count(self) -> int:
        """Cuenta total de asignaturas"""
        return self.db.query(Subject).count()

    def count_by_department(self, department_id: int) -> int:
        """Cuenta asignaturas por departamento"""
        return (
            self.db.query(Subject)
            .filter(Subject.id_department == department_id)
            .count()
        )
