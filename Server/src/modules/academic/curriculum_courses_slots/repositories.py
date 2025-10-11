"""
Repositorio para CURRICULUM_COURSE_SLOTS
Sistema: SGSCT
"""
from typing import Optional, List
from sqlalchemy.orm import Session
from src.modules.academic.curriculum_courses_slots.models import CurriculumCourseSlot


class CurriculumCourseSlotRepository:
    """Repositorio para operaciones CRUD de casillas curriculares"""
    
    def __init__(self, db: Session):
        self.db = db
    
    def get_all(self, skip: int = 0, limit: int = 100) -> List[CurriculumCourseSlot]:
        """Obtiene todas las casillas curriculares con paginación"""
        return (
            self.db.query(CurriculumCourseSlot)
            .order_by(CurriculumCourseSlot.id.asc())
            .offset(skip)
            .limit(limit)
            .all()
        )
    
    def get_by_id(self, slot_id: int) -> Optional[CurriculumCourseSlot]:
        """Obtiene una casilla curricular por ID"""
        return (
            self.db.query(CurriculumCourseSlot)
            .filter(CurriculumCourseSlot.id == slot_id)
            .first()
        )
    
    def get_by_type(self, type_id: int, skip: int = 0, limit: int = 100) -> List[CurriculumCourseSlot]:
        """Obtiene casillas curriculares por tipo"""
        return (
            self.db.query(CurriculumCourseSlot)
            .filter(CurriculumCourseSlot.id_curriculum_course_type == type_id)
            .offset(skip)
            .limit(limit)
            .all()
        )
    
    def create(self, name: str, id_curriculum_course_type: int) -> CurriculumCourseSlot:
        """Crea una nueva casilla curricular"""
        slot = CurriculumCourseSlot(
            name=name,
            id_curriculum_course_type=id_curriculum_course_type
        )
        self.db.add(slot)
        self.db.commit()
        self.db.refresh(slot)
        return slot
    
    def update(self, slot_id: int, name: str, id_curriculum_course_type: int) -> Optional[CurriculumCourseSlot]:
        """Actualiza una casilla curricular"""
        slot = self.get_by_id(slot_id)
        if slot:
            slot.name = name
            slot.id_curriculum_course_type = id_curriculum_course_type
            self.db.commit()
            self.db.refresh(slot)
        return slot
    
    def delete(self, slot_id: int) -> bool:
        """Elimina una casilla curricular"""
        slot = self.get_by_id(slot_id)
        if slot:
            self.db.delete(slot)
            self.db.commit()
            return True
        return False
    
    def count(self) -> int:
        """Cuenta total de casillas curriculares"""
        return self.db.query(CurriculumCourseSlot).count()
    
    def count_by_type(self, type_id: int) -> int:
        """Cuenta casillas por tipo"""
        return (
            self.db.query(CurriculumCourseSlot)
            .filter(CurriculumCourseSlot.id_curriculum_course_type == type_id)
            .count()
        )
