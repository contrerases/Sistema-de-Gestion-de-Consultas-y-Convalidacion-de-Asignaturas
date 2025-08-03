from fastapi import APIRouter, status
from typing import List
from schemas.convalidation.convalidation_in import ConvalidationIn
from schemas.convalidation.convalidation_out import ConvalidationOut
from schemas.convalidation.convalidation_search import ConvalidationSearch
from services.convalidation_service import (
    get_all_convalidations_service,
    get_convalidation_by_id_service,
    get_convalidations_by_student_service,
    get_convalidations_by_student_rut_service,
    get_convalidations_by_student_rol_service,
    get_convalidations_by_student_name_service,
    get_convalidations_by_reviewed_by_service,
    get_convalidations_by_curriculum_course_service,
    get_convalidations_by_workshop_service,
    get_convalidations_by_activity_service,
    get_convalidations_by_type_service,
    get_convalidations_by_state_service,
    filter_convalidations_service,
    create_convalidation_service,
    review_convalidation_service,
    drop_convalidation_while_no_reviewed_by_service
)

router = APIRouter(prefix="/convalidations", tags=["convalidations"])

@router.get("/", response_model=List[ConvalidationOut])
def get_convalidations():
    """Obtiene lista de convalidaciones"""
    return get_all_convalidations_service()

@router.get("/{id_convalidation}", response_model=ConvalidationOut)
def get_convalidation_by_id(id_convalidation: int):
    """Obtiene una convalidación específica por ID"""
    return get_convalidation_by_id_service(id_convalidation)

@router.get("/student/{id_student}", response_model=List[ConvalidationOut])
def get_convalidations_by_student(id_student: int):
    """Obtiene convalidaciones de un estudiante"""
    return get_convalidations_by_student_service(id_student)

@router.get("/student-rut/{student_rut}", response_model=List[ConvalidationOut])
def get_convalidations_by_student_rut(student_rut: str):
    """Obtiene convalidaciones por RUT del estudiante"""
    return get_convalidations_by_student_rut_service(student_rut)

@router.get("/student-rol/{student_rol}", response_model=List[ConvalidationOut])
def get_convalidations_by_student_rol(student_rol: str):
    """Obtiene convalidaciones por ROL del estudiante"""
    return get_convalidations_by_student_rol_service(student_rol)

@router.get("/student-name/{student_name}", response_model=List[ConvalidationOut])
def get_convalidations_by_student_name(student_name: str):
    """Obtiene convalidaciones por nombre del estudiante"""
    return get_convalidations_by_student_name_service(student_name)

@router.get("/reviewed-by/{id_reviewed_by}", response_model=List[ConvalidationOut])
def get_convalidations_by_reviewed_by(id_reviewed_by: int):
    """Obtiene convalidaciones revisadas por un administrador"""
    return get_convalidations_by_reviewed_by_service(id_reviewed_by)

@router.get("/curriculum-course/{id_curriculum_course}", response_model=List[ConvalidationOut])
def get_convalidations_by_curriculum_course(id_curriculum_course: int):
    """Obtiene convalidaciones por curso curricular"""
    return get_convalidations_by_curriculum_course_service(id_curriculum_course)

@router.get("/workshop/{id_workshop}", response_model=List[ConvalidationOut])
def get_convalidations_by_workshop(id_workshop: int):
    """Obtiene convalidaciones por taller"""
    return get_convalidations_by_workshop_service(id_workshop)

@router.get("/activity/{id_activity}", response_model=List[ConvalidationOut])
def get_convalidations_by_activity(id_activity: int):
    """Obtiene convalidaciones por actividad"""
    return get_convalidations_by_activity_service(id_activity)

@router.get("/type/{id_convalidation_type}", response_model=List[ConvalidationOut])
def get_convalidations_by_type(id_convalidation_type: int):
    """Obtiene convalidaciones por tipo"""
    return get_convalidations_by_type_service(id_convalidation_type)

@router.get("/state/{id_convalidation_state}", response_model=List[ConvalidationOut])
def get_convalidations_by_state(id_convalidation_state: int):
    """Obtiene convalidaciones por estado"""
    return get_convalidations_by_state_service(id_convalidation_state)

@router.post("/filter/", response_model=List[ConvalidationOut])
def filter_convalidations(filters: ConvalidationSearch):
    """Filtra convalidaciones según criterios específicos"""
    return filter_convalidations_service(filters)

@router.post("/", response_model=bool, status_code=status.HTTP_201_CREATED)
def create_convalidation(convalidation: ConvalidationIn):
    """Crea una nueva convalidación"""
    return create_convalidation_service(convalidation)

@router.put("/review/{id_convalidation}", response_model=bool)
def review_convalidation(id_convalidation: int, convalidation: ConvalidationIn):
    """Revisa una convalidación"""
    return review_convalidation_service(id_convalidation, convalidation)

@router.delete("/drop-while-no-reviewed-by/{id_convalidation}", response_model=bool)
def drop_convalidation_while_no_reviewed_by(id_convalidation: int):
    """Elimina una convalidación que no ha sido revisada"""
    return drop_convalidation_while_no_reviewed_by_service(id_convalidation) 