from pydantic import BaseModel
from .convalidation_subject_out import ConvalidationSubjectOut
from .convalidation_workshop_out import ConvalidationWorkshopOut
from .convalidation_external_activity_out import ConvalidationExternalActivityOut

class ConvalidationOut(BaseModel):
    subject: ConvalidationSubjectOut
    workshop: ConvalidationWorkshopOut
    external_activity: ConvalidationExternalActivityOut 