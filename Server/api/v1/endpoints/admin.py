from fastapi import APIRouter, status
from typing import List
from schemas.admin.admin_in import AdminIn
from schemas.admin.admin_out import AdminOut
from services.admin_service import (
    get_all_admins_service,
    get_admin_by_id_service,
    get_admins_by_campus_service,
    get_admin_by_email_service,
    create_admin_service,
    update_admin_service,
    delete_admin_service
)

router = APIRouter(prefix="/admins", tags=["admins"])

@router.get("/", response_model=List[AdminOut])
def get_admins():
    """Obtiene lista de administradores"""
    return get_all_admins_service()

@router.get("/{id_admin}", response_model=AdminOut)
def get_admin_by_id(id_admin: int):
    """Obtiene un administrador específico por ID"""
    return get_admin_by_id_service(id_admin)

@router.get("/campus/{campus}", response_model=List[AdminOut])
def get_admins_by_campus(campus: str):
    """Obtiene administradores por campus"""
    return get_admins_by_campus_service(campus)

@router.get("/email/{email}", response_model=AdminOut)
def get_admin_by_email(email: str):
    """Obtiene un administrador por email"""
    return get_admin_by_email_service(email)

@router.post("/", response_model=bool, status_code=status.HTTP_201_CREATED)
def create_admin(admin: AdminIn):
    """Crea un nuevo administrador"""
    return create_admin_service(admin)

@router.put("/{id_admin}", response_model=bool)
def update_admin(id_admin: int, admin: AdminIn):
    """Actualiza un administrador existente"""
    return update_admin_service(id_admin, admin)

@router.delete("/{id_admin}", response_model=bool)
def delete_admin(id_admin: int):
    """Elimina un administrador"""
    return delete_admin_service(id_admin)
