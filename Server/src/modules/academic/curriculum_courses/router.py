"""
Endpoints REST para CURRICULUM_COURSE_SLOTS
Sistema: SGSCT
"""
from typing import Annotated
from fastapi import APIRouter, Depends, status, Query
from sqlalchemy.orm import Session
from src.database.sessions import get_db
from src.modules.academic.curriculum_courses.service import CurriculumCourseSlotService
from src.modules.academic.curriculum_courses.schemas import (
    CurriculumCourseSlotCreate,
    CurriculumCourseSlotUpdate
)
from src.modules.auth.dependencies import require_admin
from src.modules.auth.models import User
from src.core.responses import success_response, paginated_response

router = APIRouter(prefix="/curriculum-slots", tags=["Casillas Curriculares"])


@router.get(
    "",
    status_code=status.HTTP_200_OK,
    summary="Listar casillas curriculares"
)
async def get_curriculum_slots(
    page: Annotated[int, Query(ge=1)] = 1,
    page_size: Annotated[int, Query(ge=1, le=100)] = 20,
    db: Annotated[Session, Depends(get_db)] = None
):
    service = CurriculumCourseSlotService(db)
    result = service.get_all(page=page, page_size=page_size)
    
    return paginated_response(
        data=[item.model_dump() for item in result["items"]],
        page=result["page"],
        page_size=result["page_size"],
        total=result["total"]
    )


@router.get(
    "/{slot_id}",
    status_code=status.HTTP_200_OK,
    summary="Obtener casilla curricular"
)
async def get_curriculum_slot(
    slot_id: int,
    db: Annotated[Session, Depends(get_db)] = None
):
    service = CurriculumCourseSlotService(db)
    slot = service.get_by_id(slot_id)
    
    return success_response(
        data=slot.model_dump(),
        message="Casilla curricular obtenida exitosamente"
    )


@router.post(
    "",
    status_code=status.HTTP_201_CREATED,
    summary="Crear casilla curricular (solo administradores)"
)
async def create_curriculum_slot(
    data: CurriculumCourseSlotCreate,
    db: Annotated[Session, Depends(get_db)] = None,
    admin: Annotated[User, Depends(require_admin)] = None
):
    service = CurriculumCourseSlotService(db)
    slot = service.create(data)
    
    return success_response(
        data=slot.model_dump(),
        message="Casilla curricular creada exitosamente"
    )


@router.put(
    "/{slot_id}",
    status_code=status.HTTP_200_OK,
    summary="Actualizar casilla curricular (solo administradores)"
)
async def update_curriculum_slot(
    slot_id: int,
    data: CurriculumCourseSlotUpdate,
    db: Annotated[Session, Depends(get_db)] = None,
    admin: Annotated[User, Depends(require_admin)] = None
):
    service = CurriculumCourseSlotService(db)
    slot = service.update(slot_id, data)
    
    return success_response(
        data=slot.model_dump(),
        message="Casilla curricular actualizada exitosamente"
    )


@router.delete(
    "/{slot_id}",
    status_code=status.HTTP_200_OK,
    summary="Eliminar casilla curricular (solo administradores)"
)
async def delete_curriculum_slot(
    slot_id: int,
    db: Annotated[Session, Depends(get_db)] = None,
    admin: Annotated[User, Depends(require_admin)] = None
):
    service = CurriculumCourseSlotService(db)
    service.delete(slot_id)
    
    return success_response(
        data=None,
        message="Casilla curricular eliminada exitosamente"
    )
