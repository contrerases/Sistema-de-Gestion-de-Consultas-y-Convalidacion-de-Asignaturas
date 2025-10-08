"""
Endpoints REST para CURRICULUM_COURSES_TYPE
Sistema: SGSCT
"""
from typing import Annotated
from fastapi import APIRouter, Depends, status, Query
from sqlalchemy.orm import Session
from src.database.sessions import get_db
from src.modules.catalog.curriculum_course_types.service import CurriculumCourseTypeService
from src.modules.catalog.curriculum_course_types.schemas import CurriculumCourseTypeCreate, CurriculumCourseTypeUpdate
from src.modules.auth.dependencies import require_admin
from src.modules.auth.models import User
from src.core.responses import success_response, paginated_response

router = APIRouter(prefix="/curriculum-course-types", tags=["Tipos de Cursos Curriculares"])


@router.get("", status_code=status.HTTP_200_OK, summary="Listar tipos de cursos curriculares")
async def get_curriculum_course_types(
    page: Annotated[int, Query(ge=1)] = 1,
    page_size: Annotated[int, Query(ge=1, le=100)] = 20,
    db: Annotated[Session, Depends(get_db)] = None
):
    service = CurriculumCourseTypeService(db)
    result = service.get_all(page=page, page_size=page_size)
    
    return paginated_response(
        data=[item.model_dump() for item in result["items"]],
        page=result["page"],
        page_size=result["page_size"],
        total=result["total"]
    )


@router.get("/{type_id}", status_code=status.HTTP_200_OK, summary="Obtener tipo de curso curricular")
async def get_curriculum_course_type(
    type_id: int,
    db: Annotated[Session, Depends(get_db)] = None
):
    service = CurriculumCourseTypeService(db)
    curriculum_type = service.get_by_id(type_id)
    
    return success_response(
        data=curriculum_type.model_dump(),
        message="Tipo de curso curricular obtenido exitosamente"
    )


@router.post("", status_code=status.HTTP_201_CREATED, summary="Crear tipo de curso curricular (admin)")
async def create_curriculum_course_type(
    data: CurriculumCourseTypeCreate,
    db: Annotated[Session, Depends(get_db)] = None,
    admin: Annotated[User, Depends(require_admin)] = None
):
    service = CurriculumCourseTypeService(db)
    curriculum_type = service.create(data)
    
    return success_response(
        data=curriculum_type.model_dump(),
        message="Tipo de curso curricular creado exitosamente"
    )


@router.put("/{type_id}", status_code=status.HTTP_200_OK, summary="Actualizar tipo de curso curricular (admin)")
async def update_curriculum_course_type(
    type_id: int,
    data: CurriculumCourseTypeUpdate,
    db: Annotated[Session, Depends(get_db)] = None,
    admin: Annotated[User, Depends(require_admin)] = None
):
    service = CurriculumCourseTypeService(db)
    curriculum_type = service.update(type_id, data)
    
    return success_response(
        data=curriculum_type.model_dump(),
        message="Tipo de curso curricular actualizado exitosamente"
    )


@router.delete("/{type_id}", status_code=status.HTTP_200_OK, summary="Eliminar tipo de curso curricular (admin)")
async def delete_curriculum_course_type(
    type_id: int,
    db: Annotated[Session, Depends(get_db)] = None,
    admin: Annotated[User, Depends(require_admin)] = None
):
    service = CurriculumCourseTypeService(db)
    service.delete(type_id)
    
    return success_response(
        data=None,
        message="Tipo de curso curricular eliminado exitosamente"
    )
