"""
Router principal del módulo Convalidations
Sistema: SGSCT
"""
from fastapi import APIRouter, Depends, Query, File, UploadFile
from sqlalchemy.orm import Session
from typing import Optional
from src.database.sessions import get_db
from src.modules.convalidations.service import ConvalidationService
from src.modules.convalidations.schemas import (
    ConvalidationSubjectCreate,
    ConvalidationWorkshopCreate,
    ConvalidationExternalActivityCreate,
    ConvalidationUpdate,
    ConvalidationApprove,
    ConvalidationReject,
    ConvalidationResponse
)

# Importar routers de submódulos
from .requests.router import router as requests_router

router = APIRouter(prefix="/convalidations", tags=["Convalidaciones"])

# Agregar routers
router.include_router(requests_router)


# ============================================================================
# CONVALIDATIONS ENDPOINTS
# ============================================================================

@router.get("/", summary="Listar convalidaciones")
def get_convalidations(
    page: int = Query(1, ge=1),
    page_size: int = Query(50, ge=1, le=100),
    state_id: Optional[int] = Query(None, description="Filtrar por estado"),
    type_id: Optional[int] = Query(None, description="Filtrar por tipo"),
    request_id: Optional[int] = Query(None, description="Filtrar por solicitud"),
    db: Session = Depends(get_db)
):
    """Obtiene todas las convalidaciones con paginación y filtros"""
    service = ConvalidationService(db)
    return service.get_all(
        page=page,
        page_size=page_size,
        state_id=state_id,
        type_id=type_id,
        request_id=request_id
    )


@router.get("/{convalidation_id}", response_model=ConvalidationResponse)
def get_convalidation_by_id(convalidation_id: int, db: Session = Depends(get_db)):
    """Obtiene una convalidación por ID"""
    service = ConvalidationService(db)
    return service.get_by_id(convalidation_id)


@router.get("/request/{request_id}", summary="Convalidaciones por solicitud")
def get_convalidations_by_request(request_id: int, db: Session = Depends(get_db)):
    """Obtiene todas las convalidaciones de una solicitud"""
    service = ConvalidationService(db)
    return service.get_by_request(request_id)


# ============================================================================
# CREATE CONVALIDATIONS
# ============================================================================

@router.post("/subject", response_model=ConvalidationResponse)
def create_subject_convalidation(data: ConvalidationSubjectCreate, db: Session = Depends(get_db)):
    """Crea una convalidación de asignatura"""
    service = ConvalidationService(db)
    return service.create_subject(data)


@router.post("/workshop", response_model=ConvalidationResponse)
def create_workshop_convalidation(data: ConvalidationWorkshopCreate, db: Session = Depends(get_db)):
    """Crea una convalidación de taller"""
    service = ConvalidationService(db)
    return service.create_workshop(data)


@router.post("/external-activity", response_model=ConvalidationResponse)
def create_external_activity_convalidation(
    activity_name: str,
    id_request: int,
    id_convalidation_state: int,
    file: UploadFile = File(...),
    id_curriculum_course: Optional[int] = None,
    institution_name: Optional[str] = None,
    description: Optional[str] = None,
    review_comments: Optional[str] = None,
    db: Session = Depends(get_db)
):
    """Crea una convalidación de actividad externa con archivo"""
    # TODO: Implementar guardado de archivo
    file_path = f"/uploads/external_activities/{file.filename}"
    
    data = ConvalidationExternalActivityCreate(
        id_request=id_request,
        id_convalidation_state=id_convalidation_state,
        id_curriculum_course=id_curriculum_course,
        activity_name=activity_name,
        institution_name=institution_name,
        description=description,
        review_comments=review_comments
    )
    
    service = ConvalidationService(db)
    return service.create_external_activity(data, file_path=file_path)


# ============================================================================
# UPDATE CONVALIDATIONS
# ============================================================================

@router.patch("/{convalidation_id}", response_model=ConvalidationResponse)
def update_convalidation(
    convalidation_id: int,
    data: ConvalidationUpdate,
    db: Session = Depends(get_db)
):
    """Actualiza una convalidación"""
    service = ConvalidationService(db)
    return service.update(convalidation_id, data)


@router.patch("/{convalidation_id}/approve", response_model=ConvalidationResponse)
def approve_convalidation(
    convalidation_id: int,
    data: ConvalidationApprove,
    db: Session = Depends(get_db)
):
    """Aprueba una convalidación"""
    service = ConvalidationService(db)
    return service.approve(convalidation_id, data)


@router.patch("/{convalidation_id}/reject", response_model=ConvalidationResponse)
def reject_convalidation(
    convalidation_id: int,
    data: ConvalidationReject,
    db: Session = Depends(get_db)
):
    """Rechaza una convalidación"""
    service = ConvalidationService(db)
    return service.reject(convalidation_id, data)


# ============================================================================
# DELETE CONVALIDATIONS
# ============================================================================

@router.delete("/{convalidation_id}")
def delete_convalidation(convalidation_id: int, db: Session = Depends(get_db)):
    """Elimina una convalidación"""
    service = ConvalidationService(db)
    return service.delete(convalidation_id)
