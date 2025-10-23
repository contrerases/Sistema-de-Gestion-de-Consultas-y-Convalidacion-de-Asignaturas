"""
Error Handler Middleware
Manejo centralizado de errores no capturados
Sistema: SGSCT
"""

from starlette.middleware.base import BaseHTTPMiddleware
from starlette.requests import Request
from starlette.responses import JSONResponse
from fastapi import status
from src.monitoring.logging import get_logger

logger = get_logger(__name__)


class ErrorHandlerMiddleware(BaseHTTPMiddleware):
    """
    Middleware para manejo centralizado de errores no capturados.

    Captura excepciones no manejadas y retorna respuestas JSON
    consistentes, registrando el error con información de contexto.
    """

    async def dispatch(self, request: Request, call_next):
        try:
            response = await call_next(request)
            return response
        except Exception as exc:
            return await self._handle_exception(request, exc)

    async def _handle_exception(self, request: Request, exc: Exception) -> JSONResponse:
        """Maneja la excepción y retorna respuesta JSON"""
        request_id = getattr(request.state, "request_id", "N/A")

        logger.error(
            f"Unhandled exception: {type(exc).__name__}",
            exc_info=exc,
            extra={
                "request_id": request_id,
                "path": request.url.path,
                "method": request.method,
                "client_host": request.client.host if request.client else "unknown",
                "exception_type": type(exc).__name__,
                "exception_message": str(exc),
            },
        )

        return JSONResponse(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            content={
                "message": "Internal server error",
                "detail": "An unexpected error occurred. Please try again later.",
                "request_id": request_id,
            },
        )
