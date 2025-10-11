"""
CORS Middleware
Configuración de Cross-Origin Resource Sharing
Sistema: SGSCT
"""
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from src.app.settings import get_settings

settings = get_settings()


def setup_cors(app: FastAPI) -> None:
    """
    Configura CORS para permitir requests desde el frontend.
    
    Permite requests desde:
    - ALLOWED_ORIGINS (configurado en settings)
    - CORS_ORIGINS (adicionales para producción)
    - Localhost explícito para desarrollo
    """
    
    # Usar configuración existente de ALLOWED_ORIGINS
    origins = settings.ORIGINS_LIST.copy()
    
    
    # Combinar sin duplicados
    origins = list(set(origins))
    
    # Agregar CORS_ORIGINS adicionales si existen
    if settings.CORS_ORIGINS:
        additional = [o.strip() for o in settings.CORS_ORIGINS.split(",") if o.strip()]
        origins.extend(additional)
    
    app.add_middleware(
        CORSMiddleware,
        allow_origins=origins,
        allow_credentials=True,
        allow_methods=["GET", "POST", "PUT", "DELETE", "PATCH", "OPTIONS"],
        allow_headers=["*"],
        expose_headers=["X-Request-ID"],
        max_age=3600,
    )
