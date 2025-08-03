from fastapi import APIRouter, status
from typing import List
from schemas.workshop_inscription.workshop_inscription_in import WorkshopInscriptionIn
from schemas.workshop_inscription.workshop_inscription_out import WorkshopInscriptionOut
from services.workshop_inscription_service import (
    get_all_workshop_inscriptions_service,
    get_workshop_inscription_by_id_service,
    get_workshop_inscriptions_by_workshop_service,
    get_workshop_inscriptions_by_student_service,
    get_workshop_inscriptions_by_student_rut_service,
    get_workshop_inscriptions_by_student_name_service,
    get_workshop_inscriptions_by_student_rol_service,
    get_workshop_inscriptions_by_curriculum_course_service,
    create_workshop_inscription_service,
    cancel_workshop_inscription_service
)

router = APIRouter(prefix="/workshops-inscriptions", tags=["workshops-inscriptions"])

@router.get("/", response_model=List[WorkshopInscriptionOut])
def get_workshop_inscriptions():
    """Obtiene lista de inscripciones"""
    return get_all_workshop_inscriptions_service()

@router.get("/{id_inscription}", response_model=WorkshopInscriptionOut)
def get_workshop_inscription_by_id(id_inscription: int):
    """Obtiene una inscripción específica por ID"""
    return get_workshop_inscription_by_id_service(id_inscription)

@router.get("/workshop/{id_workshop}", response_model=List[WorkshopInscriptionOut])
def get_workshop_inscriptions_by_workshop(id_workshop: int):
    """Obtiene inscripciones de un taller específico"""
    return get_workshop_inscriptions_by_workshop_service(id_workshop)

@router.get("/student/{id_student}", response_model=List[WorkshopInscriptionOut])
def get_workshop_inscriptions_by_student(id_student: int):
    """Obtiene inscripciones de un estudiante"""
    return get_workshop_inscriptions_by_student_service(id_student)

@router.get("/student-rut/{student_rut}", response_model=List[WorkshopInscriptionOut])
def get_workshop_inscriptions_by_student_rut(student_rut: str):
    """Obtiene inscripciones por RUT del estudiante"""
    return get_workshop_inscriptions_by_student_rut_service(student_rut)

@router.get("/student-name/{student_name}", response_model=List[WorkshopInscriptionOut])
def get_workshop_inscriptions_by_student_name(student_name: str):
    """Obtiene inscripciones por nombre del estudiante"""
    return get_workshop_inscriptions_by_student_name_service(student_name)

@router.get("/student-rol/{student_rol}", response_model=List[WorkshopInscriptionOut])
def get_workshop_inscriptions_by_student_rol(student_rol: str):
    """Obtiene inscripciones por ROL del estudiante"""
    return get_workshop_inscriptions_by_student_rol_service(student_rol)

@router.get("/curriculum-course/{id_curriculum_course}", response_model=List[WorkshopInscriptionOut])
def get_workshop_inscriptions_by_curriculum_course(id_curriculum_course: int):
    """Obtiene inscripciones por curso curricular"""
    return get_workshop_inscriptions_by_curriculum_course_service(id_curriculum_course)

@router.post("/", response_model=bool, status_code=status.HTTP_201_CREATED)
def create_workshop_inscription(inscription: WorkshopInscriptionIn):
    """Crea una nueva inscripción a taller"""
    return create_workshop_inscription_service(inscription)

@router.delete("/cancel-inscription/{id_inscription}", response_model=bool)
def cancel_workshop_inscription(id_inscription: int):
    """Cancela una inscripción a taller"""
    return cancel_workshop_inscription_service(id_inscription) 