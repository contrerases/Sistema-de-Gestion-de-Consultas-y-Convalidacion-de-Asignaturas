from fastapi import HTTPException
import mariadb
from crud.convalidation_type import get_convalidation_types
from schemas.convalidation_type.type_out import ConvalidationTypeOut
from typing import List

def get_all_convalidation_types_service() -> List[ConvalidationTypeOut]:
    """Obtiene lista de tipos de convalidación"""
    try:
        rows = get_convalidation_types()
        return [ConvalidationTypeOut(**row) for row in rows]
    except mariadb.Error as e:
        raise HTTPException(status_code=500, detail=str(e)) 