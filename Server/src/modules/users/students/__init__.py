"""
Submódulo Students
Gestión de estudiantes
Sistema: SGSCT
"""

from .repository import StudentRepository
from .services import StudentServices
from .router import router as students_router
from .schemas import (
    StudentCreate,
    StudentUpdate,
    StudentResponse,
)

__all__ = [
    "StudentRepository",
    "StudentServices",
    "students_router",
    "StudentCreate",
    "StudentUpdate",
    "StudentResponse",
]
