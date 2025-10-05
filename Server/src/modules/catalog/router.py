"""
Router principal del módulo catalog
Agrega routers de submódulos de catálogos
"""
from fastapi import APIRouter

# Importar routers cuando estén implementados
# from .workshop_states.router import router as workshop_states_router
# from .curriculum_course_types.router import router as course_types_router
# from .convalidation_types.router import router as convalidation_types_router
# from .convalidation_states.router import router as convalidation_states_router
# from .campus.router import router as campus_router
# from .user_types.router import router as user_types_router

router = APIRouter(prefix="/catalog", tags=["catalog"])

# Agregar routers cuando estén implementados
# router.include_router(workshop_states_router)
# router.include_router(course_types_router)
# router.include_router(convalidation_types_router)
# router.include_router(convalidation_states_router)
# router.include_router(campus_router)
# router.include_router(user_types_router)
