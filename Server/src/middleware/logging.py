"""
Logging Middleware
Log automático de requests y responses
Sistema: SGSCT
"""
import time
from starlette.middleware.base import BaseHTTPMiddleware
from starlette.requests import Request
from starlette.responses import Response
from src.monitoring.logging import get_logger

logger = get_logger(__name__)


class LoggingMiddleware(BaseHTTPMiddleware):
    """
    Middleware para logging automático de requests y responses.
    
    Registra:
    - Inicio de request (método, path, cliente)
    - Fin de request (status code, duración)
    - Request ID para correlación de logs
    """
    
    async def dispatch(self, request: Request, call_next) -> Response:
        start_time = time.time()
        request_id = getattr(request.state, "request_id", "N/A")
        
        logger.info(
            f"Request started: {request.method} {request.url.path}",
            extra={
                "request_id": request_id,
                "method": request.method,
                "path": request.url.path,
                "query_params": str(request.query_params),
                "client_host": request.client.host if request.client else "unknown",
            }
        )
        
        response = await call_next(request)
        
        duration_ms = round((time.time() - start_time) * 1000, 2)
        
        log_level = "info"
        if response.status_code >= 500:
            log_level = "error"
        elif response.status_code >= 400:
            log_level = "warning"
        
        log_message = f"Request completed: {request.method} {request.url.path} - {response.status_code}"
        
        getattr(logger, log_level)(
            log_message,
            extra={
                "request_id": request_id,
                "method": request.method,
                "path": request.url.path,
                "status_code": response.status_code,
                "duration_ms": duration_ms,
            }
        )
        
        return response
