from fastapi import APIRouter
from typing import List
from schemas.convalidation_state.state_out import StateOut
from services.convalidation_state_service import get_all_convalidation_states_service

router = APIRouter(prefix="/convalidation-states", tags=["convalidation-states"])

@router.get("/", response_model=List[StateOut])
def get_convalidation_states():
    """Obtiene lista de estados de convalidación"""
    return get_all_convalidation_states_service() 