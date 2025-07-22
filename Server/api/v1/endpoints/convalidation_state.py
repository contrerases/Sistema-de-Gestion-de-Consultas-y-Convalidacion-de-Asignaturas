from fastapi import APIRouter
from services.convalidation_state_service import get_all_convalidation_states_service
from schemas.convalidation_state.state_out import ConvalidationStateOut
from typing import List

router = APIRouter(prefix="/convalidation-states", tags=["convalidation-states"])

@router.get("/", response_model=List[ConvalidationStateOut])
def get_all_convalidation_states():
    return get_all_convalidation_states_service() 