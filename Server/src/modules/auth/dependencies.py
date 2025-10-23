"""
Dependencies para autenticación y autorización
Sistema: SGSCT
"""

from typing import Annotated, Optional
from fastapi import Depends, Header, HTTPException
from sqlalchemy.orm import Session
from src.database.sessions import get_db
from src.modules.users.base.models import User
from src.core.enums import UserType
from src.modules.auth.security import verify_token

def get_auth_repository(db: Session = Depends(get_db)):
    from src.modules.auth.repository import AuthRepository
    return AuthRepository(db)


async def get_token_from_header(
    authorization: Annotated[Optional[str], Header()] = None,
) -> str:
    """
    Extrae token JWT del header Authorization

    Args:
        authorization: Header Authorization

    Returns:
        Token JWT

    Raises:
        UnauthorizedException: Si header es inválido
    """
    if not authorization:
        raise HTTPException(status_code=401, detail="Token no proporcionado")

    # Formato esperado: "Bearer <token>"
    parts = authorization.split()

    if len(parts) != 2 or parts[0].lower() != "bearer":
        raise HTTPException(status_code=401, detail="Formato de token inválido")

    return parts[1]


async def get_current_user(
    token: Annotated[str, Depends(get_token_from_header)],
    repo = Depends(get_auth_repository),
) -> User:
    """
    Obtiene usuario actual desde token JWT

    Args:
        token: Token JWT
        db: Sesión de base de datos

    Returns:
        Usuario autenticado

    Raises:
        UnauthorizedException: Si token es inválido o usuario no existe
    """
    try:
        # Verificar token y obtener payload (debe ser dict)
        payload = verify_token(token)
        if not isinstance(payload, dict):
            raise HTTPException(status_code=401, detail="Token inválido")

        # Verificar que es access token
        if payload.get("type") != "access":
            raise HTTPException(status_code=401, detail="Token inválido")

        user_id = payload.get("sub") or payload.get("user_id")
        if not user_id:
            raise HTTPException(status_code=401, detail="Token inválido")

        user = repo.get_user_by_id(int(user_id))
        if not user:
            raise HTTPException(status_code=404, detail="Usuario no encontrado")
        return user
    except Exception:
        raise HTTPException(status_code=401, detail="Token inválido o expirado")


async def require_admin(
    current_user: Annotated[User, Depends(get_current_user)],
) -> User:
    """
    Verifica que el usuario actual sea administrador

    Args:
        current_user: Usuario autenticado

    Returns:
        Usuario si es administrador

    Raises:
        ForbiddenException: Si usuario no es administrador
    """
    if current_user.user_type.user_type != UserType.ADMINISTRATOR.value:
        raise HTTPException(
            status_code=403,
            detail="Acceso denegado: Se requieren permisos de administrador",
        )

    return current_user


async def require_student(
    current_user: Annotated[User, Depends(get_current_user)],
) -> User:
    """
    Verifica que el usuario actual sea estudiante

    Args:
        current_user: Usuario autenticado

    Returns:
        Usuario si es estudiante

    Raises:
        ForbiddenException: Si usuario no es estudiante
    """
    if current_user.user_type.user_type != UserType.STUDENT.value:
        raise HTTPException(
            status_code=403, detail="Acceso denegado: Solo estudiantes pueden acceder"
        )

    return current_user


async def optional_user(
    authorization: Annotated[str, Header()],
    repo = Depends(get_auth_repository),
) -> Optional[User]:
    """
    Obtiene usuario si token está presente, None si no
    Útil para endpoints que funcionan con o sin autenticación

    Args:
        authorization: Header Authorization (opcional)
        db: Sesión de base de datos

    Returns:
        Usuario autenticado o None
    """
    if not authorization:
        return None

    try:
        token = await get_token_from_header(authorization)
        return await get_current_user(token, repo)
    except Exception:
        return None
