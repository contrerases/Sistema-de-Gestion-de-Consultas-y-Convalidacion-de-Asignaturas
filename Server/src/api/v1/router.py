"""
Router principal API v1
Sistema: SGSCT
Agrega todos los routers de módulos
"""
from fastapi import APIRouter

# Importar routers de módulos
from src.modules.academic.router import router as academic_router
from src.modules.catalog.router import router as catalog_router
from src.monitoring.health import router as health_router
from src.modules.auth.router import router as auth_router
from src.modules.workshops.router import router as workshops_router
from src.modules.convalidations.router import router as convalidations_router
from src.modules.users.router import router as users_router

router = APIRouter(prefix="/api/v1")

# Agregar routers de módulos
router.include_router(health_router)
router.include_router(auth_router)
router.include_router(academic_router)
router.include_router(catalog_router)
router.include_router(workshops_router)
router.include_router(convalidations_router)
router.include_router(users_router)
