# CREATE TABLE WORKSHOPS_INSCRIPTIONS (
#     id INT AUTO_INCREMENT NOT NULL,
#     id_student INT NOT NULL,
#     id_workshop INT NOT NULL,
#     id_curriculum_course INT NOT NULL,
#     is_convalidated BOOLEAN NOT NULL DEFAULT FALSE,
#     PRIMARY KEY (id),
#     FOREIGN KEY (id_student) REFERENCES STUDENTS (id),
#     FOREIGN KEY (id_workshop) REFERENCES WORKSHOPS (id),
#     FOREIGN KEY (id_curriculum_course) REFERENCES CURRICULUM_COURSES (id)
# );
from pydantic import BaseModel

class WorkshopsInscriptionsBase(BaseModel):
    id : int
    id_student: int
    id_workshop: int
    id_curriculum_course: int
    is_convalidated: bool

#isnert

class WorkshopsInscriptionsPost(BaseModel):
    id_student: int
    id_workshop: int
    id_curriculum_course: int
    is_convalidated: bool

#update

class WorkshopsInscriptionsResponse(BaseModel):
    id : int
    id_student: int
    id_workshop: int
    id_curriculum_course: int
    is_convalidated: bool
