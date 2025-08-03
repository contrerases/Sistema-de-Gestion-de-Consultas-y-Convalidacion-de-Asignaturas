from fastapi import HTTPException
import mariadb
from crud.workshop_state import get_workshop_states
from schemas.workshop_state.state_out import WorkshopStateOut
from typing import List

def get_all_workshop_states_service() -> List[WorkshopStateOut]:
    """Obtiene lista de estados de talleres"""
    try:
        rows = get_workshop_states()
        return [WorkshopStateOut(**row) for row in rows]
    except mariadb.Error as e:
        raise HTTPException(status_code=500, detail=str(e)) 