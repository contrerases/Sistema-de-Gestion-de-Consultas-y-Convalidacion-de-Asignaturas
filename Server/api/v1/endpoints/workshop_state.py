from fastapi import APIRouter
from typing import List
from schemas.workshop_state.state_out import StateOut
from services.workshop_state_service import get_all_workshop_states_service

router = APIRouter(prefix="/workshop-states", tags=["workshop-states"])

@router.get("/", response_model=List[StateOut])
def get_workshop_states():
    """Obtiene lista de estados de talleres"""
    return get_all_workshop_states_service() 