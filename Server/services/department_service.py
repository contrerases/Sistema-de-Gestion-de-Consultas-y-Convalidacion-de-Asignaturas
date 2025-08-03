from fastapi import HTTPException
import mariadb
from crud.department import get_departments, create_department, update_department, delete_department
from schemas.department.department_in import DepartmentIn
from schemas.department.department_out import DepartmentOut

def get_all_departments_service():
    """Obtiene lista de departamentos"""
    try:
        rows = get_departments()
        return [DepartmentOut(**row) for row in rows]
    except mariadb.Error as e:
        raise HTTPException(status_code=500, detail=str(e))

def get_department_by_id_service(id_department: int):
    try:
        rows = get_departments(id_department=id_department)
        return DepartmentOut(**rows[0]) if rows else None
    except mariadb.Error as e:
        raise HTTPException(status_code=500, detail=str(e))

def create_department_service(department: DepartmentIn):
    """Crea un nuevo departamento"""
    try:
        return create_department(department.name)
    except mariadb.Error as e:
        raise HTTPException(status_code=400, detail=str(e))

def update_department_service(id_department: int, department: DepartmentIn):
    """Actualiza un departamento existente"""
    try:
        return update_department(id_department, department.name)
    except mariadb.Error as e:
        raise HTTPException(status_code=400, detail=str(e))

def delete_department_service(id_department: int):
    """Elimina un departamento"""
    try:
        return delete_department(id_department)
    except mariadb.Error as e:
        raise HTTPException(status_code=400, detail=str(e)) 