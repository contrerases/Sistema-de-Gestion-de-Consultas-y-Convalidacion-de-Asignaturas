"""
Repositorio del submódulo Professors
Sistema: SGSCT
"""

from typing import List, Optional
from sqlalchemy.orm import Session
from users.professors.models import Professor


class ProfessorRepository:
    """Repositorio para operaciones CRUD de profesores"""

    def __init__(self, db: Session):
        self.db = db

    def get_all(self, skip: int = 0, limit: int = 100) -> List[Professor]:
        """Obtiene todos los profesores"""
        return (
            self.db.query(Professor)
            .order_by(Professor.name_professor.asc())
            .offset(skip)
            .limit(limit)
            .all()
        )

    def get_by_id(self, professor_id: int) -> Optional[Professor]:
        """Obtiene un profesor por ID"""
        return self.db.query(Professor).filter(Professor.id == professor_id).first()

    def get_by_email(self, email: str) -> Optional[Professor]:
        """Obtiene un profesor por email"""
        return (
            self.db.query(Professor).filter(Professor.email_professor == email).first()
        )

    def count(self) -> int:
        """Cuenta el total de profesores"""
        return self.db.query(Professor).count()

    def check_email_exists(self, email: str, exclude_id: Optional[int] = None) -> bool:
        """Verifica si existe un email de profesor"""
        query = self.db.query(Professor).filter(Professor.email_professor == email)
        if exclude_id:
            query = query.filter(Professor.id != exclude_id)
        return query.first() is not None

    # def has_workshops(self, professor_id: int) -> bool:
    #     """Verifica si un profesor tiene talleres asignados"""
    #     from src.modules.workshops.models import Workshop

    #     workshop = (
    #         self.db.query(Workshop)
    #         .filter(Workshop.id_professor == professor_id)
    #         .first()
    #     )
    #     return workshop is not None

    def create(self, professor: Professor) -> Professor:
        """Crea un nuevo profesor"""
        self.db.add(professor)
        self.db.commit()
        self.db.refresh(professor)
        return professor

    def update(self, professor: Professor) -> Professor:
        """Actualiza un profesor"""
        self.db.commit()
        self.db.refresh(professor)
        return professor

    def delete(self, professor: Professor) -> None:
        """Elimina un profesor"""
        self.db.delete(professor)
        self.db.commit()
