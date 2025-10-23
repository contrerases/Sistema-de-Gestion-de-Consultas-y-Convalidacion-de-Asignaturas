from fastapi import FastAPI
from fastapi.staticfiles import StaticFiles
from src.app.settings import get_settings

import src.database.models_registry
from src.api.v1.router import router as api_v1_router


from src.core.file_config import verify_upload_directories

from src.middleware import (
    RequestIDMiddleware,
    LoggingMiddleware,
    SecurityHeadersMiddleware,
    RateLimitMiddleware,
    ErrorHandlerMiddleware,
)

from fastapi.middleware.cors import CORSMiddleware


settings = get_settings()

# Verificar estructura de directorios de archivos
verify_upload_directories()

# Creación de la aplicación FastAPI
app = FastAPI(
    title=f"{settings.NAME} - API",
    version=settings.VERSION,
    docs_url="/api/docs",
    redoc_url="/api/redoc",
    openapi_url="/api/openapi.json",
)

# ============================================================================
# MIDDLEWARES
# ORDEN IMPORTA: De más externo a más interno
# ============================================================================



# Configuración CORS usando settings.ORIGINS_LIST
app.add_middleware(
    CORSMiddleware,
    allow_origins=settings.ORIGINS_LIST,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"]
)

# 2. Error Handler - Captura todos los errores no manejados
app.add_middleware(ErrorHandlerMiddleware)

# 3. Security Headers - Agrega headers de seguridad HTTP
app.add_middleware(SecurityHeadersMiddleware)

# 4. Request ID - Genera ID único para trazabilidad
app.add_middleware(RequestIDMiddleware)

# 5. Logging - Log automático de requests/responses
app.add_middleware(LoggingMiddleware)

# 6. Rate Limiting - Limita requests por IP
app.add_middleware(RateLimitMiddleware, requests_per_minute=100)

# ============================================================================


# Montar directorio de archivos estáticos
app.mount("/files", StaticFiles(directory="files"), name="files")

# Incluir router principal
app.include_router(api_v1_router)


@app.get("/", tags=["Root"], summary="Ruta base - Información de la API")
async def root():
    """
    Endpoint de bienvenida que proporciona información básica de la API.

    Retorna:
    - Nombre del sistema
    - Versión de la API
    - Enlaces a documentación
    - Estado del servicio
    """
    return {
        "message": f"Bienvenido al {settings.NAME}",
        "service": "SGSCT API",
        "version": settings.VERSION,
        "status": "online",
        "environment": settings.ENVIRONMENT,
        "documentation": {
            "redoc": "/api/redoc",
            "openapi": "/api/openapi.json",
        },
        "endpoints": {
            "health": "/api/v1/health/",
            "auth": "/api/v1/auth/",
            "academic": "/api/v1/academic/",
            "catalog": "/api/v1/catalog/",
        },
    }


if __name__ == "__main__":
    import uvicorn

    uvicorn.run(
        "main:app",
        host=settings.BACKEND_HOST,
        port=settings.BACKEND_PORT,
        reload=settings.DEBUG,
    )
