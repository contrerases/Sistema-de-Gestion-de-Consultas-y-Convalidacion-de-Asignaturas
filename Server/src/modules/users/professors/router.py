"""
Router del submódulo Professors
Sistema: SGSCT
"""

from fastapi import APIRouter, Depends, status
from sqlalchemy.orm import Session
from src.database.sessions import get_db
from src.modules.users.professors.services import ProfessorServices
from src.modules.users.professors.schemas import (
    ProfessorCreate,
    ProfessorUpdate,
    ProfessorResponse,
)
from src.modules.users.base.models import User
from src.modules.auth.dependencies import get_current_user

# MessageResponse ya no se usa, se retorna un dict directamente
from src.monitoring.logging import get_logger


from src.core.responses import PaginatedResponse

logger = get_logger(__name__)

router = APIRouter(prefix="/professors", tags=["Professors"])


@router.get("", response_model=PaginatedResponse[ProfessorResponse])
def get_all_professors(
    skip: int = 0,
    limit: int = 50,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    """Obtiene todos los profesores"""
    service = ProfessorServices(db)
    return service.get_all(skip=skip, limit=limit)


@router.get("/{professor_id}", response_model=ProfessorResponse)
def get_professor_by_id(
    professor_id: int,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    """Obtiene un profesor por ID"""
    service = ProfessorServices(db)
    return service.get_by_id(professor_id)


@router.get("/email/{email}", response_model=ProfessorResponse)
def get_professor_by_email(
    email: str,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    """Obtiene un profesor por email"""
    repo = ProfessorServices(db).repository
    professor = repo.get_by_email(email)
    if not professor:
        from fastapi import HTTPException

        raise HTTPException(status_code=404, detail="Profesor no encontrado")
    return ProfessorResponse.model_validate(professor)


@router.post("", status_code=status.HTTP_201_CREATED)
def create_professor(
    data: ProfessorCreate,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    """Crea un nuevo profesor"""
    service = ProfessorServices(db)
    return service.create(data)


@router.put("/{professor_id}")
def update_professor(
    professor_id: int,
    data: ProfessorUpdate,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    """Actualiza un profesor"""
    service = ProfessorServices(db)
    return service.update(professor_id, data)


@router.delete("/{professor_id}")
def delete_professor(
    professor_id: int,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    """Elimina un profesor"""
    service = ProfessorServices(db)
    service.delete(professor_id)
    return {"message": "Profesor eliminado exitosamente"}
