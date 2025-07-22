from crud.convalidation_type import get_all_convalidation_types
from schemas.convalidation_type.type_out import ConvalidationTypeOut
from typing import List
 
def get_all_convalidation_types_service() -> List[ConvalidationTypeOut]:
    rows = get_all_convalidation_types()
    return [ConvalidationTypeOut(**row) for row in rows] 