from fastapi import APIRouter, status
from typing import List
from schemas.department.department import DepartmentCreate, DepartmentUpdate, DepartmentOut
from services.department_service import (
    get_all_departments_service,
    get_department_by_id_service,
    create_department_service,
    update_department_service,
    delete_department_service
)

router = APIRouter(prefix="/departments", tags=["departments"])

@router.get("/", response_model=List[DepartmentOut])
def get_departments():
    return get_all_departments_service()

@router.get("/{department_id}", response_model=DepartmentOut)
def get_department_by_id(department_id: int):
    return get_department_by_id_service(department_id)

@router.post("/", response_model=bool, status_code=status.HTTP_201_CREATED)
def create_department(department: DepartmentCreate):
    return create_department_service(department)

@router.put("/{department_id}", response_model=bool)
def update_department(department_id: int, department: DepartmentUpdate):
    return update_department_service(department_id, department)

@router.delete("/{department_id}", response_model=bool)
def delete_department(department_id: int):
    return delete_department_service(department_id) 