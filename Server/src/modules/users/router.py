"""
Router del módulo Users
Sistema: SGSCT
"""
from fastapi import APIRouter, Depends, Query
from sqlalchemy.orm import Session
from typing import Optional
from src.database.sessions import get_db
from src.modules.users.service import UserService, ProfessorService
from src.modules.users.schemas import (
    UserCreate,
    UserUpdate,
    UserResponse,
    ProfessorCreate,
    ProfessorUpdate,
    ProfessorResponse
)

# Importar submódulos
from src.modules.users.students.router import router as students_router
from src.modules.users.professors.router import router as professors_router
from src.modules.users.administrators.router import router as administrators_router

router = APIRouter(prefix="/users", tags=["Usuarios"])

# Registrar submódulos
router.include_router(students_router)
router.include_router(professors_router)
router.include_router(administrators_router)


# ============================================================================
# USERS ENDPOINTS
# ============================================================================

@router.get("/", summary="Listar usuarios")
def get_users(
    page: int = Query(1, ge=1),
    page_size: int = Query(50, ge=1, le=100),
    user_type_id: Optional[int] = Query(None, description="Filtrar por tipo de usuario"),
    campus_id: Optional[int] = Query(None, description="Filtrar por campus"),
    db: Session = Depends(get_db)
):
    """Obtiene todos los usuarios con paginación y filtros"""
    service = UserService(db)
    return service.get_all(
        page=page,
        page_size=page_size,
        user_type_id=user_type_id,
        campus_id=campus_id
    )


@router.get("/{user_id}", response_model=UserResponse)
def get_user_by_id(user_id: int, db: Session = Depends(get_db)):
    """Obtiene un usuario por ID"""
    service = UserService(db)
    return service.get_by_id(user_id)


@router.get("/email/{email}", response_model=UserResponse)
def get_user_by_email(email: str, db: Session = Depends(get_db)):
    """Obtiene un usuario por email"""
    service = UserService(db)
    return service.get_by_email(email)


@router.post("/", response_model=UserResponse, status_code=201)
def create_user(data: UserCreate, db: Session = Depends(get_db)):
    """Crea un nuevo usuario (estudiante o administrador)"""
    service = UserService(db)
    return service.create(data)


@router.patch("/{user_id}", response_model=UserResponse)
def update_user(user_id: int, data: UserUpdate, db: Session = Depends(get_db)):
    """Actualiza un usuario"""
    service = UserService(db)
    return service.update(user_id, data)


@router.delete("/{user_id}")
def delete_user(user_id: int, db: Session = Depends(get_db)):
    """Elimina un usuario"""
    service = UserService(db)
    return service.delete(user_id)


# ============================================================================
# PROFESSORS ENDPOINTS
# ============================================================================

@router.get("/professors/", summary="Listar profesores")
def get_professors(
    page: int = Query(1, ge=1),
    page_size: int = Query(50, ge=1, le=100),
    db: Session = Depends(get_db)
):
    """Obtiene todos los profesores con paginación"""
    service = ProfessorService(db)
    return service.get_all(page=page, page_size=page_size)


@router.get("/professors/{professor_id}", response_model=ProfessorResponse)
def get_professor_by_id(professor_id: int, db: Session = Depends(get_db)):
    """Obtiene un profesor por ID"""
    service = ProfessorService(db)
    return service.get_by_id(professor_id)


@router.post("/professors/", response_model=ProfessorResponse, status_code=201)
def create_professor(data: ProfessorCreate, db: Session = Depends(get_db)):
    """Crea un nuevo profesor"""
    service = ProfessorService(db)
    return service.create(data)


@router.patch("/professors/{professor_id}", response_model=ProfessorResponse)
def update_professor(
    professor_id: int,
    data: ProfessorUpdate,
    db: Session = Depends(get_db)
):
    """Actualiza un profesor"""
    service = ProfessorService(db)
    return service.update(professor_id, data)


@router.delete("/professors/{professor_id}")
def delete_professor(professor_id: int, db: Session = Depends(get_db)):
    """Elimina un profesor (solo si no tiene talleres asignados)"""
    service = ProfessorService(db)
    return service.delete(professor_id)
