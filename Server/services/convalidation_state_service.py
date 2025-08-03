from fastapi import HTTPException
import mariadb
from crud.convalidation_state import get_convalidation_states
from schemas.convalidation_state.state_out import ConvalidationStateOut
from typing import List

def get_all_convalidation_states_service() -> List[ConvalidationStateOut]:
    """Obtiene lista de estados de convalidación"""
    try:
        rows = get_convalidation_states()
        return [ConvalidationStateOut(**row) for row in rows]
    except mariadb.Error as e:
        raise HTTPException(status_code=500, detail=str(e)) 