from fastapi import APIRouter, status
from typing import List
from schemas.student.student_create_in import StudentCreateIn
from schemas.student.student_out import StudentOut
from services.student_service import (
    get_all_students_service,
    get_student_by_id_service,
    create_student_service,
    update_student_service,
    delete_student_service
)

router = APIRouter(prefix="/students", tags=["students"])

@router.get("/", response_model=List[StudentOut])
def get_students():
    return get_all_students_service()

@router.get("/{student_id}", response_model=StudentOut)
def get_student_by_id(student_id: int):
    return get_student_by_id_service(student_id)

@router.post("/", response_model=bool, status_code=status.HTTP_201_CREATED)
def create_student(student: StudentCreateIn):
    return create_student_service(student)

@router.put("/{student_id}", response_model=bool)
def update_student(student_id: int, student: StudentCreateIn):
    return update_student_service(student_id, student)

@router.delete("/{student_id}", response_model=bool)
def delete_student(student_id: int):
    return delete_student_service(student_id) 