from fastapi import FastAPI, Request
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import JSONResponse
from src.core.config import Settings
from src.core.exceptions import CustomException
from src.api.v1.router import router as api_v1_router
from src.database.connection import Database


settings = Settings(env_file=".env.dev")

# Creación de la aplicación FastAPI
app = FastAPI(
    title="API Backend",
    description="Backend API con FastAPI y MariaDB",
    version="1.0.0",
    docs_url="/api/docs",
    redoc_url="/api/redoc",
    openapi_url="/api/openapi.json",
)

if __name__ == "__main__":
    import uvicorn

    uvicorn.run(
        "main:app",
        host=settings.BACKEND_HOST,
        port=settings.BACKEND_PORT,
        reload=settings.DEBUG,
    )
