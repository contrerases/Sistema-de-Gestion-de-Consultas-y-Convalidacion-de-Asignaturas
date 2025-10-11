"""
Repositorio de Convalidations
Sistema: SGSCT
"""
from typing import List, Optional
from sqlalchemy.orm import Session, joinedload
from sqlalchemy import and_
from datetime import datetime
from src.modules.convalidations.models import (
    Convalidation, 
    ConvalidationSubject, 
    ConvalidationWorkshop,
    ConvalidationExternalActivity
)


class ConvalidationRepository:
    """Repositorio para operaciones CRUD de convalidaciones"""
    
    def __init__(self, db: Session):
        self.db = db
    
    # ========================================================================
    # READ OPERATIONS
    # ========================================================================
    
    def get_all(
        self, 
        skip: int = 0, 
        limit: int = 100,
        state_id: Optional[int] = None,
        type_id: Optional[int] = None,
        request_id: Optional[int] = None
    ) -> List[Convalidation]:
        """Obtiene todas las convalidaciones con filtros"""
        query = self.db.query(Convalidation).options(
            joinedload(Convalidation.request)
        )
        
        if state_id:
            query = query.filter(Convalidation.id_convalidation_state == state_id)
        if type_id:
            query = query.filter(Convalidation.id_convalidation_type == type_id)
        if request_id:
            query = query.filter(Convalidation.id_request == request_id)
        
        return query.order_by(Convalidation.id.asc()).offset(skip).limit(limit).all()
    
    def get_by_id(self, convalidation_id: int) -> Optional[Convalidation]:
        """Obtiene una convalidación por ID"""
        return self.db.query(Convalidation).filter(Convalidation.id == convalidation_id).first()
    
    def get_by_request(self, request_id: int) -> List[Convalidation]:
        """Obtiene convalidaciones de una solicitud"""
        return (
            self.db.query(Convalidation)
            .filter(Convalidation.id_request == request_id)
            .order_by(Convalidation.id.asc())
            .all()
        )
    
    def check_slot_convalidated(self, student_id: int, slot_id: int) -> Optional[Convalidation]:
        """Verifica si un estudiante ya convalidó un slot"""
        return (
            self.db.query(Convalidation)
            .join(Convalidation.request)
            .filter(
                and_(
                    Convalidation.id_curriculum_course == slot_id,
                    Convalidation.request.has(id_student=student_id)
                )
            )
            .first()
        )
    
    # ========================================================================
    # CREATE OPERATIONS
    # ========================================================================
    
    def create_subject(
        self,
        request_id: int,
        state_id: int,
        subject_id: int,
        curriculum_course_id: Optional[int] = None,
        review_comments: Optional[str] = None,
        convalidation_type_id: int = 1  # ELECTIVO DI por defecto
    ) -> Convalidation:
        """Crea una convalidación de asignatura"""
        # Crear convalidación base
        convalidation = Convalidation(
            id_request=request_id,
            id_convalidation_type=convalidation_type_id,
            id_convalidation_state=state_id,
            id_curriculum_course=curriculum_course_id,
            review_comments=review_comments
        )
        self.db.add(convalidation)
        self.db.flush()
        
        # Crear especialización de asignatura
        convalidation_subject = ConvalidationSubject(
            id_convalidation=convalidation.id,
            id_subject=subject_id
        )
        self.db.add(convalidation_subject)
        self.db.commit()
        self.db.refresh(convalidation)
        return convalidation
    
    def create_workshop(
        self,
        request_id: int,
        state_id: int,
        workshop_id: int,
        curriculum_course_id: Optional[int] = None,
        workshop_grade: Optional[float] = None,
        review_comments: Optional[str] = None,
        convalidation_type_id: int = 3  # TALLER DI
    ) -> Convalidation:
        """Crea una convalidación de taller"""
        # Crear convalidación base
        convalidation = Convalidation(
            id_request=request_id,
            id_convalidation_type=convalidation_type_id,
            id_convalidation_state=state_id,
            id_curriculum_course=curriculum_course_id,
            review_comments=review_comments
        )
        self.db.add(convalidation)
        self.db.flush()
        
        # Crear especialización de taller
        convalidation_workshop = ConvalidationWorkshop(
            id_convalidation=convalidation.id,
            id_workshop=workshop_id,
            workshop_grade=workshop_grade
        )
        self.db.add(convalidation_workshop)
        self.db.commit()
        self.db.refresh(convalidation)
        return convalidation
    
    def create_external_activity(
        self,
        request_id: int,
        state_id: int,
        activity_name: str,
        curriculum_course_id: Optional[int] = None,
        institution_name: Optional[str] = None,
        description: Optional[str] = None,
        file_path: Optional[str] = None,
        review_comments: Optional[str] = None,
        convalidation_type_id: int = 4  # PROYECTO PERSONAL por defecto
    ) -> Convalidation:
        """Crea una convalidación de actividad externa"""
        # Crear convalidación base
        convalidation = Convalidation(
            id_request=request_id,
            id_convalidation_type=convalidation_type_id,
            id_convalidation_state=state_id,
            id_curriculum_course=curriculum_course_id,
            review_comments=review_comments
        )
        self.db.add(convalidation)
        self.db.flush()
        
        # Crear especialización de actividad externa
        external_activity = ConvalidationExternalActivity(
            id_convalidation=convalidation.id,
            activity_name=activity_name,
            institution_name=institution_name,
            description=description,
            file_path=file_path
        )
        self.db.add(external_activity)
        self.db.commit()
        self.db.refresh(convalidation)
        return convalidation
    
    # ========================================================================
    # UPDATE OPERATIONS
    # ========================================================================
    
    def update(
        self,
        convalidation_id: int,
        state_id: Optional[int] = None,
        review_comments: Optional[str] = None
    ) -> Optional[Convalidation]:
        """Actualiza una convalidación"""
        convalidation = self.get_by_id(convalidation_id)
        if convalidation:
            if state_id:
                convalidation.id_convalidation_state = state_id
            if review_comments:
                convalidation.review_comments = review_comments
            
            self.db.commit()
            self.db.refresh(convalidation)
        return convalidation
    
    def approve(
        self,
        convalidation_id: int,
        approved_by: int,
        review_comments: Optional[str] = None,
        approved_state_id: int = 6  # APROBADA_DE
    ) -> Optional[Convalidation]:
        """Aprueba una convalidación"""
        convalidation = self.get_by_id(convalidation_id)
        if convalidation:
            convalidation.id_convalidation_state = approved_state_id
            convalidation.approved_at = datetime.now()
            convalidation.approved_by = approved_by
            if review_comments:
                convalidation.review_comments = review_comments
            
            self.db.commit()
            self.db.refresh(convalidation)
        return convalidation
    
    def reject(
        self,
        convalidation_id: int,
        reason: str,
        rejected_state_id: int = 5  # RECHAZADA_DE
    ) -> Optional[Convalidation]:
        """Rechaza una convalidación"""
        convalidation = self.get_by_id(convalidation_id)
        if convalidation:
            convalidation.id_convalidation_state = rejected_state_id
            convalidation.review_comments = reason
            
            self.db.commit()
            self.db.refresh(convalidation)
        return convalidation
    
    # ========================================================================
    # DELETE OPERATIONS
    # ========================================================================
    
    def delete(self, convalidation_id: int) -> bool:
        """Elimina una convalidación"""
        convalidation = self.get_by_id(convalidation_id)
        if convalidation:
            self.db.delete(convalidation)
            self.db.commit()
            return True
        return False
    
    # ========================================================================
    # COUNT OPERATIONS
    # ========================================================================
    
    def count(
        self,
        state_id: Optional[int] = None,
        type_id: Optional[int] = None,
        request_id: Optional[int] = None
    ) -> int:
        """Cuenta convalidaciones con filtros"""
        query = self.db.query(Convalidation)
        
        if state_id:
            query = query.filter(Convalidation.id_convalidation_state == state_id)
        if type_id:
            query = query.filter(Convalidation.id_convalidation_type == type_id)
        if request_id:
            query = query.filter(Convalidation.id_request == request_id)
        
        return query.count()
