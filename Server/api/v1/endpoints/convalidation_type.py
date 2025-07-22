from fastapi import APIRouter
from services.convalidation_type_service import get_all_convalidation_types_service
from schemas.convalidation_type.type_out import ConvalidationTypeOut
from typing import List

router = APIRouter(prefix="/convalidation-types", tags=["convalidation-types"])

@router.get("/", response_model=List[ConvalidationTypeOut])
def get_all_convalidation_types():
    return get_all_convalidation_types_service() 