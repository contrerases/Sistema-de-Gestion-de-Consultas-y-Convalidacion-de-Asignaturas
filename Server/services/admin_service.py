from typing import List, Optional
from fastapi import HTTPException
from schemas.admin.admin_in import AdminIn
from schemas.admin.admin_out import AdminOut
from crud.admin import create_admin as crud_create_admin, get_administrators as crud_get_administrators, update_admin as crud_update_admin, delete_admin as crud_delete_admin
import bcrypt
import mariadb

# Crear administrador
def create_admin_service(admin: AdminIn) -> bool:
    try:
        password_hash = bcrypt.hashpw(admin.password.encode('utf-8'), bcrypt.gensalt()).decode('utf-8')
        crud_create_admin(admin, password_hash)
        return True
    except mariadb.Error as e:
        raise HTTPException(status_code=400, detail=str(e))

# Obtener todos los admins
def get_all_admins_service() -> List[AdminOut]:
    try:
        rows = crud_get_administrators()
        return [AdminOut(**row) for row in rows]
    except mariadb.Error as e:
        raise HTTPException(status_code=500, detail=str(e))

# Obtener un admin por id
def get_admin_by_id_service(admin_id: int) -> AdminOut:
    try:
        rows = crud_get_administrators(id_admin=admin_id)
        if not rows:
            raise HTTPException(status_code=404, detail="Administrador no encontrado.")
        return AdminOut(**rows[0])
    except mariadb.Error as e:
        raise HTTPException(status_code=500, detail=str(e))

# Actualizar admin
def update_admin_service(admin_id: int, admin: AdminIn) -> bool:
    try:
        password_hash = bcrypt.hashpw(admin.password.encode('utf-8'), bcrypt.gensalt()).decode('utf-8') if admin.password else None
        crud_update_admin(admin_id, admin, password_hash)
        return True
    except mariadb.Error as e:
        raise HTTPException(status_code=400, detail=str(e))

# Eliminar admin
def delete_admin_service(admin_id: int) -> bool:
    try:
        crud_delete_admin(admin_id)
        return True
    except mariadb.Error as e:
        raise HTTPException(status_code=400, detail=str(e))

def get_admins_by_campus_service(campus: str):
    try:
        rows = crud_get_administrators(campus=campus)
        return [AdminOut(**row) for row in rows]
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

def get_admins_by_email_service(email: str):
    try:
        rows = crud_get_administrators(email=email)
        return [AdminOut(**row) for row in rows]
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e)) 