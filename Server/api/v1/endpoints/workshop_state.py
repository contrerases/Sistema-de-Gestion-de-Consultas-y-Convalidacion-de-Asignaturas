from fastapi import APIRouter
from services.workshop_state_service import get_all_workshop_states_service
from schemas.workshop_state.state_out import WorkshopStateOut
from typing import List

router = APIRouter(prefix="/workshop-states", tags=["workshop-states"])

@router.get("/", response_model=List[WorkshopStateOut])
def get_all_workshop_states():
    return get_all_workshop_states_service() 