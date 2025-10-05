from fastapi import FastAPI, Request
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import JSONResponse
from src.app.settings import Settings
from src.core.exceptions import SGSCTException
from src.api.v1.router import router as api_v1_router
from src.database.connection import Database


settings = Settings()

# Creación de la aplicación FastAPI
app = FastAPI(
    title="Sistema de Gestión de Consultas y Convalidaciones - API",
    description="Backend API con FastAPI y MariaDB",
    version="1.0.0",
    docs_url="/api/docs",
    redoc_url="/api/redoc",
    openapi_url="/api/openapi.json",
)

# Configurar CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=settings.ALLOWED_ORIGINS,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Handler de excepciones custom
@app.exception_handler(SGSCTException)
async def custom_exception_handler(request: Request, exc: SGSCTException):
    return JSONResponse(
        status_code=exc.status_code,
        content={"error": exc.message}
    )

# Incluir router principal
app.include_router(api_v1_router)

if __name__ == "__main__":
    import uvicorn

    uvicorn.run(
        "main:app",
        host=settings.BACKEND_HOST,
        port=settings.BACKEND_PORT,
        reload=settings.DEBUG,
    )
