from fastapi import APIRouter, status
from typing import List
from schemas.workshop.workshop_in import WorkshopIn
from schemas.workshop.workshop_out import WorkshopOut
from schemas.workshop.workshop_filter_in import WorkshopFilterIn
from services.workshop_service import (
    get_all_workshops_service,
    create_workshop_service,
    update_workshop_service,
    delete_workshop_service,
    set_state_workshop_service
)

router = APIRouter(prefix="/workshops", tags=["workshops"])

@router.post("/filter", response_model=List[WorkshopOut])
def filter_workshops(filters: WorkshopFilterIn):
    return get_all_workshops_service(filters)

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
def set_state_workshop(data: WorkshopFilterIn):
    return set_state_workshop_service(
        data.id_workshop,
        data.id_workshop_state,
        data.inscription_start_date,
        data.inscription_end_date,
        data.course_start_date,
        data.course_end_date
    ) 