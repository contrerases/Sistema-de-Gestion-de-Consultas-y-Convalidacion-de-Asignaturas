"""
Repositorio de Grades
Sistema: SGSCT
"""
from typing import List, Optional
from sqlalchemy.orm import Session
from sqlalchemy import and_
from src.modules.workshops.grades.models import WorkshopGrade


class GradeRepository:
    """Repositorio para operaciones CRUD de calificaciones"""
    
    def __init__(self, db: Session):
        self.db = db
    
    def get_all(self, skip: int = 0, limit: int = 100, workshop_id: Optional[int] = None, student_id: Optional[int] = None) -> List[WorkshopGrade]:
        """Obtiene todas las calificaciones con filtros"""
        query = self.db.query(WorkshopGrade)
        
        if workshop_id:
            query = query.filter(WorkshopGrade.id_workshop == workshop_id)
        if student_id:
            query = query.filter(WorkshopGrade.id_student == student_id)
        
        return query.order_by(WorkshopGrade.evaluated_at.desc()).offset(skip).limit(limit).all()
    
    def get_by_id(self, grade_id: int) -> Optional[WorkshopGrade]:
        """Obtiene una calificación por ID"""
        return self.db.query(WorkshopGrade).filter(WorkshopGrade.id == grade_id).first()
    
    def get_by_workshop(self, workshop_id: int, skip: int = 0, limit: int = 100) -> List[WorkshopGrade]:
        """Obtiene calificaciones de un taller"""
        return (
            self.db.query(WorkshopGrade)
            .filter(WorkshopGrade.id_workshop == workshop_id)
            .order_by(WorkshopGrade.evaluated_at.desc())
            .offset(skip)
            .limit(limit)
            .all()
        )
    
    def get_by_student(self, student_id: int) -> List[WorkshopGrade]:
        """Obtiene calificaciones de un estudiante"""
        return (
            self.db.query(WorkshopGrade)
            .filter(WorkshopGrade.id_student == student_id)
            .order_by(WorkshopGrade.evaluated_at.desc())
            .all()
        )
    
    def get_existing(self, student_id: int, workshop_id: int) -> Optional[WorkshopGrade]:
        """Verifica si existe calificación"""
        return (
            self.db.query(WorkshopGrade)
            .filter(
                and_(
                    WorkshopGrade.id_student == student_id,
                    WorkshopGrade.id_workshop == workshop_id
                )
            )
            .first()
        )
    
    def create(self, student_id: int, workshop_id: int, grade: int) -> WorkshopGrade:
        """Crea una nueva calificación"""
        workshop_grade = WorkshopGrade(
            id_student=student_id,
            id_workshop=workshop_id,
            grade=grade
        )
        self.db.add(workshop_grade)
        self.db.commit()
        self.db.refresh(workshop_grade)
        return workshop_grade
    
    def update(self, grade_id: int, grade: int) -> Optional[WorkshopGrade]:
        """Actualiza una calificación"""
        workshop_grade = self.get_by_id(grade_id)
        if workshop_grade:
            workshop_grade.grade = grade
            self.db.commit()
            self.db.refresh(workshop_grade)
        return workshop_grade
    
    def delete(self, grade_id: int) -> bool:
        """Elimina una calificación"""
        grade = self.get_by_id(grade_id)
        if grade:
            self.db.delete(grade)
            self.db.commit()
            return True
        return False
    
    def count(self, workshop_id: Optional[int] = None, student_id: Optional[int] = None) -> int:
        """Cuenta calificaciones con filtros"""
        query = self.db.query(WorkshopGrade)
        
        if workshop_id:
            query = query.filter(WorkshopGrade.id_workshop == workshop_id)
        if student_id:
            query = query.filter(WorkshopGrade.id_student == student_id)
        
        return query.count()
