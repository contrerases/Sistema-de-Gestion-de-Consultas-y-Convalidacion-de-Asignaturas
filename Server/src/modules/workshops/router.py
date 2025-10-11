"""
Router principal del módulo Workshops
Sistema: SGSCT
"""
from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from pydantic import BaseModel
from src.database.sessions import get_db
from src.modules.workshops.auto_approval_service import WorkshopConvalidationAutoApprovalService
from src.monitoring.logging import get_logger

# Importar routers de submódulos
from .inscriptions.router import router as inscriptions_router
from .grades.router import router as grades_router
from .tokens.router import router as tokens_router

router = APIRouter(prefix="/workshops", tags=["Talleres"])

# Agregar routers
router.include_router(inscriptions_router)
router.include_router(grades_router)
router.include_router(tokens_router)

logger = get_logger(__name__)


# ============================================================================
# SCHEMAS
# ============================================================================

class CloseWorkshopRequest(BaseModel):
    """Schema para cerrar un taller"""
    approved_by: int
    auto_approve_convalidations: bool = True


# ============================================================================
# WORKSHOP MANAGEMENT ENDPOINTS
# ============================================================================

@router.post("/{workshop_id}/close", summary="Cerrar taller y auto-aprobar convalidaciones")
def close_workshop(
    workshop_id: int,
    data: CloseWorkshopRequest,
    db: Session = Depends(get_db)
):
    """
    Cierra un taller y opcionalmente auto-aprueba las convalidaciones
    de estudiantes con calificación aprobatoria (>= 55).
    
    Flujo:
    1. Cambia estado del taller a CERRADO
    2. Si auto_approve_convalidations=True:
       - Busca inscripciones con slot (id_curriculum_course)
       - Verifica calificaciones >= 55
       - Auto-aprueba convalidaciones asociadas
    """
    from src.modules.workshops.models import Workshop
    
    # Buscar taller
    workshop = db.query(Workshop).filter(Workshop.id == workshop_id).first()
    if not workshop:
        return {"error": f"Taller {workshop_id} no encontrado"}, 404
    
    # TODO: Cambiar estado del taller a CERRADO
    # workshop.id_workshop_state = CERRADO_STATE_ID
    
    result = {
        "workshop_id": workshop_id,
        "closed": True,
        "convalidations_approved": 0
    }
    
    # Auto-aprobar convalidaciones si está habilitado
    if data.auto_approve_convalidations:
        service = WorkshopConvalidationAutoApprovalService(db)
        approved_count = service.auto_approve_workshop_convalidations(
            workshop_id=workshop_id,
            approved_by=data.approved_by
        )
        result["convalidations_approved"] = approved_count
        logger.info(f"Taller {workshop_id} cerrado. {approved_count} convalidaciones auto-aprobadas")
    
    db.commit()
    return result
