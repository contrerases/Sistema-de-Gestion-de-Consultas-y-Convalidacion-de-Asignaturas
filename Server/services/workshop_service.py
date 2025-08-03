from fastapi import HTTPException
import mariadb
from crud.workshop import (
    get_workshops,
    get_workshops_by_state,
    get_workshops_by_professor,
    search_workshops,
    get_workshop_by_id,
    create_workshop,
    update_workshop,
    delete_workshop,
    change_workshop_state
)
from schemas.workshop.workshop_in import WorkshopIn
from schemas.workshop.workshop_out import WorkshopOut


# =============================================================================
# SERVICIOS DE TALLERES
# =============================================================================

def get_all_workshops_service():
    """Obtiene lista de talleres con datos mínimos para preview"""
    try:
        rows = get_workshops()
        return [WorkshopOut(**row) for row in rows]
    except mariadb.Error as e:
        raise HTTPException(status_code=500, detail=str(e))

def get_workshops_by_state_service(id_workshop_state: int):
    """Obtiene talleres por estado con datos mínimos"""
    try:
        rows = get_workshops_by_state(id_workshop_state)
        return [WorkshopOut(**row) for row in rows]
    except mariadb.Error as e:
        raise HTTPException(status_code=500, detail=str(e))

def get_workshops_by_professor_service(id_professor: int):
    """Obtiene talleres por profesor con datos mínimos"""
    try:
        rows = get_workshops_by_professor(id_professor)
        return [WorkshopOut(**row) for row in rows]
    except mariadb.Error as e:
        raise HTTPException(status_code=500, detail=str(e))

def search_workshops_service(search_term: str):
    """Busca talleres por término de búsqueda con datos mínimos"""
    try:
        rows = search_workshops(search_term)
        return [WorkshopOut(**row) for row in rows]
    except mariadb.Error as e:
        raise HTTPException(status_code=500, detail=str(e))

def get_workshop_by_id_service(id_workshop: int):
    """Obtiene un taller específico con datos completos"""
    try:
        result = get_workshop_by_id(id_workshop)
        return WorkshopOut(**result) if result else None
    except mariadb.Error as e:
        raise HTTPException(status_code=500, detail=str(e))

def create_workshop_service(workshop: WorkshopIn):
    """Crea un nuevo taller"""
    try:
        return create_workshop(
            workshop.name,
            workshop.semester,
            workshop.year,
            workshop.professor,
            workshop.description,
            workshop.inscription_start_date,
            workshop.inscription_end_date,
            workshop.course_start_date,
            workshop.course_end_date,
            workshop.available,
            workshop.limit_inscriptions,
            workshop.id_workshop_state
        )
    except mariadb.Error as e:
        raise HTTPException(status_code=400, detail=str(e))

def update_workshop_service(id_workshop: int, workshop: WorkshopIn):
    """Actualiza un taller existente"""
    try:
        return update_workshop(
            id_workshop,
            workshop.name,
            workshop.semester,
            workshop.year,
            workshop.professor,
            workshop.description,
            workshop.inscription_start_date,
            workshop.inscription_end_date,
            workshop.course_start_date,
            workshop.course_end_date,
            workshop.available,
            workshop.limit_inscriptions,
            workshop.id_workshop_state
        )
    except mariadb.Error as e:
        raise HTTPException(status_code=400, detail=str(e))

def delete_workshop_service(id_workshop: int):
    """Elimina un taller"""
    try:
        return delete_workshop(id_workshop)
    except mariadb.Error as e:
        raise HTTPException(status_code=400, detail=str(e))

def change_workshop_state_service(id_workshop: int, workshop: WorkshopIn):
    """Cambia el estado de un taller"""
    try:
        return change_workshop_state(
            id_workshop,
            workshop.id_workshop_state,
            workshop.inscription_start_date,
            workshop.inscription_end_date,
            workshop.course_start_date,
            workshop.course_end_date
        )
    except mariadb.Error as e:
        raise HTTPException(status_code=400, detail=str(e)) 