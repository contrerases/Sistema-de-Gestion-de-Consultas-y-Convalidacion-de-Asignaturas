"""
Registro centralizado de modelos SQLAlchemy
Sistema: SGSCT

Este módulo importa todos los modelos para registrarlos con SQLAlchemy.
Debe importarse DESPUÉS de que todos los routers estén cargados para evitar imports circulares.
"""


def ensure_models_imported():
    """
    Asegura que todos los modelos estén importados para que SQLAlchemy
    pueda resolver las relaciones correctamente.
    
    Esta función debe llamarse en el startup de la aplicación.
    """
    # Importar todos los modelos aquí
    from src.modules.users.models import User, Professor  # noqa: F401
    from src.modules.auth.models import AuthUser  # noqa: F401
    from src.modules.workshops.models import Workshop  # noqa: F401
    from src.modules.workshops.inscriptions.models import WorkshopInscription  # noqa: F401
    from src.modules.workshops.grades.models import WorkshopGrade  # noqa: F401
    from src.modules.workshops.tokens.models import WorkshopToken  # noqa: F401
    from src.modules.convalidations.models import (  # noqa: F401
        Convalidation,
        ConvalidationWorkshop,
        ConvalidationSubject,
        ConvalidationExternalActivity
    )
    from src.modules.convalidations.requests.models import Request  # noqa: F401
    from src.modules.catalog.convalidation_types.models import ConvalidationType  # noqa: F401
    from src.modules.catalog.convalidation_states.models import ConvalidationState  # noqa: F401
    from src.modules.catalog.workshop_states.models import WorkshopState  # noqa: F401
    from src.modules.academic.subjects.models import Subject  # noqa: F401
    from src.modules.academic.departments.models import Department  # noqa: F401
    from src.modules.academic.curriculum_courses_slots.models import CurriculumCourseSlot  # noqa: F401
    from src.modules.catalog.campus.models import Campus  # noqa: F401
