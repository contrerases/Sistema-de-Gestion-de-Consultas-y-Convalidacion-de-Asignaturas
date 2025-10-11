"""
Repositorio de Inscriptions
Sistema: SGSCT
"""
from typing import List, Optional
from sqlalchemy.orm import Session
from sqlalchemy import and_
from src.modules.workshops.inscriptions.models import WorkshopInscription


class InscriptionRepository:
    """Repositorio para operaciones CRUD de inscripciones"""
    
    def __init__(self, db: Session):
        self.db = db
    
    def get_all(self, skip: int = 0, limit: int = 100, workshop_id: Optional[int] = None, student_id: Optional[int] = None) -> List[WorkshopInscription]:
        """Obtiene todas las inscripciones con filtros"""
        query = self.db.query(WorkshopInscription)
        
        if workshop_id:
            query = query.filter(WorkshopInscription.id_workshop == workshop_id)
        if student_id:
            query = query.filter(WorkshopInscription.id_student == student_id)
        
        return query.order_by(WorkshopInscription.inscription_at.asc()).offset(skip).limit(limit).all()
    
    def get_by_id(self, inscription_id: int) -> Optional[WorkshopInscription]:
        """Obtiene una inscripción por ID"""
        return self.db.query(WorkshopInscription).filter(WorkshopInscription.id == inscription_id).first()
    
    def get_by_workshop(self, workshop_id: int, skip: int = 0, limit: int = 100) -> List[WorkshopInscription]:
        """Obtiene inscripciones de un taller"""
        return (
            self.db.query(WorkshopInscription)
            .filter(WorkshopInscription.id_workshop == workshop_id)
            .order_by(WorkshopInscription.inscription_at.asc())
            .offset(skip)
            .limit(limit)
            .all()
        )
    
    def get_by_student(self, student_id: int, skip: int = 0, limit: int = 100) -> List[WorkshopInscription]:
        """Obtiene inscripciones de un estudiante"""
        return (
            self.db.query(WorkshopInscription)
            .filter(WorkshopInscription.id_student == student_id)
            .order_by(WorkshopInscription.inscription_at.asc())
            .offset(skip)
            .limit(limit)
            .all()
        )
    
    def check_existing(self, student_id: int, workshop_id: int) -> Optional[WorkshopInscription]:
        """Verifica si existe inscripción"""
        return (
            self.db.query(WorkshopInscription)
            .filter(
                and_(
                    WorkshopInscription.id_student == student_id,
                    WorkshopInscription.id_workshop == workshop_id
                )
            )
            .first()
        )
    
    def count_by_workshop(self, workshop_id: int) -> int:
        """Cuenta inscripciones de un taller"""
        return self.db.query(WorkshopInscription).filter(WorkshopInscription.id_workshop == workshop_id).count()
    
    def create(self, student_id: int, workshop_id: int, curriculum_course_id: Optional[int] = None) -> WorkshopInscription:
        """Crea una nueva inscripción"""
        inscription = WorkshopInscription(
            id_student=student_id,
            id_workshop=workshop_id,
            id_curriculum_course=curriculum_course_id,
            is_convalidated=False
        )
        self.db.add(inscription)
        self.db.commit()
        self.db.refresh(inscription)
        return inscription
    
    def delete(self, inscription_id: int) -> bool:
        """Elimina una inscripción"""
        inscription = self.get_by_id(inscription_id)
        if inscription:
            self.db.delete(inscription)
            self.db.commit()
            return True
        return False
    
    def count(self, workshop_id: Optional[int] = None, student_id: Optional[int] = None) -> int:
        """Cuenta inscripciones con filtros"""
        query = self.db.query(WorkshopInscription)
        
        if workshop_id:
            query = query.filter(WorkshopInscription.id_workshop == workshop_id)
        if student_id:
            query = query.filter(WorkshopInscription.id_student == student_id)
        
        return query.count()
