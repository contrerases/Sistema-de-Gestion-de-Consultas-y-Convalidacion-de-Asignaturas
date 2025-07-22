from crud.workshop_state import get_all_workshop_states
from schemas.workshop_state.state_out import WorkshopStateOut
from typing import List
 
def get_all_workshop_states_service() -> List[WorkshopStateOut]:
    rows = get_all_workshop_states()
    return [WorkshopStateOut(**row) for row in rows] 