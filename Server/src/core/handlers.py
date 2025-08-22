"""Manejadores de excepciones estandarizados para la API SGSCT"""

from fastapi import Request, HTTPException
from fastapi.exceptions import RequestValidationError
import logging

from .exceptions import (
    SGSCTException,
    NotFoundException,
    ConflictException,
    UnauthorizedException,
    ForbiddenException,
    DatabaseException,
    EmailException,
    AuthenticationException
)
from .responses import ErrorResponse, ValidationErrorResponse

logger = logging.getLogger(__name__)

# Manejadores para excepciones personalizadas
async def sgsct_exception_handler(request: Request, exc: SGSCTException) -> ErrorResponse:
    """Manejador para excepciones base SGSCT"""
    logger.error(f"SGSCT Exception: {exc.message} - Detail: {exc.detail}")
    
    return ErrorResponse(
        message=exc.message,
        errors=[exc.detail] if exc.detail else [exc.message],
        status_code=exc.status_code
    )

async def database_exception_handler(request: Request, exc: DatabaseException) -> ErrorResponse:
    """Manejador para excepciones de base de datos"""
    logger.error(f"Database Exception: {exc.message} - Detail: {exc.detail}")
    
    return ErrorResponse(
        message="Error interno del servidor",
        errors=["Ha ocurrido un error en la base de datos"],
        status_code=500
    )

# Manejadores para excepciones específicas
async def not_found_exception_handler(request: Request, exc: NotFoundException) -> ErrorResponse:
    """Manejador para excepciones de recurso no encontrado"""
    logger.info(f"Not Found: {exc.message}")
    
    return ErrorResponse(
        message=exc.message,
        errors=[exc.detail] if exc.detail else [exc.message],
        status_code=404
    )

async def unauthorized_exception_handler(request: Request, exc: UnauthorizedException) -> ErrorResponse:
    """Manejador para excepciones de no autorizado"""
    logger.warning(f"Unauthorized: {exc.message}")
    
    return ErrorResponse(
        message=exc.message,
        errors=[exc.detail] if exc.detail else [exc.message],
        status_code=401
    )

async def forbidden_exception_handler(request: Request, exc: ForbiddenException) -> ErrorResponse:
    """Manejador para excepciones de prohibido"""
    logger.warning(f"Forbidden: {exc.message}")
    
    return ErrorResponse(
        message=exc.message,
        errors=[exc.detail] if exc.detail else [exc.message],
        status_code=403
    )

async def conflict_exception_handler(request: Request, exc: ConflictException) -> ErrorResponse:
    """Manejador para excepciones de conflicto"""
    logger.warning(f"Conflict: {exc.message}")
    
    return ErrorResponse(
        message=exc.message,
        errors=[exc.detail] if exc.detail else [exc.message],
        status_code=409
    )

async def email_exception_handler(request: Request, exc: EmailException) -> ErrorResponse:
    """Manejador para excepciones de email"""
    logger.error(f"Email Exception: {exc.message}")
    
    return ErrorResponse(
        message="Error en el servicio de correo",
        errors=["No se pudo enviar el correo electrónico"],
        status_code=500
    )

async def authentication_exception_handler(request: Request, exc: AuthenticationException) -> ErrorResponse:
    """Manejador para excepciones de autenticación"""
    logger.warning(f"Authentication Exception: {exc.message}")
    
    return ErrorResponse(
        message=exc.message,
        errors=[exc.detail] if exc.detail else [exc.message],
        status_code=401
    )

# Manejadores para excepciones de FastAPI
async def fastapi_validation_exception_handler(request: Request, exc: RequestValidationError) -> ValidationErrorResponse:
    """Manejador para errores de validación de FastAPI"""
    logger.warning(f"FastAPI Validation Error: {exc.errors()}")
    
    # Extraer errores por campo
    field_errors = {}
    error_messages = []
    
    for error in exc.errors():
        field = '.'.join(str(loc) for loc in error['loc'][1:])  # Omitir 'body'
        message = error['msg']
        
        if field:
            field_errors[field] = message
        error_messages.append(f"{field}: {message}" if field else message)
    
    return ValidationErrorResponse(
        message="Error de validación en los datos enviados",
        errors=error_messages,
        field_errors=field_errors if field_errors else None,
        status_code=422
    )

async def http_exception_handler(request: Request, exc: HTTPException) -> ErrorResponse:
    """Manejador para excepciones HTTP de FastAPI"""
    logger.warning(f"HTTP Exception: {exc.status_code} - {exc.detail}")
    
    return ErrorResponse(
        message=str(exc.detail),
        errors=[str(exc.detail)],
        status_code=exc.status_code
    )

# Manejador general para excepciones no capturadas
async def general_exception_handler(request: Request, exc: Exception) -> ErrorResponse:
    """Manejador general para excepciones no capturadas"""
    logger.error(f"Unhandled Exception: {type(exc).__name__} - {str(exc)}", exc_info=True)
    
    return ErrorResponse(
        message="Error interno del servidor",
        errors=["Ha ocurrido un error inesperado"],
        status_code=500
    )
