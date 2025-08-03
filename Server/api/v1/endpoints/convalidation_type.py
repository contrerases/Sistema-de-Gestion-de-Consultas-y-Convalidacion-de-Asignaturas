from fastapi import APIRouter
from typing import List
from schemas.convalidation_type.type_out import TypeOut
from services.convalidation_type_service import get_all_convalidation_types_service

router = APIRouter(prefix="/convalidation-types", tags=["convalidation-types"])

@router.get("/", response_model=List[TypeOut])
def get_convalidation_types():
    """Obtiene lista de tipos de convalidación"""
    return get_all_convalidation_types_service() 