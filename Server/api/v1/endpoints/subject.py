from fastapi import APIRouter, status
from typing import List
from schemas.subject.subject_response import SubjectOut
from schemas.subject.subject_create_in import SubjectCreateIn
from services.subject_service import (
    get_all_subjects_service,
    get_subject_by_id_service,
    create_subject_service,
    update_subject_service,
    delete_subject_service
)

router = APIRouter(prefix="/subjects", tags=["subjects"])

@router.get("/", response_model=List[SubjectOut])
def get_subjects():
    return get_all_subjects_service()

@router.get("/{subject_id}", response_model=SubjectOut)
def get_subject_by_id(subject_id: int):
    return get_subject_by_id_service(subject_id)

@router.post("/", response_model=bool, status_code=status.HTTP_201_CREATED)
def create_subject(subject: SubjectCreateIn):
    return create_subject_service(subject)

@router.put("/{subject_id}", response_model=bool)
def update_subject(subject_id: int, subject: SubjectCreateIn):
    return update_subject_service(subject_id, subject)

@router.delete("/{subject_id}", response_model=bool)
def delete_subject(subject_id: int):
    return delete_subject_service(subject_id) 