from fastapi import APIRouter, status
from typing import List
from schemas.student.student_in import StudentIn
from schemas.student.student_out import StudentOut
from services.student_service import (
    get_all_students_service,
    get_student_by_id_service,
    get_student_by_rut_service,
    get_student_by_name_service,
    get_student_by_rol_service,
    create_student_service,
    update_student_service,
    delete_student_service
)

router = APIRouter(prefix="/students", tags=["students"])

@router.get("/", response_model=List[StudentOut])
def get_students():
    return get_all_students_service()

@router.get("/{id_student}", response_model=StudentOut)
def get_student_by_id(id_student: int):
    return get_student_by_id_service(id_student)

@router.get("/rut/{rut_student}", response_model=StudentOut)
def get_student_by_rut(rut_student: str):
    return get_student_by_rut_service(rut_student)

@router.get("/name/{first_names}", response_model=List[StudentOut])
def get_student_by_name(first_names: str):
    return get_student_by_name_service(first_names)

@router.get("/rol/{rol_student}", response_model=StudentOut)
def get_student_by_rol(rol_student: str):
    return get_student_by_rol_service(rol_student)

@router.post("/", response_model=bool, status_code=status.HTTP_201_CREATED)
def create_student(student: StudentIn):
    return create_student_service(student)

@router.put("/{id_student}", response_model=bool)
def update_student(id_student: int, student: StudentIn):
    return update_student_service(id_student, student)

@router.delete("/{id_student}", response_model=bool)
def delete_student(id_student: int):
    return delete_student_service(id_student) 