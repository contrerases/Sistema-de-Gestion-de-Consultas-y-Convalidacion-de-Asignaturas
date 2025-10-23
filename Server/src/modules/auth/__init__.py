"""
Módulo de Autenticación
Sistema: SGSCT
"""

from .models import AuthUser
from .repository import AuthRepository
from .services import AuthServices
from .router import router as auth_router
from .schemas import (
    LoginRequest,
    RegisterRequest,
    RefreshTokenRequest,
    UserResponse,
    LoginResponse,
    TokenResponse,
)
from .dependencies import (
    get_current_user,
    require_admin,
    require_student,
    optional_user,
)
from .security import (
    hash_password,
    verify_password,
    create_access_token,
    create_refresh_token,
    verify_token,
    decode_token,
)

__all__ = [
    "AuthUser",
    "AuthRepository",
    "AuthServices",
    "auth_router",
    "LoginRequest",
    "RegisterRequest",
    "RefreshTokenRequest",
    "UserResponse",
    "LoginResponse",
    "TokenResponse",
    "get_current_user",
    "require_admin",
    "require_student",
    "optional_user",
    "hash_password",
    "verify_password",
    "create_access_token",
    "create_refresh_token",
    "verify_token",
    "decode_token",
]
