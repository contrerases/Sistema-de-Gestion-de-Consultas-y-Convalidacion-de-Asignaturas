from pydantic import BaseModel

class WorkshopsGradesBase(BaseModel):
    id_student: int
    id_workshop: int
    grade: int

class WorkshopsGradesPost(WorkshopsGradesBase):
    pass

class WorkshopsGradesResponse(WorkshopsGradesBase):
    pass