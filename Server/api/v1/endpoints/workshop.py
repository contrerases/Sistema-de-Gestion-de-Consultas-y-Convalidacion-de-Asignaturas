from fastapi import APIRouter, status, Query
from typing import List, Optional
from schemas.workshop.workshop_in import WorkshopIn
from schemas.workshop.workshop_out import WorkshopOut
from services.workshop_service import (
    get_all_workshops_service,
    create_workshop_service,
    update_workshop_service,
    delete_workshop_service,
    set_state_workshop_service 
)

router = APIRouter(prefix="/workshops", tags=["workshops"])

@router.get("/", response_model=List[WorkshopOut])
def get_workshops(
    semester: Optional[str] = Query(None),
    year: Optional[int] = Query(None),
    available: Optional[bool] = Query(None),
    id_workshop_state: Optional[int] = Query(None)
):
    return get_all_workshops_service(semester, year, available, id_workshop_state)

@router.post("/", response_model=bool, status_code=status.HTTP_201_CREATED)
def create_workshop(workshop: WorkshopIn):
    return create_workshop_service(workshop)

@router.put("/{workshop_id}", response_model=bool)
def update_workshop(workshop_id: int, workshop: WorkshopIn):
    return update_workshop_service(workshop_id, workshop)

@router.delete("/{workshop_id}", response_model=bool)
def delete_workshop(workshop_id: int):
    return delete_workshop_service(workshop_id)

@router.put("/set-state/", response_model=bool)
def set_state_workshop(
    workshop_id: int,
    new_state_id: int,
    new_inscription_start_date: str,
    new_inscription_end_date: str,
    new_course_start_date: str,
    new_course_end_date: str
):
    return set_state_workshop_service(workshop_id, new_state_id, new_inscription_start_date, new_inscription_end_date, new_course_start_date, new_course_end_date)

@router.get("/by-student/{student_id}", response_model=List[WorkshopOut])
def get_workshops_by_student(student_id: int):
    return get_all_workshops_service(None, None, None, None)  # Aquí deberías filtrar por student_id en el service/CRUD

@router.get("/by-student-finished/{student_id}", response_model=List[WorkshopOut])
def get_workshops_by_student_finished(student_id: int):
    # Aquí deberías filtrar por student_id y estado FINALIZADO
    return get_all_workshops_service(None, None, None, None)

@router.get("/by-student-in-course/{student_id}", response_model=List[WorkshopOut])
def get_workshops_by_student_in_course(student_id: int):
    # Aquí deberías filtrar por student_id y estado EN_CURSO
    return get_all_workshops_service(None, None, None, None) 