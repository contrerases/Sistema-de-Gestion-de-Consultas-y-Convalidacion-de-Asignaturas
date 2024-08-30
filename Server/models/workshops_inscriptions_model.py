
from typing import Optional
from pydantic import BaseModel

class WorkshopsInscriptionsBase(BaseModel):
    id : int
    id_student: int
    id_workshop: int
    id_curriculum_course: Optional[int] = None
    is_convalidated: bool

#isnert

class WorkshopsInscriptionsPost(BaseModel):
    id_student: int
    id_workshop: int
    id_curriculum_course: Optional[int] = None
    is_convalidated: bool

#update

class WorkshopsInscriptionsResponse(BaseModel):
    id : int
    id_student: int
    name_student: str #Nombre Apellido
    rut_student: str
    id_workshop: int
    workshop: str
    id_curriculum_course: Optional[int] = None
    curriculum_course: Optional[str] = None
    is_convalidated: bool
