from fastapi import HTTPException
import mariadb
from crud.department import get_departments, create_department, update_department, delete_department
from schemas.department.department import DepartmentCreate, DepartmentUpdate, DepartmentOut

def get_all_departments_service():
    try:
        rows = get_departments()
        return [DepartmentOut(**row) for row in rows]
    except mariadb.Error as e:
        raise HTTPException(status_code=500, detail=str(e))

def get_department_by_id_service(department_id: int):
    try:
        rows = get_departments(department_id)
        if not rows:
            raise HTTPException(status_code=404, detail="Departamento no encontrado")
        return DepartmentOut(**rows[0])
    except mariadb.Error as e:
        raise HTTPException(status_code=500, detail=str(e))

def create_department_service(department: DepartmentCreate):
    try:
        return create_department(department.name)
    except mariadb.Error as e:
        raise HTTPException(status_code=400, detail=str(e))

def update_department_service(department_id: int, department: DepartmentUpdate):
    try:
        return update_department(department_id, department.name)
    except mariadb.Error as e:
        raise HTTPException(status_code=400, detail=str(e))

def delete_department_service(department_id: int):
    try:
        return delete_department(department_id)
    except mariadb.Error as e:
        raise HTTPException(status_code=400, detail=str(e)) 