from fastapi import APIRouter, status
from typing import List
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
    """Obtiene lista de talleres"""
    return get_all_workshops_service()

@router.get("/{id_workshop}", response_model=WorkshopOut)
def get_workshop_by_id(id_workshop: int):
    """Obtiene un taller específico por ID"""
    return get_workshop_by_id_service(id_workshop)

@router.get("/state/{id_workshop_state}", response_model=List[WorkshopOut])
def get_workshops_by_state(id_workshop_state: int):
    """Obtiene talleres por estado"""
    return get_workshops_by_state_service(id_workshop_state)

@router.get("/professor/{professor}", response_model=List[WorkshopOut])
def get_workshops_by_professor(professor: str):
    """Obtiene talleres por profesor"""
    return get_workshops_by_professor_service(professor)

@router.post("/search/", response_model=List[WorkshopOut])
def search_workshops(search_data: WorkshopSearch):
    """Busca talleres según criterios"""
    return search_workshops_service(search_data)

@router.post("/change-state/{id_workshop}", response_model=bool)
def change_workshop_state(id_workshop: int, workshop: WorkshopIn):
    """Cambia el estado de un taller"""
    return change_workshop_state_service(id_workshop, workshop)

@router.put("/{id_workshop}", response_model=bool)
def update_workshop(id_workshop: int, workshop: WorkshopIn):
    """Actualiza un taller existente"""
    return update_workshop_service(id_workshop, workshop)

@router.delete("/{id_workshop}", response_model=bool)
def delete_workshop(id_workshop: int):
    """Elimina un taller"""
    return delete_workshop_service(id_workshop) 