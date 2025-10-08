"""
Dependencies para autenticación y autorización
Sistema: SGSCT
"""
from typing import Annotated, Optional
from fastapi import Depends, Header
from sqlalchemy.orm import Session
from src.database.sessions import get_db
from src.core import security
from src.core.exceptions import UnauthorizedException, ForbiddenException
from src.modules.auth.repositories import AuthRepository
from src.modules.auth.models import User
from src.core.enums import UserType


async def get_token_from_header(
    authorization: Annotated[str, Header()] = None
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
        raise UnauthorizedException("Token no proporcionado")
    
    # Formato esperado: "Bearer <token>"
    parts = authorization.split()
    
    if len(parts) != 2 or parts[0].lower() != "bearer":
        raise UnauthorizedException("Formato de token inválido")
    
    return parts[1]


async def get_current_user(
    token: Annotated[str, Depends(get_token_from_header)],
    db: Annotated[Session, Depends(get_db)]
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
        # Verificar token
        payload = security.verify_token(token)
        
        # Verificar que es access token
        if payload.get("type") != "access":
            raise UnauthorizedException("Token inválido")
        
        user_id: int = payload.get("user_id")
        
        if not user_id:
            raise UnauthorizedException("Token inválido")
        
        # Buscar usuario
        repository = AuthRepository(db)
        user = repository.get_user_by_id(user_id)
        
        if not user:
            raise UnauthorizedException("Usuario no encontrado")
        
        return user
        
    except Exception as e:
        if isinstance(e, UnauthorizedException):
            raise e
        raise UnauthorizedException("Token inválido o expirado")


async def require_admin(
    current_user: Annotated[User, Depends(get_current_user)]
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
        raise ForbiddenException("Acceso denegado: Se requieren permisos de administrador")
    
    return current_user


async def require_student(
    current_user: Annotated[User, Depends(get_current_user)]
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
        raise ForbiddenException("Acceso denegado: Solo estudiantes pueden acceder")
    
    return current_user


async def optional_user(
    authorization: Annotated[str, Header()] = None,
    db: Annotated[Session, Depends(get_db)] = None
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
        return await get_current_user(token, db)
    except:
        return None
