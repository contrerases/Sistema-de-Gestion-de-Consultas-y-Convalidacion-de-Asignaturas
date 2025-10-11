"""
Router de Grades
Sistema: SGSCT
"""
from fastapi import APIRouter, Depends, status, Query
from sqlalchemy.orm import Session
from typing import Annotated, Optional
from src.database.sessions import get_db
from src.modules.workshops.grades.service import GradeService
from src.modules.workshops.grades.schemas import GradeCreate, GradeUpdate
from src.core.responses import success_response, paginated_response

router = APIRouter(prefix="/grades", tags=["Calificaciones"])


@router.get("", status_code=status.HTTP_200_OK, summary="Listar calificaciones")
async def get_grades(
    page: Annotated[int, Query(ge=1)] = 1,
    page_size: Annotated[int, Query(ge=1, le=100)] = 20,
    workshop_id: Optional[int] = None,
    student_id: Optional[int] = None,
    db: Annotated[Session, Depends(get_db)] = None
):
    """Lista todas las calificaciones con filtros"""
    service = GradeService(db)
    result = service.get_all(page=page, page_size=page_size, workshop_id=workshop_id, student_id=student_id)
    
    return paginated_response(
        data=[item.model_dump() for item in result["items"]],
        page=result["page"],
        page_size=result["page_size"],
        total=result["total"]
    )


@router.get("/{grade_id}", status_code=status.HTTP_200_OK, summary="Obtener calificación")
async def get_grade(
    grade_id: int,
    db: Annotated[Session, Depends(get_db)] = None
):
    """Obtiene una calificación específica"""
    service = GradeService(db)
    grade = service.get_by_id(grade_id)
    
    return success_response(
        data=grade.model_dump(),
        message="Calificación obtenida exitosamente"
    )


@router.get("/workshop/{workshop_id}", status_code=status.HTTP_200_OK, summary="Calificaciones de taller")
async def get_grades_by_workshop(
    workshop_id: int,
    page: Annotated[int, Query(ge=1)] = 1,
    page_size: Annotated[int, Query(ge=1, le=100)] = 20,
    db: Annotated[Session, Depends(get_db)] = None
):
    """Obtiene todas las calificaciones de un taller"""
    service = GradeService(db)
    result = service.get_by_workshop(workshop_id, page=page, page_size=page_size)
    
    return paginated_response(
        data=[item.model_dump() for item in result["items"]],
        page=result["page"],
        page_size=result["page_size"],
        total=result["total"]
    )


@router.get("/student/{student_id}", status_code=status.HTTP_200_OK, summary="Calificaciones de estudiante")
async def get_grades_by_student(
    student_id: int,
    db: Annotated[Session, Depends(get_db)] = None
):
    """Obtiene todas las calificaciones de un estudiante"""
    service = GradeService(db)
    grades = service.get_by_student(student_id)
    
    return success_response(
        data=[grade.model_dump() for grade in grades],
        message="Calificaciones obtenidas exitosamente"
    )


@router.post("", status_code=status.HTTP_201_CREATED, summary="Asignar calificación")
async def create_grade(
    data: GradeCreate,
    db: Annotated[Session, Depends(get_db)] = None
):
    """Asigna una calificación a un estudiante"""
    service = GradeService(db)
    grade = service.create(data)
    
    return success_response(
        data=grade.model_dump(),
        message="Calificación asignada exitosamente"
    )


@router.put("/{grade_id}", status_code=status.HTTP_200_OK, summary="Actualizar calificación")
async def update_grade(
    grade_id: int,
    data: GradeUpdate,
    db: Annotated[Session, Depends(get_db)] = None
):
    """Actualiza una calificación existente"""
    service = GradeService(db)
    grade = service.update(grade_id, data)
    
    return success_response(
        data=grade.model_dump(),
        message="Calificación actualizada exitosamente"
    )


@router.delete("/{grade_id}", status_code=status.HTTP_200_OK, summary="Eliminar calificación")
async def delete_grade(
    grade_id: int,
    db: Annotated[Session, Depends(get_db)] = None
):
    """Elimina una calificación"""
    service = GradeService(db)
    service.delete(grade_id)
    
    return success_response(
        data=None,
        message="Calificación eliminada exitosamente"
    )
