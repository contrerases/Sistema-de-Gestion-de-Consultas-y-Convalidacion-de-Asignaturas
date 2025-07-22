from fastapi import APIRouter, status, Query
from typing import Optional
from services.convalidation_service import (
    create_convalidation_service,
    get_convalidations_service,
    get_convalidation_by_student_service,
    get_convalidation_pending_service,
    review_convalidation_service
)
from schemas.convalidation.convalidation_create_in import ConvalidationCreateIn
from schemas.convalidation.convalidation_on import ConvalidationOn
from pydantic import BaseModel
from schemas.convalidation.review_convalidation_in import ReviewConvalidationIn

router = APIRouter(prefix="/convalidation", tags=["convalidation"])

@router.post("/", response_model=bool, status_code=status.HTTP_201_CREATED)
def create_convalidation(data: ConvalidationCreateIn):
    return create_convalidation_service(data)

@router.get("/", response_model=dict)
def get_convalidations(
    id_request: Optional[int] = Query(None),
    id_convalidation: Optional[int] = Query(None),
    id_convalidation_type: Optional[int] = Query(None),
    id_convalidation_state: Optional[int] = Query(None),
    id_curriculum_course: Optional[int] = Query(None),
    id_student: Optional[int] = Query(None),
    student_rol: Optional[str] = Query(None),
    student_rut: Optional[str] = Query(None),
    student_name: Optional[str] = Query(None),
    id_reviewed_by: Optional[int] = Query(None),
    id_workshop: Optional[int] = Query(None),
    id_subject: Optional[int] = Query(None),
    id_department: Optional[int] = Query(None),
    student_campus: Optional[str] = Query(None),
    activity_name: Optional[str] = Query(None)
):
    filters = ConvalidationOn(
        id_request=id_request,
        id_convalidation=id_convalidation,
        id_convalidation_type=id_convalidation_type,
        id_convalidation_state=id_convalidation_state,
        id_curriculum_course=id_curriculum_course,
        id_student=id_student,
        student_rol=student_rol,
        student_rut=student_rut,
        student_name=student_name,
        id_reviewed_by=id_reviewed_by,
        id_workshop=id_workshop,
        id_subject=id_subject,
        id_department=id_department,
        student_campus=student_campus,
        activity_name=activity_name
    )
    return get_convalidations_service(filters)

@router.get("/by-student", response_model=dict)
def get_convalidation_by_student(
    id_student: Optional[int] = Query(None),
    student_rol: Optional[str] = Query(None),
    student_rut: Optional[str] = Query(None) 
):
    return get_convalidation_by_student_service(id_student, student_rol, student_rut)

@router.get("/pending", response_model=dict)
def get_convalidation_pending():
    return get_convalidation_pending_service()

@router.post("/review", response_model=bool)
def review_convalidation(data: ReviewConvalidationIn):
    return review_convalidation_service(
        data.id_convalidation,
        data.id_convalidation_state,
        data.review_comments,
        data.id_reviewed_by
    ) 