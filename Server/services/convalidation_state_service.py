from crud.convalidation_state import get_all_convalidation_states
from schemas.convalidation_state.state_out import ConvalidationStateOut
from typing import List
 
def get_all_convalidation_states_service() -> List[ConvalidationStateOut]:
    rows = get_all_convalidation_states()
    return [ConvalidationStateOut(**row) for row in rows] 