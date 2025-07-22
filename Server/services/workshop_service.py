from fastapi import HTTPException
import mariadb
from crud.workshop import get_workshops, create_workshop, update_workshop, delete_workshop, set_state_workshop
from schemas.workshop.workshop_in import WorkshopIn
from schemas.workshop.workshop_out import WorkshopOut

def get_all_workshops_service(semester=None, year=None, available=None, id_workshop_state=None):
    try:
        rows = get_workshops(semester, year, available, id_workshop_state)
        return [WorkshopOut(**row) for row in rows]
    except mariadb.Error as e:
        raise HTTPException(status_code=500, detail=str(e))

def create_workshop_service(workshop: WorkshopIn):
    try:
        return create_workshop(workshop.dict())
    except mariadb.Error as e:
        raise HTTPException(status_code=400, detail=str(e))

def update_workshop_service(workshop_id: int, workshop: WorkshopIn):
    try:
        return update_workshop(workshop_id, workshop.dict())
    except mariadb.Error as e:
        raise HTTPException(status_code=400, detail=str(e))

def delete_workshop_service(workshop_id: int):
    try:
        return delete_workshop(workshop_id)
    except mariadb.Error as e:
        raise HTTPException(status_code=400, detail=str(e))

def set_state_workshop_service(workshop_id: int, new_state_id: int, new_inscription_start_date: str, new_inscription_end_date: str, new_course_start_date: str, new_course_end_date: str):
    try:
        return set_state_workshop(workshop_id, new_state_id, new_inscription_start_date, new_inscription_end_date, new_course_start_date, new_course_end_date)
    except mariadb.Error as e:
        raise HTTPException(status_code=400, detail=str(e)) 