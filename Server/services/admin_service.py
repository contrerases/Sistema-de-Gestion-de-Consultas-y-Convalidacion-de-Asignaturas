from typing import List, Optional
from fastapi import HTTPException
from schemas.admin.admin_in import AdminIn
from schemas.admin.admin_out import AdminOut
from crud.admin import (
    get_admins,
    get_admin_by_id,
    get_admins_by_campus,
    get_admin_by_email,
    get_admin_complete,
    create_administrator,
    update_administrator,
    delete_administrator
)
import bcrypt
import mariadb

# =============================================================================
# SERVICIOS DE ADMINISTRADORES
# =============================================================================

def get_all_admins_service() -> List[AdminOut]:
    """Obtiene lista de administradores con datos mínimos para preview"""
    try:
        rows = get_admins()
        return [AdminOut(**row) for row in rows]
    except mariadb.Error as e:
        raise HTTPException(status_code=500, detail=str(e))

def get_admin_by_id_service(admin_id: int) -> AdminOut:
    """Obtiene un administrador por ID con datos mínimos"""
    try:
        result = get_admin_by_id(admin_id)
        if not result:
            raise HTTPException(status_code=404, detail="Administrador no encontrado.")
        return AdminOut(**result)
    except mariadb.Error as e:
        raise HTTPException(status_code=500, detail=str(e))

def get_admins_by_campus_service(campus: str) -> List[AdminOut]:
    """Obtiene administradores por campus con datos mínimos"""
    try:
        rows = get_admins_by_campus(campus)
        return [AdminOut(**row) for row in rows]
    except mariadb.Error as e:
        raise HTTPException(status_code=500, detail=str(e))

def get_admin_by_email_service(email: str) -> AdminOut:
    """Obtiene un administrador por email con datos mínimos"""
    try:
        result = get_admin_by_email(email)
        if not result:
            raise HTTPException(status_code=404, detail="Administrador no encontrado.")
        return AdminOut(**result)
    except mariadb.Error as e:
        raise HTTPException(status_code=500, detail=str(e))

def get_admin_complete_service(admin_id: int) -> AdminOut:
    """Obtiene un administrador por ID con datos completos"""
    try:
        result = get_admin_complete(admin_id)
        if not result:
            raise HTTPException(status_code=404, detail="Administrador no encontrado.")
        return AdminOut(**result)
    except mariadb.Error as e:
        raise HTTPException(status_code=500, detail=str(e))

def create_admin_service(admin: AdminIn) -> bool:
    """Crea un nuevo administrador"""
    try:
        password_hash = bcrypt.hashpw(admin.password.encode('utf-8'), bcrypt.gensalt()).decode('utf-8')
        return create_administrator(
            admin.first_names,
            admin.last_names,
            admin.campus,
            admin.email,
            password_hash
        )
    except mariadb.Error as e:
        raise HTTPException(status_code=400, detail=str(e))

def update_admin_service(admin_id: int, admin: AdminIn) -> bool:
    """Actualiza un administrador existente"""
    try:
        password_hash = bcrypt.hashpw(admin.password.encode('utf-8'), bcrypt.gensalt()).decode('utf-8') if admin.password else None
        return update_administrator(
            admin_id,
            admin.first_names,
            admin.last_names,
            admin.campus,
            admin.email,
            password_hash
        )
    except mariadb.Error as e:
        raise HTTPException(status_code=400, detail=str(e))

def delete_admin_service(admin_id: int) -> bool:
    """Elimina un administrador"""
    try:
        return delete_administrator(admin_id)
    except mariadb.Error as e:
        raise HTTPException(status_code=400, detail=str(e)) 