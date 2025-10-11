"""
Router de Inscriptions
Sistema: SGSCT
"""
from fastapi import APIRouter, Depends, status, Query
from sqlalchemy.orm import Session
from typing import Annotated, Optional
from src.database.sessions import get_db
from src.modules.workshops.inscriptions.service import InscriptionService
from src.modules.workshops.inscriptions.schemas import InscriptionCreate
from src.core.responses import success_response, paginated_response

router = APIRouter(prefix="/inscriptions", tags=["Inscripciones"])


@router.get("", status_code=status.HTTP_200_OK, summary="Listar inscripciones")
async def get_inscriptions(
    page: Annotated[int, Query(ge=1)] = 1,
    page_size: Annotated[int, Query(ge=1, le=100)] = 20,
    workshop_id: Optional[int] = None,
    student_id: Optional[int] = None,
    db: Annotated[Session, Depends(get_db)] = None
):
    """Lista todas las inscripciones con filtros"""
    service = InscriptionService(db)
    result = service.get_all(page=page, page_size=page_size, workshop_id=workshop_id, student_id=student_id)
    
    return paginated_response(
        data=[item.model_dump() for item in result["items"]],
        page=result["page"],
        page_size=result["page_size"],
        total=result["total"]
    )


@router.get("/{inscription_id}", status_code=status.HTTP_200_OK, summary="Obtener inscripción")
async def get_inscription(
    inscription_id: int,
    db: Annotated[Session, Depends(get_db)] = None
):
    """Obtiene una inscripción específica"""
    service = InscriptionService(db)
    inscription = service.get_by_id(inscription_id)
    
    return success_response(
        data=inscription.model_dump(),
        message="Inscripción obtenida exitosamente"
    )


@router.get("/workshop/{workshop_id}", status_code=status.HTTP_200_OK, summary="Inscripciones de taller")
async def get_inscriptions_by_workshop(
    workshop_id: int,
    page: Annotated[int, Query(ge=1)] = 1,
    page_size: Annotated[int, Query(ge=1, le=100)] = 20,
    db: Annotated[Session, Depends(get_db)] = None
):
    """Obtiene todas las inscripciones de un taller"""
    service = InscriptionService(db)
    result = service.get_by_workshop(workshop_id, page=page, page_size=page_size)
    
    return paginated_response(
        data=[item.model_dump() for item in result["items"]],
        page=result["page"],
        page_size=result["page_size"],
        total=result["total"]
    )


@router.get("/student/{student_id}", status_code=status.HTTP_200_OK, summary="Inscripciones de estudiante")
async def get_inscriptions_by_student(
    student_id: int,
    page: Annotated[int, Query(ge=1)] = 1,
    page_size: Annotated[int, Query(ge=1, le=100)] = 20,
    db: Annotated[Session, Depends(get_db)] = None
):
    """Obtiene todas las inscripciones de un estudiante"""
    service = InscriptionService(db)
    result = service.get_by_student(student_id, page=page, page_size=page_size)
    
    return paginated_response(
        data=[item.model_dump() for item in result["items"]],
        page=result["page"],
        page_size=result["page_size"],
        total=result["total"]
    )


@router.post("", status_code=status.HTTP_201_CREATED, summary="Crear inscripción")
async def create_inscription(
    data: InscriptionCreate,
    db: Annotated[Session, Depends(get_db)] = None
):
    """Crea una nueva inscripción a taller"""
    service = InscriptionService(db)
    inscription = service.create(data)
    
    return success_response(
        data=inscription.model_dump(),
        message="Inscripción creada exitosamente"
    )


@router.delete("/{inscription_id}", status_code=status.HTTP_200_OK, summary="Cancelar inscripción")
async def delete_inscription(
    inscription_id: int,
    db: Annotated[Session, Depends(get_db)] = None
):
    """Cancela una inscripción"""
    service = InscriptionService(db)
    service.delete(inscription_id)
    
    return success_response(
        data=None,
        message="Inscripción cancelada exitosamente"
    )
