from fastapi import APIRouter, status
from typing import List
from schemas.professor.professor_in import ProfessorIn
from schemas.professor.professor_out import ProfessorOut
from services.professor_service import (
    get_all_professors_active_service,
    get_professor_by_id_service,
    create_professor_service,
    update_professor_service
)

router = APIRouter(prefix="/professors", tags=["professors"])

@router.get("/", response_model=List[ProfessorOut])
def get_professors():
    """Lista todos los profesores activos"""
    return get_all_professors_active_service()

@router.get("/active", response_model=List[ProfessorOut])
def get_active_professors():
    """Lista todos los profesores activos (alias del endpoint principal)"""
    return get_all_professors_active_service()

@router.get("/{id_professor}", response_model=ProfessorOut)
def get_professor_by_id(id_professor: int):
    """Obtiene un profesor específico por ID"""
    return get_professor_by_id_service(id_professor)

@router.post("/", response_model=bool, status_code=status.HTTP_201_CREATED)
def create_professor(professor: ProfessorIn):
    """Crea un nuevo profesor"""
    return create_professor_service(professor)

@router.put("/{id_professor}", response_model=bool)
def update_professor(id_professor: int, professor: ProfessorIn):
    """Actualiza un profesor existente"""
    return update_professor_service(id_professor, professor) 