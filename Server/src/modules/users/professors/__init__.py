"""
Submódulo Professors
Gestión de profesores
Sistema: SGSCT
"""

from .models import Professor
from .repository import ProfessorRepository
from .services import ProfessorServices
from .router import router as professors_router
from . import schemas

__all__ = [
    "Professor",
    "ProfessorRepository",
    "ProfessorServices",
    "professors_router",
    "schemas",
]
