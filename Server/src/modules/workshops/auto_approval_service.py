"""
Servicio de Auto-Aprobación de Convalidaciones por Taller
Sistema: SGSCT

Este servicio contiene la lógica para auto-aprobar convalidaciones
cuando un taller cierra y los estudiantes tienen calificación aprobatoria.
"""
from sqlalchemy.orm import Session
from sqlalchemy import and_
from datetime import datetime
from src.modules.workshops.constants import PASSING_GRADE
from src.modules.convalidations.models import Convalidation, ConvalidationWorkshop
from src.modules.workshops.inscriptions.models import WorkshopInscription
from src.modules.workshops.grades.models import WorkshopGrade
from src.monitoring.logging import get_logger

logger = get_logger(__name__)


class WorkshopConvalidationAutoApprovalService:
    """Servicio para auto-aprobar convalidaciones de talleres"""
    
    def __init__(self, db: Session):
        self.db = db
    
    def auto_approve_workshop_convalidations(self, workshop_id: int, approved_by: int) -> int:
        """
        Auto-aprueba convalidaciones de un taller cuando este cierra.
        
        Lógica:
        1. Obtener todas las inscripciones del taller que tienen slot (id_curriculum_course)
        2. Verificar que tengan calificación >= PASSING_GRADE (55)
        3. Buscar la convalidación asociada al taller y slot
        4. Cambiar estado a APROBADA_DE (6) y registrar fecha/usuario de aprobación
        5. Actualizar workshop_grade en CONVALIDATIONS_WORKSHOPS
        
        Args:
            workshop_id: ID del taller que cierra
            approved_by: ID del usuario que aprueba (profesor/admin)
        
        Returns:
            Cantidad de convalidaciones auto-aprobadas
        """
        approved_count = 0
        
        try:
            # 1. Obtener inscripciones con slot del taller
            inscriptions = (
                self.db.query(WorkshopInscription)
                .filter(
                    and_(
                        WorkshopInscription.id_workshop == workshop_id,
                        WorkshopInscription.id_curriculum_course.isnot(None)
                    )
                )
                .all()
            )
            
            logger.info(f"Encontradas {len(inscriptions)} inscripciones con slot para taller {workshop_id}")
            
            for inscription in inscriptions:
                # 2. Verificar calificación aprobatoria
                grade = (
                    self.db.query(WorkshopGrade)
                    .filter(
                        and_(
                            WorkshopGrade.id_student == inscription.id_student,
                            WorkshopGrade.id_workshop == workshop_id
                        )
                    )
                    .first()
                )
                
                if not grade:
                    logger.warning(
                        f"Estudiante {inscription.id_student} no tiene calificación en taller {workshop_id}"
                    )
                    continue
                
                if grade.grade < PASSING_GRADE:
                    logger.info(
                        f"Estudiante {inscription.id_student} no aprobó (nota: {grade.grade})"
                    )
                    continue
                
                # 3. Buscar convalidación asociada
                convalidation = (
                    self.db.query(Convalidation)
                    .join(ConvalidationWorkshop)
                    .filter(
                        and_(
                            ConvalidationWorkshop.id_workshop == workshop_id,
                            Convalidation.id_curriculum_course == inscription.id_curriculum_course
                        )
                    )
                    .first()
                )
                
                if not convalidation:
                    logger.warning(
                        f"No se encontró convalidación para estudiante {inscription.id_student}, "
                        f"slot {inscription.id_curriculum_course}"
                    )
                    continue
                
                # 4. Auto-aprobar convalidación
                convalidation.id_convalidation_state = 6  # APROBADA_DE
                convalidation.approved_at = datetime.now()
                convalidation.approved_by = approved_by
                convalidation.review_comments = (
                    f"Auto-aprobada al cerrar taller (Nota: {grade.grade})"
                )
                
                # 5. Actualizar workshop_grade en especialización
                convalidation_workshop = (
                    self.db.query(ConvalidationWorkshop)
                    .filter(ConvalidationWorkshop.id_convalidation == convalidation.id)
                    .first()
                )
                
                if convalidation_workshop:
                    convalidation_workshop.workshop_grade = grade.grade
                
                approved_count += 1
                logger.info(
                    f"Auto-aprobada convalidación {convalidation.id} para estudiante "
                    f"{inscription.id_student} (nota: {grade.grade})"
                )
            
            self.db.commit()
            logger.info(f"Total de convalidaciones auto-aprobadas: {approved_count}")
            
        except Exception as e:
            self.db.rollback()
            logger.error(f"Error al auto-aprobar convalidaciones: {str(e)}")
            raise
        
        return approved_count
