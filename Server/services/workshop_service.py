from fastapi import HTTPException
import mariadb
from crud.workshop import get_workshops, create_workshop, update_workshop, delete_workshop, change_workshop_state
from schemas.workshop.workshop_in import WorkshopIn
from schemas.workshop.workshop_out import WorkshopOut
from schemas.workshop.workshop_search import WorkshopSearch
from typing import Optional

def get_all_workshops_service():
    try:
        rows = get_workshops()
        return [WorkshopOut(**row) for row in rows]
    except mariadb.Error as e:
        raise HTTPException(status_code=500, detail=str(e))

def get_workshop_by_id_service(id_workshop: int):
    try:
        rows = get_workshops(id_workshop=id_workshop)
        return WorkshopOut(**rows[0]) if rows else None
    except mariadb.Error as e:
        raise HTTPException(status_code=500, detail=str(e))

def get_workshops_by_state_service(id_workshop_state: int):
    try:
        rows = get_workshops(id_workshop_state=id_workshop_state)
        return [WorkshopOut(**row) for row in rows]
    except mariadb.Error as e:
        raise HTTPException(status_code=500, detail=str(e))

def get_workshops_by_professor_service(professor: str):
    try:
        rows = get_workshops(professor=professor)
        return [WorkshopOut(**row) for row in rows]
    except mariadb.Error as e:
        raise HTTPException(status_code=500, detail=str(e))

def search_workshops_service(filters: WorkshopSearch):
    try:
        rows = get_workshops(**filters.dict())
        return [WorkshopOut(**row) for row in rows]
    except mariadb.Error as e:
        raise HTTPException(status_code=500, detail=str(e))

def create_workshop_service(workshop: WorkshopIn):
    try:
        return create_workshop(
            workshop.workshop,
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
    try:
        return update_workshop(
            id_workshop,
            workshop.workshop,
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
    try:
        return delete_workshop(id_workshop)
    except mariadb.Error as e:
        raise HTTPException(status_code=400, detail=str(e))

def change_workshop_state_service(workshop_id: int, new_state_id: int, new_inscription_start_date: str, new_inscription_end_date: str, new_course_start_date: str, new_course_end_date: str):
    try:
        return change_workshop_state(workshop_id, new_state_id, new_inscription_start_date, new_inscription_end_date, new_course_start_date, new_course_end_date)
    except mariadb.Error as e:
        raise HTTPException(status_code=400, detail=str(e)) 