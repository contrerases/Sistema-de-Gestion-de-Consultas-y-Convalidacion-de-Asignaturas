"""
Router principal API v1
Sistema: SGSCT
Agrega todos los routers de módulos
"""

from fastapi import APIRouter
from src.modules.academic.router import router as academics_router
from src.modules.users.router import router as users_router
from src.modules.auth.router import router as auth_router

# Otros routers globales
# from src.modules.workshops.router import router as workshops_router
# from src.modules.convalidations.router import router as convalidations_router
from src.monitoring.health import router as health_router

router = APIRouter(prefix="/api/v1")

# Routers agrupados por dominio
router.include_router(academics_router)  # /academics/{submodulo}
router.include_router(users_router)  # /users/{submodulo}
router.include_router(auth_router)  # /auth

# router.include_router(workshops_router)      # /workshops/{submodulo}
# router.include_router(convalidations_router) # /convalidations/{submodulo}
router.include_router(health_router)  # /health
