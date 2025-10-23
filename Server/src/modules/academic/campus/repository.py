"""
Repositorio para CAMPUS
Sistema: SGSCT
"""

from typing import Optional, List
from sqlalchemy.orm import Session
from src.modules.academic.campus.models import Campus


class CampusRepository:
    """Repositorio para operaciones CRUD de campus"""

    def __init__(self, db: Session):
        self.db = db

    def get_all(self, skip: int = 0, limit: int = 100) -> List[Campus]:
        """Obtiene todos los campus con paginación"""
        return (
            self.db.query(Campus)
            .order_by(Campus.name.asc())
            .offset(skip)
            .limit(limit)
            .all()
        )

    def get_by_id(self, campus_id: int) -> Optional[Campus]:
        """Obtiene un campus por ID"""
        return self.db.query(Campus).filter(Campus.id == campus_id).first()

    def get_by_acronym(self, acronym: str) -> Optional[Campus]:
        """Obtiene un campus por acrónimo"""
        return self.db.query(Campus).filter(Campus.acronym == acronym).first()

    def create(self, acronym: str, name: str, location: str) -> Campus:
        """Crea un nuevo campus"""
        campus = Campus(acronym=acronym, name=name, location=location)
        self.db.add(campus)
        self.db.commit()
        self.db.refresh(campus)
        return campus

    def update(
        self, campus_id: int, acronym: str, name: str, location: str
    ) -> Optional[Campus]:
        """Actualiza un campus"""
        campus = self.get_by_id(campus_id)
        if campus:
            setattr(campus, "acronym", acronym)
            setattr(campus, "name", name)
            setattr(campus, "location", location)
            self.db.commit()
            self.db.refresh(campus)
        return campus

    def delete(self, campus_id: int) -> bool:
        """Elimina un campus"""
        campus = self.get_by_id(campus_id)
        if campus:
            self.db.delete(campus)
            self.db.commit()
            return True
        return False

    def count(self) -> int:
        """Cuenta total de campus"""
        return self.db.query(Campus).count()
