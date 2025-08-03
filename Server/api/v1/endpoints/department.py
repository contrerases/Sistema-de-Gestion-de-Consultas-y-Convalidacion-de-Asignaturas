from fastapi import APIRouter, status
from typing import List
from schemas.department.department_in import DepartmentIn
from schemas.department.department_out import DepartmentOut
from services.department_service import (
    get_all_departments_service,
    create_department_service,
    update_department_service,
    delete_department_service
)

router = APIRouter(prefix="/departments", tags=["departments"])

@router.get("/", response_model=List[DepartmentOut])
def get_departments():
    """Obtiene lista de departamentos"""
    return get_all_departments_service()

@router.get("/{id_department}", response_model=DepartmentOut)
def get_department_by_id(id_department: int):
    """Obtiene un departamento específico por ID"""
    return get_all_departments_service()

@router.post("/", response_model=bool, status_code=status.HTTP_201_CREATED)
def create_department(department: DepartmentIn):
    """Crea un nuevo departamento"""
    return create_department_service(department)

@router.put("/{id_department}", response_model=bool)
def update_department(id_department: int, department: DepartmentIn):
    """Actualiza un departamento existente"""
    return update_department_service(id_department, department)

@router.delete("/{id_department}", response_model=bool)
def delete_department(id_department: int):
    """Elimina un departamento"""
    return delete_department_service(id_department) 