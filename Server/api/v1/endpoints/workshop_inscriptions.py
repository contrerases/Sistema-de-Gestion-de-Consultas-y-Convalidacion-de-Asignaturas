from fastapi import APIRouter, status
from typing import List
from schemas.workshop_inscription.workshop_inscription_in import WorkshopInscriptionIn
from schemas.workshop_inscription.workshop_inscription_out import WorkshopInscriptionOut
from schemas.workshop_inscription.workshop_inscription_filter_in import WorkshopInscriptionFilterIn
from services.workshop_inscription_service import (
    get_all_workshops_inscriptions_service,
    create_workshop_inscription_service,
    cancel_workshop_inscription_service,
    unregister_workshop_after_start_service
)

router = APIRouter(prefix="/workshop-inscriptions", tags=["workshop-inscriptions"])

@router.post("/filter", response_model=List[WorkshopInscriptionOut])
def filter_workshop_inscriptions(filters: WorkshopInscriptionFilterIn):
    return get_all_workshops_inscriptions_service(
        filters.id_workshop,
        filters.id_student,
        filters.is_convalidated,
        filters.id_curriculum_course
    )

@router.post("/", response_model=bool, status_code=status.HTTP_201_CREATED)
def create_workshop_inscription(inscription: WorkshopInscriptionIn):
    return create_workshop_inscription_service(inscription)

@router.delete("/desinscription/{inscription_id}", response_model=bool)
def desinscription_workshop(inscription_id: int, student_id: int):
    return cancel_workshop_inscription_service(inscription_id, student_id)

@router.delete("/drop-while-inscriptions/{workshop_id}", response_model=bool)
def drop_workshop_while_inscriptions(workshop_id: int):
    return unregister_workshop_after_start_service(workshop_id)

@router.get("/by-workshop/{workshop_id}", response_model=List[WorkshopInscriptionOut])
def get_inscriptions_by_workshop(workshop_id: int):
    return get_all_workshops_inscriptions_service(workshop_id=workshop_id)

@router.get("/by-student/{student_id}", response_model=List[WorkshopInscriptionOut])
def get_inscriptions_by_student(student_id: int):
    return get_all_workshops_inscriptions_service(student_id=student_id)

@router.get("/by-student-inscription/{student_id}", response_model=List[WorkshopInscriptionOut])
def get_inscriptions_by_student_inscription(student_id: int):
    return get_all_workshops_inscriptions_service(student_id=student_id) 