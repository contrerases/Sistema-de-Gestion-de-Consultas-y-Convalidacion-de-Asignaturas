"""
Rate Limiting Middleware
Limitación de requests por cliente
Sistema: SGSCT
"""

import time
from collections import defaultdict
from typing import Dict, List
from fastapi import HTTPException, status
from starlette.middleware.base import BaseHTTPMiddleware
from starlette.requests import Request
from starlette.responses import Response
from src.monitoring.logging import get_logger

logger = get_logger(__name__)


class RateLimitMiddleware(BaseHTTPMiddleware):
    """
    Middleware para limitar el número de requests por cliente.

    Implementa rate limiting basado en IP del cliente:
    - Limita requests por minuto
    - Limpia automáticamente requests antiguos
    - Retorna HTTP 429 cuando se excede el límite
    """

    def __init__(self, app, requests_per_minute: int = 60):
        super().__init__(app)
        self.requests_per_minute = requests_per_minute
        self.requests: Dict[str, List[float]] = defaultdict(list)
        self.window_seconds = 60

    async def dispatch(self, request: Request, call_next) -> Response:
        if request.url.path in ["/docs", "/redoc", "/openapi.json", "/health"]:
            return await call_next(request)

        client_ip = self._get_client_ip(request)
        now = time.time()

        self._cleanup_old_requests(client_ip, now)

        if len(self.requests[client_ip]) >= self.requests_per_minute:
            logger.warning(
                f"Rate limit exceeded for IP: {client_ip}",
                extra={
                    "client_ip": client_ip,
                    "requests_count": len(self.requests[client_ip]),
                    "limit": self.requests_per_minute,
                },
            )
            raise HTTPException(
                status_code=status.HTTP_429_TOO_MANY_REQUESTS,
                detail={
                    "message": "Too many requests",
                    "retry_after": self._get_retry_after(client_ip, now),
                },
            )

        self.requests[client_ip].append(now)

        response = await call_next(request)
        response.headers["X-RateLimit-Limit"] = str(self.requests_per_minute)
        response.headers["X-RateLimit-Remaining"] = str(
            self.requests_per_minute - len(self.requests[client_ip])
        )

        return response

    def _get_client_ip(self, request: Request) -> str:
        """Obtiene la IP del cliente considerando proxies"""
        forwarded = request.headers.get("X-Forwarded-For")
        if forwarded:
            return forwarded.split(",")[0].strip()
        return request.client.host if request.client else "unknown"

    def _cleanup_old_requests(self, client_ip: str, now: float) -> None:
        """Elimina requests fuera de la ventana de tiempo"""
        self.requests[client_ip] = [
            req_time
            for req_time in self.requests[client_ip]
            if now - req_time < self.window_seconds
        ]

    def _get_retry_after(self, client_ip: str, now: float) -> int:
        """Calcula segundos hasta que el cliente pueda reintentar"""
        if not self.requests[client_ip]:
            return 0
        oldest_request = min(self.requests[client_ip])
        return int(self.window_seconds - (now - oldest_request)) + 1
