"""
Request ID Middleware
Generación de ID único para cada request
Sistema: SGSCT
"""

import uuid
from starlette.middleware.base import BaseHTTPMiddleware
from starlette.requests import Request
from starlette.responses import Response


class RequestIDMiddleware(BaseHTTPMiddleware):
    """
    Middleware para generar un ID único por request.

    El ID se almacena en request.state.request_id y se incluye
    en el header X-Request-ID de la respuesta para trazabilidad.
    """

    async def dispatch(self, request: Request, call_next) -> Response:
        request_id = request.headers.get("X-Request-ID")

        if not request_id:
            request_id = str(uuid.uuid4())

        request.state.request_id = request_id

        response = await call_next(request)
        response.headers["X-Request-ID"] = request_id

        return response
