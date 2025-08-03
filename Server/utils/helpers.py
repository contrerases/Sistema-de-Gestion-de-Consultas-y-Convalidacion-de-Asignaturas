# Funciones auxiliares reutilizables en todo el proyecto. 

from schemas.convalidation.convalidation_out import ConvalidationOut
from schemas.convalidation.convalidation_subject_out import ConvalidationSubjectOut
from schemas.convalidation.convalidation_workshop_out import ConvalidationWorkshopOut
from schemas.convalidation.convalidation_external_activity_out import ConvalidationExternalActivityOut

def build_convalidation_out(row):
    """Construye el objeto de salida de convalidación según el tipo"""
    if row.get('id_subject'):
        return ConvalidationOut(subject=ConvalidationSubjectOut(**row), workshop=None, external=None)
    elif row.get('id_workshop'):
        return ConvalidationOut(subject=None, workshop=ConvalidationWorkshopOut(**row), external=None)
    elif row.get('id_activity_name'):
        return ConvalidationOut(subject=None, workshop=None, external=ConvalidationExternalActivityOut(**row))
    else:
        return ConvalidationOut(subject=None, workshop=None, external=None)