from pydantic import BaseModel

class WorkshopGradeIn(BaseModel):
    id_workshop: int
    id_student: int
    grade: int 