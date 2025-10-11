from fastapi import FastAPI, Request
from fastapi.responses import JSONResponse
from fastapi.staticfiles import StaticFiles
from src.app.settings import Settings
from src.core.exceptions import SGSCTException
from src.api.v1.router import router as api_v1_router
from src.database.connection import DatabaseConnection
from src.database.models_registry import ensure_models_imported
from src.core.handlers import register_exception_handlers
from src.core.file_config import verify_upload_directories
from src.middleware import (
    setup_cors,
    RequestIDMiddleware,
    LoggingMiddleware,
    SecurityHeadersMiddleware,
    RateLimitMiddleware,
    ErrorHandlerMiddleware
)


settings = Settings()

# Verificar estructura de directorios de archivos
verify_upload_directories()

# Creación de la aplicación FastAPI
app = FastAPI(
    title=f"{settings.NAME} - API",
    description=f"""
    ## {settings.NAME} {settings.ACRONYM}
    
    ### Tecnologías
    - **Framework**: FastAPI 0.104.1
    - **Base de Datos**: MariaDB 11.0.6
    - **ORM**: SQLAlchemy 2.0.23
    - **Autenticación**: JWT + Bcrypt
    
    ### Documentación
    - **Swagger UI**: [/api/docs](/api/docs)
    - **ReDoc**: [/api/redoc](/api/redoc)
    - **OpenAPI Schema**: [/api/openapi.json](/api/openapi.json)
    """,
    version=settings.VERSION,
    docs_url="/api/docs",
    redoc_url="/api/redoc",
    openapi_url="/api/openapi.json"
)

# ============================================================================
# MIDDLEWARES
# ORDEN IMPORTA: De más externo a más interno
# ============================================================================

# 1. CORS - Debe ser el primero para manejar preflight requests
setup_cors(app)

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

# Registrar exception handlers con respuestas estandarizadas
register_exception_handlers(app)

# Montar directorio de archivos estáticos
app.mount("/files", StaticFiles(directory="files"), name="files")

# Incluir router principal
app.include_router(api_v1_router)


@app.on_event("startup")
async def startup_event():
    """Eventos de inicio de la aplicación"""
    ensure_models_imported()


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
            "swagger": "/api/docs",
            "redoc": "/api/redoc",
            "openapi": "/api/openapi.json"
        },
        "endpoints": {
            "health": "/api/v1/health/",
            "auth": "/api/v1/auth/",
            "academic": "/api/v1/academic/",
            "catalog": "/api/v1/catalog/"
        }
    }

if __name__ == "__main__":
    import uvicorn

    uvicorn.run(
        "main:app",
        host=settings.BACKEND_HOST,
        port=settings.BACKEND_PORT,
        reload=settings.DEBUG,
    )
