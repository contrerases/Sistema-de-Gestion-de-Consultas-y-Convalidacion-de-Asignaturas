"""
Endpoints REST para Curriculum Course Slot Type
"""

from typing import Annotated
from fastapi import APIRouter, Depends, status, Query
from sqlalchemy.orm import Session
from src.database.sessions import get_db

from src.modules.academic.curriculum_courses_slots.type.schemas import (
    CurriculumCourseTypeCreate,
    CurriculumCourseTypeUpdate,
    CurriculumCourseTypeResponse,
)
from src.modules.academic.curriculum_courses_slots.type.services import (
    CurriculumCourseTypeServices,
)
from src.core.responses import PaginatedResponse

router = APIRouter(prefix="/types", tags=["Curriculum Course Types"])


@router.get(
    "",
    status_code=status.HTTP_200_OK,
    summary="Listar tipos de curso del currículum",
    response_model=PaginatedResponse[CurriculumCourseTypeResponse],
)
async def get_course_types(
    db: Annotated[Session, Depends(get_db)],
    page: Annotated[int, Query(ge=1)] = 1,
    page_size: Annotated[int, Query(ge=1, le=100)] = 20,
):
    service = CurriculumCourseTypeServices(db)
    result = service.get_all(page=page, page_size=page_size)
    return PaginatedResponse(
        total=result["total"],
        items=[
            CurriculumCourseTypeResponse.model_validate(item)
            for item in result["items"]
        ],
        skip=(page - 1) * page_size,
        limit=page_size,
    )


@router.get(
    "/{type_id}", status_code=status.HTTP_200_OK, summary="Obtener tipo de curso"
)
async def get_course_type(type_id: int, db: Annotated[Session, Depends(get_db)]):
    service = CurriculumCourseTypeServices(db)
    course_type = service.get_by_id(type_id)
    return course_type


@router.post("", status_code=status.HTTP_201_CREATED, summary="Crear tipo de curso")
async def create_course_type(
    db: Annotated[Session, Depends(get_db)],
    data: CurriculumCourseTypeCreate,
):
    service = CurriculumCourseTypeServices(db)
    course_type = service.create(data)
    return course_type


@router.put(
    "/{type_id}", status_code=status.HTTP_200_OK, summary="Actualizar tipo de curso"
)
async def update_course_type(
    type_id: int,
    db: Annotated[Session, Depends(get_db)],
    data: CurriculumCourseTypeUpdate,
):
    service = CurriculumCourseTypeServices(db)
    course_type = service.update(type_id, data)
    return course_type


@router.delete(
    "/{type_id}", status_code=status.HTTP_200_OK, summary="Eliminar tipo de curso"
)
async def delete_course_type(
    type_id: int,
    db: Annotated[Session, Depends(get_db)],
):
    service = CurriculumCourseTypeServices(db)
    service.delete(type_id)
    return {"detail": "Tipo de curso eliminado exitosamente"}
