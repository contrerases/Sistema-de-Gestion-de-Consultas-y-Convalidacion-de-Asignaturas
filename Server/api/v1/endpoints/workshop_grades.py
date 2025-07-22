from fastapi import APIRouter, status
from typing import List
from schemas.workshop_grade.workshop_grade_in import WorkshopGradeIn
from schemas.workshop_grade.workshop_grade_out import WorkshopGradeOut
from schemas.workshop_grade.workshop_grade_filter_in import WorkshopGradeFilterIn
from services.workshop_grade_service import (
    get_all_workshop_grades_service,
    create_workshop_grade_service
)

router = APIRouter(prefix="/workshop-grades", tags=["workshop-grades"])

@router.post("/filter", response_model=List[WorkshopGradeOut])
def filter_workshop_grades(filters: WorkshopGradeFilterIn):
    return get_all_workshop_grades_service(
        filters.id_workshop,
        filters.id_student,
        filters.min_grade,
        filters.max_grade
    )

@router.post("/", response_model=bool, status_code=status.HTTP_201_CREATED)
def create_workshop_grade(grade: WorkshopGradeIn):
    return create_workshop_grade_service(grade)

@router.get("/by-workshop/{workshop_id}", response_model=List[WorkshopGradeOut])
def get_grades_by_workshop(workshop_id: int):
    return get_all_workshop_grades_service(workshop_id=workshop_id)

@router.get("/by-student/{student_id}", response_model=List[WorkshopGradeOut])
def get_grades_by_student(student_id: int):
    return get_all_workshop_grades_service(student_id=student_id) 