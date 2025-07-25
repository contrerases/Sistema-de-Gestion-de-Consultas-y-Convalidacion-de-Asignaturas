from fastapi import APIRouter, status
from typing import List
from schemas.workshop_inscription.workshop_inscription_in import WorkshopInscriptionIn
from schemas.workshop_inscription.workshop_inscription_out import WorkshopInscriptionOut
from services.workshop_inscription_service import (
    get_all_workshops_inscriptions_service,
    get_workshop_inscription_by_id_service,
    get_workshops_inscriptions_by_workshop_service,
    get_workshops_inscriptions_by_student_service,
    get_workshops_inscriptions_by_student_rut_service,
    get_workshops_inscriptions_by_student_name_service,
    get_workshops_inscriptions_by_student_rol_service,
    get_workshops_inscriptions_by_curriculum_course_service,
    create_workshop_inscription_service,
    update_workshop_inscription_service,
    cancel_workshop_inscription_service
)

router = APIRouter(prefix="/workshops-inscriptions", tags=["workshops-inscriptions"])

@router.get("/", response_model=List[WorkshopInscriptionOut])
def get_all_inscriptions():
    return get_all_workshops_inscriptions_service()

@router.get("/{id_inscription}", response_model=WorkshopInscriptionOut)
def get_inscription_by_id(id_inscription: int):
    return get_workshop_inscription_by_id_service(id_inscription)

@router.get("/workshop/{id_workshop}", response_model=List[WorkshopInscriptionOut])
def get_inscriptions_by_workshop(id_workshop: int):
    return get_workshops_inscriptions_by_workshop_service(id_workshop)

@router.get("/student/{id_student}", response_model=List[WorkshopInscriptionOut])
def get_inscriptions_by_student(id_student: int):
    return get_workshops_inscriptions_by_student_service(id_student)

@router.get("/student-rut/{student_rut}", response_model=List[WorkshopInscriptionOut])
def get_inscriptions_by_student_rut(student_rut: str):
    return get_workshops_inscriptions_by_student_rut_service(student_rut)

@router.get("/student-name/{student_name}", response_model=List[WorkshopInscriptionOut])
def get_inscriptions_by_student_name(student_name: str):
    return get_workshops_inscriptions_by_student_name_service(student_name)

@router.get("/student-rol/{student_rol}", response_model=List[WorkshopInscriptionOut])
def get_inscriptions_by_student_rol(student_rol: str):
    return get_workshops_inscriptions_by_student_rol_service(student_rol)

@router.get("/curriculum-course/{id_curriculum_course}", response_model=List[WorkshopInscriptionOut])
def get_inscriptions_by_curriculum_course(id_curriculum_course: int):
    return get_workshops_inscriptions_by_curriculum_course_service(id_curriculum_course)

@router.post("/", response_model=bool, status_code=status.HTTP_201_CREATED)
def create_inscription(inscription: WorkshopInscriptionIn):
    return create_workshop_inscription_service(inscription)

@router.put("/{id_inscription}", response_model=bool)
def update_inscription(id_inscription: int, inscription: WorkshopInscriptionIn):
    return update_workshop_inscription_service(id_inscription, inscription)

@router.delete("/cancel-inscription/{id_inscription}", response_model=bool)
def cancel_inscription(id_inscription: int):
    return cancel_workshop_inscription_service(id_inscription) 