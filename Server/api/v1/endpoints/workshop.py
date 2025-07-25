from fastapi import APIRouter, status, Query
from typing import List, Optional
from schemas.workshop.workshop_in import WorkshopIn
from schemas.workshop.workshop_out import WorkshopOut
from schemas.workshop.workshop_search import WorkshopSearch
from services.workshop_service import (
    get_all_workshops_service,
    get_workshop_by_id_service,
    get_workshops_by_state_service,
    get_workshops_by_professor_service,
    search_workshops_service,
    create_workshop_service,
    update_workshop_service,
    delete_workshop_service,
    change_workshop_state_service
)

router = APIRouter(prefix="/workshops", tags=["workshops"])

@router.get("/", response_model=List[WorkshopOut])
def get_workshops():
    return get_all_workshops_service()

@router.get("/{id_workshop}", response_model=WorkshopOut)
def get_workshop_by_id(id_workshop: int):
    return get_workshop_by_id_service(id_workshop)

@router.get("/state/{id_workshop_state}", response_model=List[WorkshopOut])
def get_workshops_by_state(id_workshop_state: int):
    return get_workshops_by_state_service(id_workshop_state)

@router.get("/professor/{professor}", response_model=List[WorkshopOut])
def get_workshops_by_professor(professor: str):
    return get_workshops_by_professor_service(professor)

@router.post("/search/", response_model=List[WorkshopOut])
def search_workshops(filters: WorkshopSearch):
    return search_workshops_service(filters)

@router.post("/", response_model=bool)
def create_workshop(workshop: WorkshopIn):
    return create_workshop_service(workshop)

@router.post("/change-state/{id_workshop}", response_model=bool)
def change_state_workshop(id_workshop: int):
    return change_workshop_state_service(id_workshop)

@router.put("/{id_workshop}", response_model=bool)
def update_workshop(id_workshop: int, workshop: WorkshopIn):
    return update_workshop_service(id_workshop, workshop)

@router.delete("/{id_workshop}", response_model=bool)
def delete_workshop(id_workshop: int):
    return delete_workshop_service(id_workshop) 