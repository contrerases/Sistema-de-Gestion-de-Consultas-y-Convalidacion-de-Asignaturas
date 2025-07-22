from fastapi import HTTPException
import mariadb
from crud.workshop_inscription import get_workshops_inscriptions, create_workshop_inscription, cancel_workshop_inscription, unregister_workshop_after_start
from schemas.workshop_inscription.workshop_inscription_in import WorkshopInscriptionIn
from schemas.workshop_inscription.workshop_inscription_out import WorkshopInscriptionOut

def get_all_workshops_inscriptions_service(workshop_id=None, student_id=None, is_convalidated=None, curriculum_course_id=None):
    try:
        rows = get_workshops_inscriptions(workshop_id, student_id, is_convalidated, curriculum_course_id)
        return [WorkshopInscriptionOut(**row) for row in rows]
    except mariadb.Error as e:
        raise HTTPException(status_code=500, detail=str(e))

def create_workshop_inscription_service(inscription: WorkshopInscriptionIn):
    try:
        return create_workshop_inscription(inscription.dict())
    except mariadb.Error as e:
        raise HTTPException(status_code=400, detail=str(e))

def cancel_workshop_inscription_service(inscription_id: int, student_id: int):
    try:
        return cancel_workshop_inscription(inscription_id, student_id)
    except mariadb.Error as e:
        raise HTTPException(status_code=400, detail=str(e))

def unregister_workshop_after_start_service(workshop_id: int):
    try:
        return unregister_workshop_after_start(workshop_id)
    except mariadb.Error as e:
        raise HTTPException(status_code=400, detail=str(e)) 