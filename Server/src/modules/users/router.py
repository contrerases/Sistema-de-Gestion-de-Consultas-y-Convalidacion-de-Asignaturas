"""
Router principal del módulo Users
Incluye subrouters de administrators, students y professors
Sistema: SGSCT
"""

from fastapi import APIRouter
from src.modules.users.administrators.router import router as administrators_router
from src.modules.users.students.router import router as students_router
from src.modules.users.professors.router import router as professors_router
from src.modules.users.types.router import router as types_router
from src.modules.users.base.router import router as users_router


router = APIRouter(prefix="/users", tags=["Usuarios"])

router.include_router(administrators_router)
router.include_router(students_router)
router.include_router(professors_router)
router.include_router(users_router)
router.include_router(types_router)
