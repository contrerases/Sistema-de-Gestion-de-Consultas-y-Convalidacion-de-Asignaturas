"""
Endpoints REST para Curriculum Course Slot
"""

from typing import Annotated
from fastapi import APIRouter, Depends, status, Query
from sqlalchemy.orm import Session
from src.database.sessions import get_db
from src.modules.academic.curriculum_courses_slots.base.schemas import (
    CurriculumCourseSlotUpdate,
    CurriculumCourseSlotCreate,
    CurriculumCourseSlotResponse,
)
from src.modules.academic.curriculum_courses_slots.base.services import (
    CurriculumCourseSlotServices,
)

from src.core.responses import PaginatedResponse

router = APIRouter(prefix="")


@router.get(
    "/",
    status_code=status.HTTP_200_OK,
    summary="Listar slots ",
    response_model=PaginatedResponse[CurriculumCourseSlotResponse],
)
async def get_slots_(
    db: Annotated[Session, Depends(get_db)],
    page: Annotated[int, Query(ge=1)] = 1,
    page_size: Annotated[int, Query(ge=1, le=100)] = 20,
):
    service = CurriculumCourseSlotServices(db)
    result = service.get_all(page=page, page_size=page_size)
    return PaginatedResponse(
        total=result["total"],
        items=[
            CurriculumCourseSlotResponse.model_validate(item)
            for item in result["items"]
        ],
        skip=(page - 1) * page_size,
        limit=page_size,
    )


@router.get("/{slot_id}", status_code=status.HTTP_200_OK, summary="Obtener slot ")
async def get_slot_(slot_id: int, db: Annotated[Session, Depends(get_db)]):
    service = CurriculumCourseSlotServices(db)
    slot = service.get_by_id(slot_id)
    return slot


@router.post("/", status_code=status.HTTP_201_CREATED, summary="Crear slot ")
async def create_slot_(
    db: Annotated[Session, Depends(get_db)],
    data: CurriculumCourseSlotCreate,
):
    service = CurriculumCourseSlotServices(db)
    slot = service.create(data)
    return slot


@router.put("/{slot_id}", status_code=status.HTTP_200_OK, summary="Actualizar slot ")
async def update_slot_(
    slot_id: int,
    db: Annotated[Session, Depends(get_db)],
    data: CurriculumCourseSlotUpdate,
):
    service = CurriculumCourseSlotServices(db)
    slot = service.update(slot_id, data)
    return slot


@router.delete("/{slot_id}", status_code=status.HTTP_200_OK, summary="Eliminar slot ")
async def delete_slot_(
    slot_id: int,
    db: Annotated[Session, Depends(get_db)],
):
    service = CurriculumCourseSlotServices(db)
    service.delete(slot_id)
    return {"detail": "Slot  eliminado exitosamente"}
