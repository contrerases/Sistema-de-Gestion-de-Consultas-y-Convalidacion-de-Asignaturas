from fastapi import APIRouter, status
from typing import List
from schemas.workshop_grade.workshop_grade_in import WorkshopGradeIn
from schemas.workshop_grade.workshop_grade_out import WorkshopGradeOut
from services.workshop_grade_service import (
    get_all_workshop_grades_service,
    get_workshop_grade_by_id_service,
    get_workshop_grades_by_workshop_service,
    get_workshop_grades_by_student_service,
    create_workshop_grade_service,
    update_workshop_grade_service,
    delete_workshop_grade_service
)

router = APIRouter(prefix="/workshops-grades", tags=["workshops-grades"])

@router.get("/", response_model=List[WorkshopGradeOut])
def get_all_grades():
    return get_all_workshop_grades_service()

@router.get("/{id_grade}", response_model=WorkshopGradeOut)
def get_grade_by_id(id_grade: int):
    return get_workshop_grade_by_id_service(id_grade)

@router.get("/workshop/{id_workshop}", response_model=List[WorkshopGradeOut])
def get_grades_by_workshop(id_workshop: int):
    return get_workshop_grades_by_workshop_service(id_workshop)

@router.get("/student/{id_student}", response_model=List[WorkshopGradeOut])
def get_grades_by_student(id_student: int):
    return get_workshop_grades_by_student_service(id_student)

@router.post("/", response_model=bool, status_code=status.HTTP_201_CREATED)
def create_grade(grade: WorkshopGradeIn):
    return create_workshop_grade_service(grade)

@router.put("/{id_grade}", response_model=bool)
def update_grade(id_grade: int, grade: WorkshopGradeIn):
    return update_workshop_grade_service(id_grade, grade)

@router.delete("/{id_grade}", response_model=bool)
def delete_grade(id_grade: int):
    return delete_workshop_grade_service(id_grade) 