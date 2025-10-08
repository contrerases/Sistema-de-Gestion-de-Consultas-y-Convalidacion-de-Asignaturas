"""
Exception handlers para la API
Sistema: SGSCT
"""
from fastapi import Request, status
from fastapi.responses import JSONResponse
from fastapi.exceptions import RequestValidationError
from sqlalchemy.exc import SQLAlchemyError, IntegrityError
from src.core.exceptions import (
    SGSCTException,
    NotFoundException,
    UnauthorizedException,
    ForbiddenException,
    ValidationException
)
from src.core.responses import error_response


async def app_exception_handler(request: Request, exc: SGSCTException) -> JSONResponse:
    """Handler para excepciones personalizadas de la aplicación"""
    return JSONResponse(
        status_code=exc.status_code,
        content=error_response(
            code=exc.error_code if hasattr(exc, 'error_code') else "APP_ERROR",
            message=exc.message,
            details=exc.details if hasattr(exc, 'details') else None
        )
    )


async def not_found_handler(request: Request, exc: NotFoundException) -> JSONResponse:
    """Handler para recursos no encontrados"""
    return JSONResponse(
        status_code=status.HTTP_404_NOT_FOUND,
        content=error_response(
            code="NOT_FOUND",
            message=exc.message
        )
    )


async def unauthorized_handler(request: Request, exc: UnauthorizedException) -> JSONResponse:
    """Handler para errores de autenticación"""
    return JSONResponse(
        status_code=status.HTTP_401_UNAUTHORIZED,
        content=error_response(
            code="UNAUTHORIZED",
            message=exc.message
        ),
        headers={"WWW-Authenticate": "Bearer"}
    )


async def forbidden_handler(request: Request, exc: ForbiddenException) -> JSONResponse:
    """Handler para acceso prohibido"""
    return JSONResponse(
        status_code=status.HTTP_403_FORBIDDEN,
        content=error_response(
            code="FORBIDDEN",
            message=exc.message
        )
    )


async def validation_exception_handler(request: Request, exc: ValidationException) -> JSONResponse:
    """Handler para errores de validación de negocio"""
    return JSONResponse(
        status_code=status.HTTP_422_UNPROCESSABLE_ENTITY,
        content=error_response(
            code="VALIDATION_ERROR",
            message=exc.message,
            details=exc.details
        )
    )


async def request_validation_handler(request: Request, exc: RequestValidationError) -> JSONResponse:
    """Handler para errores de validación de Pydantic"""
    errors = []
    for error in exc.errors():
        field = ".".join(str(loc) for loc in error["loc"][1:])  # Omitir 'body'
        errors.append({
            "field": field,
            "message": error["msg"],
            "type": error["type"]
        })
    
    return JSONResponse(
        status_code=status.HTTP_422_UNPROCESSABLE_ENTITY,
        content=error_response(
            code="VALIDATION_ERROR",
            message="Datos de entrada inválidos",
            details=errors
        )
    )


async def integrity_error_handler(request: Request, exc: IntegrityError) -> JSONResponse:
    """Handler para errores de integridad de BD"""
    message = "Error de integridad de datos"
    
    # Detectar tipo de error común
    error_str = str(exc.orig).lower()
    if "duplicate" in error_str or "unique" in error_str:
        message = "El registro ya existe"
    elif "foreign key" in error_str:
        message = "Referencia a registro inexistente"
    
    return JSONResponse(
        status_code=status.HTTP_409_CONFLICT,
        content=error_response(
            code="INTEGRITY_ERROR",
            message=message
        )
    )


async def sqlalchemy_error_handler(request: Request, exc: SQLAlchemyError) -> JSONResponse:
    """Handler para errores generales de SQLAlchemy"""
    return JSONResponse(
        status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
        content=error_response(
            code="DATABASE_ERROR",
            message="Error en la base de datos"
        )
    )


async def generic_exception_handler(request: Request, exc: Exception) -> JSONResponse:
    """Handler para excepciones no controladas"""
    return JSONResponse(
        status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
        content=error_response(
            code="INTERNAL_ERROR",
            message="Error interno del servidor"
        )
    )


def register_exception_handlers(app):
    """
    Registra todos los handlers de excepciones en la app
    
    Args:
        app: Instancia de FastAPI
    """
    app.add_exception_handler(SGSCTException, app_exception_handler)
    app.add_exception_handler(NotFoundException, not_found_handler)
    app.add_exception_handler(UnauthorizedException, unauthorized_handler)
    app.add_exception_handler(ForbiddenException, forbidden_handler)
    app.add_exception_handler(ValidationException, validation_exception_handler)
    app.add_exception_handler(RequestValidationError, request_validation_handler)
    app.add_exception_handler(IntegrityError, integrity_error_handler)
    app.add_exception_handler(SQLAlchemyError, sqlalchemy_error_handler)
    app.add_exception_handler(Exception, generic_exception_handler)
