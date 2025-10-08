from fastapi import FastAPI, Request
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import JSONResponse
from fastapi.staticfiles import StaticFiles
from src.app.settings import Settings
from src.core.exceptions import SGSCTException
from src.api.v1.router import router as api_v1_router
from src.database.connection import DatabaseConnection
from src.core.handlers import register_exception_handlers
from src.core.file_config import verify_upload_directories


settings = Settings()

# Verificar estructura de directorios de archivos
verify_upload_directories()

# Creación de la aplicación FastAPI
app = FastAPI(
    title="Sistema de Gestión de Consultas y Convalidaciones - API",
    description="""
    ## Sistema de Gestión de Consultas y Convalidaciones de Talleres (SGSCT)
    
    API REST para la gestión académica y administrativa de:
    - 📚 **Módulo Academic**: Departamentos, Asignaturas, Cursos Curriculares
    - 📋 **Módulo Catalog**: Campus, Tipos de Usuario, Estados y Tipos de Convalidaciones y Talleres
    - 👤 **Módulo Auth**: Autenticación JWT, Gestión de Sesiones
    - 🎓 **Módulo Users**: Administración de Usuarios
    
    ### Tecnologías
    - **Framework**: FastAPI 0.104.1
    - **Base de Datos**: MariaDB 12.0.2
    - **ORM**: SQLAlchemy 2.0.23
    - **Autenticación**: JWT + Bcrypt
    
    ### Documentación
    - **Swagger UI**: [/api/docs](/api/docs)
    - **ReDoc**: [/api/redoc](/api/redoc)
    - **OpenAPI Schema**: [/api/openapi.json](/api/openapi.json)
    """,
    version="1.0.0",
    docs_url="/api/docs",
    redoc_url="/api/redoc",
    openapi_url="/api/openapi.json",
    contact={
        "name": "Equipo SGSCT",
        "email": "soporte@sgsct.cl",
    },
    license_info={
        "name": "MIT License",
    }
)

# Configurar CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=settings.ALLOWED_ORIGINS,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Registrar exception handlers con respuestas estandarizadas
register_exception_handlers(app)

# Montar directorio de archivos estáticos
app.mount("/files", StaticFiles(directory="file_uploads"), name="files")

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
        "message": "Bienvenido al Sistema de Gestión de Consultas y Convalidaciones de Talleres",
        "service": "SGSCT API",
        "version": "1.0.0",
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
