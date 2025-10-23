"""
Router del módulo Users
Sistema: SGSCT
"""

from fastapi import APIRouter, Depends, Query
from sqlalchemy.orm import Session
from typing import Optional
from src.database.sessions import get_db
from src.modules.users.base.services import UserServices
from src.modules.users.base.schemas import UserCreate, UserUpdate, UserResponse
from src.modules.users.students.router import router as students_router


router = APIRouter(prefix="", tags=["Usuarios"])


router.include_router(students_router)


@router.get("/", summary="Listar usuarios")
def get_users(
    page: int = Query(1, ge=1),
    page_size: int = Query(50, ge=1, le=100),
    user_type_id: Optional[int] = Query(
        None, description="Filtrar por tipo de usuario"
    ),
    campus_id: Optional[int] = Query(None, description="Filtrar por campus"),
    db: Session = Depends(get_db),
):
    """Obtiene todos los usuarios con paginación y filtros"""
    service = UserServices(db)
    return service.get_all(
        page=page, page_size=page_size, user_type_id=user_type_id, campus_id=campus_id
    )


@router.get("/{user_id}", response_model=UserResponse)
def get_user_by_id(user_id: int, db: Session = Depends(get_db)):
    """Obtiene un usuario por ID"""
    service = UserServices(db)
    return service.get_by_id(user_id)


@router.get("/email/{email}", response_model=UserResponse)
def get_user_by_email(email: str, db: Session = Depends(get_db)):
    """Obtiene un usuario por email"""
    service = UserServices(db)
    return service.get_by_email(email)


@router.post("/", response_model=UserResponse, status_code=201)
def create_user(data: UserCreate, db: Session = Depends(get_db)):
    """Crea un nuevo usuario (estudiante o administrador)"""
    service = UserServices(db)
    return service.create(data)


@router.patch("/{user_id}", response_model=UserResponse)
def update_user(user_id: int, data: UserUpdate, db: Session = Depends(get_db)):
    """Actualiza un usuario"""
    service = UserServices(db)
    return service.update(user_id, data)


@router.delete("/{user_id}")
def delete_user(user_id: int, db: Session = Depends(get_db)):
    """Elimina un usuario"""
    service = UserServices(db)
    return service.delete(user_id)
