"""
Middleware package
Sistema: SGSCT
"""
from src.middleware.cors import setup_cors
from src.middleware.request_id import RequestIDMiddleware
from src.middleware.logging import LoggingMiddleware
from src.middleware.security_headers import SecurityHeadersMiddleware
from src.middleware.rate_limit import RateLimitMiddleware
from src.middleware.error_handler import ErrorHandlerMiddleware

__all__ = [
    "setup_cors",
    "RequestIDMiddleware",
    "LoggingMiddleware",
    "SecurityHeadersMiddleware",
    "RateLimitMiddleware",
    "ErrorHandlerMiddleware",
]
