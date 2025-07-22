from fastapi import APIRouter, HTTPException, status
from schemas.admin.admin_create_in import AdminCreateIn
from schemas.admin.admin_out import AdminOut
from services.admin_service import (
    create_admin_service,
    get_all_admins_service,
    get_admin_by_id_service,
    update_admin_service,
    delete_admin_service,
)
from typing import List

router = APIRouter(prefix="/admins", tags=["admins"])


@router.post("/", response_model=int, status_code=status.HTTP_201_CREATED)
def create_admin(admin: AdminCreateIn):
    return create_admin_service(admin)


@router.get("/", response_model=List[AdminOut])
def list_admins():
    return get_all_admins_service()


@router.get("/{admin_id}", response_model=AdminOut)
def get_admin(admin_id: int):
    admin = get_admin_by_id_service(admin_id)
    if not admin:
        raise HTTPException(status_code=404, detail="Administrador no encontrado")
    return admin


@router.put("/{admin_id}", response_model=bool)
def update_admin(admin_id: int, admin: AdminCreateIn):
    updated = update_admin_service(admin_id, admin)
    if not updated:
        raise HTTPException(
            status_code=404, detail="Administrador no encontrado o sin cambios"
        )
    return updated


@router.delete("/{admin_id}", response_model=bool)
def delete_admin(admin_id: int):
    deleted = delete_admin_service(admin_id)
    if not deleted:
        raise HTTPException(status_code=404, detail="Administrador no encontrado")
    return deleted
