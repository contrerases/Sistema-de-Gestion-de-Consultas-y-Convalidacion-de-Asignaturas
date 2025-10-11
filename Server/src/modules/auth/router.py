"""
Router de autenticación
Sistema: SGSCT
"""
from typing import Annotated
from fastapi import APIRouter, Depends, status
from sqlalchemy.orm import Session
from src.database.sessions import get_db
from src.modules.auth.service import AuthService
from src.modules.auth.schemas import (
    LoginRequest,
    RegisterRequest,
    RefreshTokenRequest,
    UserResponse
)
from src.modules.auth.dependencies import get_current_user
from src.modules.users.models import User
from src.core.responses import (
    SuccessResponse,
    success_response
)


router = APIRouter(prefix="/auth", tags=["Autenticación"])


@router.post(
    "/login",
    status_code=status.HTTP_200_OK,
    summary="Login de usuario",
    description="Autentica un usuario y retorna tokens de acceso"
)
async def login(
    credentials: LoginRequest,
    db: Annotated[Session, Depends(get_db)]
):
    """
    Endpoint de login
    
    Autentica con email y contraseña, retorna:
    - Datos del usuario
    - Access token (1 hora)
    - Refresh token (7 días)
    """
    service = AuthService(db)
    result = service.login(credentials)
    
    return success_response(
        data=result,
        message="Login exitoso"
    )


@router.post(
    "/register",
    status_code=status.HTTP_201_CREATED,
    summary="Registro de nuevo usuario",
    description="Registra un nuevo usuario en el sistema"
)
async def register(
    data: RegisterRequest,
    db: Annotated[Session, Depends(get_db)]
):
    """
    Endpoint de registro
    
    Crea un nuevo usuario y retorna:
    - Datos del usuario
    - Tokens de acceso
    """
    service = AuthService(db)
    result = service.register(data)
    
    return success_response(
        data=result,
        message="Usuario registrado exitosamente"
    )


@router.post(
    "/refresh",
    status_code=status.HTTP_200_OK,
    summary="Refrescar access token",
    description="Genera nuevo access token usando refresh token"
)
async def refresh_token(
    request: RefreshTokenRequest,
    db: Annotated[Session, Depends(get_db)]
):
    """
    Endpoint de refresh token
    
    Usa refresh token válido para generar nuevo access token
    """
    service = AuthService(db)
    result = service.refresh_token(request.refresh_token)
    
    return success_response(
        data=result,
        message="Token refrescado exitosamente"
    )


@router.get(
    "/me",
    response_model=SuccessResponse[UserResponse],
    status_code=status.HTTP_200_OK,
    summary="Obtener usuario actual",
    description="Retorna información del usuario autenticado"
)
async def get_me(
    current_user: Annotated[User, Depends(get_current_user)],
    db: Annotated[Session, Depends(get_db)]
):
    """
    Endpoint para obtener datos del usuario actual
    
    Requiere: Authorization header con Bearer token
    """
    service = AuthService(db)
    user_data = service.get_current_user(current_user.id)
    
    return success_response(
        data=user_data.model_dump(),
        message="Usuario obtenido exitosamente"
    )


@router.post(
    "/logout",
    status_code=status.HTTP_200_OK,
    summary="Logout de usuario",
    description="Cierra sesión del usuario (invalida token en cliente)"
)
async def logout(
    current_user: Annotated[User, Depends(get_current_user)]
):
    """
    Endpoint de logout
    
    Nota: JWT es stateless, el cliente debe eliminar el token.
    Este endpoint sirve para validar token antes de logout.
    """
    return success_response(
        data=None,
        message="Logout exitoso"
    )
