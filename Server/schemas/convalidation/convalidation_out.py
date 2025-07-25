from pydantic import BaseModel
from typing import Optional
from .convalidation_subject_out import ConvalidationSubjectOut
from .convalidation_workshop_out import ConvalidationWorkshopOut
from .convalidation_external_activity_out import ConvalidationExternalActivityOut

class ConvalidationOut(BaseModel):
    subject: Optional[ConvalidationSubjectOut]
    workshop: Optional[ConvalidationWorkshopOut]
    external: Optional[ConvalidationExternalActivityOut] 