from fastapi import Depends
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials
from core.security import extract_user_from_token
from schemas.auth_user import AuthUser
from core.exceptions import ForbiddenException

security = HTTPBearer()

async def get_current_user(
    credentials: HTTPAuthorizationCredentials = Depends(security)
) -> AuthUser:
    """Dependency para obtener el usuario actual autenticado"""
    user_info = extract_user_from_token(credentials.credentials)
    return user_info

async def get_admin_user(
    current_user: AuthUser = Depends(get_current_user)
) -> AuthUser:
    """Dependency para verificar que el usuario sea administrador"""
    if not current_user.is_admin():
        raise ForbiddenException("Acceso denegado. Se requieren privilegios de administrador")
    return current_user

async def get_student_user(
    current_user: AuthUser = Depends(get_current_user)
) -> AuthUser:
    """Dependency para verificar que el usuario sea estudiante"""
    if not current_user.is_student():
        raise ForbiddenException("Acceso denegado. Se requieren privilegios de estudiante")
    return current_user

async def get_student_or_admin(
    current_user: AuthUser = Depends(get_current_user)
) -> AuthUser:
    """Dependency para verificar que el usuario sea estudiante o administrador"""
    if not (current_user.is_student() or current_user.is_admin()):
        raise ForbiddenException("Acceso denegado. Se requieren privilegios de estudiante o administrador")
    return current_user