from fastapi import APIRouter, status
from typing import List
from schemas.subject.subject_in import SubjectIn
from schemas.subject.subject_out import SubjectOut
from services.subject_service import (
    get_all_subjects_service,
    get_subjects_by_department_service,
    create_subject_service,
    update_subject_service,
    delete_subject_service
)

router = APIRouter(prefix="/subjects", tags=["subjects"])

@router.get("/", response_model=List[SubjectOut])
def get_subjects():
    """Obtiene lista de asignaturas"""
    return get_all_subjects_service()

@router.get("/{id_subject}", response_model=SubjectOut)
def get_subject_by_id(id_subject: int):
    """Obtiene una asignatura específica por ID"""
    return get_all_subjects_service()

@router.get("/department/{id_department}", response_model=List[SubjectOut])
def get_subjects_by_department(id_department: int):
    """Obtiene asignaturas por departamento"""
    return get_subjects_by_department_service(id_department)

@router.post("/", response_model=bool, status_code=status.HTTP_201_CREATED)
def create_subject(subject: SubjectIn):
    """Crea una nueva asignatura"""
    return create_subject_service(subject)

@router.put("/{id_subject}", response_model=bool)
def update_subject(id_subject: int, subject: SubjectIn):
    """Actualiza una asignatura existente"""
    return update_subject_service(id_subject, subject)

@router.delete("/{id_subject}", response_model=bool)
def delete_subject(id_subject: int):
    """Elimina una asignatura"""
    return delete_subject_service(id_subject) 