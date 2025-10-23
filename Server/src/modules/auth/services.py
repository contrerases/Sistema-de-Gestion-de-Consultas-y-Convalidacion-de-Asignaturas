"""
Servicio de autenticación
Sistema: SGSCT
"""

from typing import Dict, Any
from sqlalchemy.orm import Session

from src.modules.auth.repository import AuthRepository
from src.monitoring.logging import get_logger
from src.modules.auth.schemas import LoginRequest, RegisterRequest, UserResponse
from src.modules.academic.campus.models import Campus
from src.modules.users.types.models import UserType
from fastapi import HTTPException, status
from src.modules.auth.security import (
    verify_password,
    hash_password,
    create_access_token,
    create_refresh_token,
    verify_token,
)
from src.core.enums import UserType as UserTypeEnum

logger = get_logger(__name__)


class AuthServices:
    """Servicio de lógica de negocio para autenticación"""

    def __init__(self, db: Session):
        self.db = db
        self.repository = AuthRepository(db)

    def login(self, credentials: LoginRequest) -> Dict[str, Any]:
        """
        Autentica un usuario y retorna tokens

        Args:
            credentials: Email y contraseña

        Returns:
            Dict con user y tokens

        Raises:
            UnauthorizedException: Si credenciales son inválidas
        """
        # Buscar usuario con relaciones
        user = self.repository.get_user_by_email(credentials.email)

        if not user:
            logger.warning(
                f"Intento de login fallido: email no encontrado - {credentials.email}"
            )
            raise HTTPException(
                status_code=status.HTTP_401_UNAUTHORIZED,
                detail="Credenciales inválidas",
            )

        # Verificar contraseña
        if not verify_password(credentials.password, user.auth_user.password_hash):
            logger.warning(
                f"Intento de login fallido: contraseña incorrecta - {credentials.email}"
            )
            raise HTTPException(
                status_code=status.HTTP_401_UNAUTHORIZED,
                detail="Credenciales inválidas",
            )

        # Generar tokens
        tokens = self._generate_tokens(getattr(user, "id"), user.auth_user.email)

        # Construir respuesta de usuario
        user_response = UserResponse(
            id=int(getattr(user, "id")),
            email=str(getattr(user.auth_user, "email")),
            full_name=str(getattr(user, "full_name")),
            campus_acronym=str(getattr(user.campus, "acronym")),
            campus_name=str(getattr(user.campus, "name")),
            user_type=str(getattr(user.user_type, "name")),
            rol_student=(
                str(getattr(user, "rol_student"))
                if getattr(user, "rol_student") is not None
                else None
            ),
            rut_student=(
                str(getattr(user, "rut_student"))
                if getattr(user, "rut_student") is not None
                else None
            ),
        )

        logger.info(f"Login exitoso: {credentials.email} (ID: {user.id})")

        return {"user": user_response.model_dump(), "tokens": tokens}

    def register(self, data: RegisterRequest) -> Dict[str, Any]:
        """
        Registra un nuevo usuario

        Args:
            data: Datos de registro

        Returns:
            Dict con user y tokens

        Raises:
            ValidationException: Si hay errores de validación
        """
        # Verificar que email no exista
        existing_user = self.repository.get_user_by_email(data.email)
        if existing_user:
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail="El email ya está registrado",
            )

        # Validar campus
        campus = (
            self.db.query(Campus).filter(Campus.acronym == data.campus_acronym).first()
        )

        if not campus:
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST, detail="Campus inválido"
            )

        # Validar user_type
        user_type = (
            self.db.query(UserType)
            .filter(UserType.name == data.user_type)
            .first()
        )

        if not user_type:
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail="Tipo de usuario inválido",
            )

        # Validar que estudiantes tengan ROL y RUT
        if data.user_type == UserTypeEnum.STUDENT:
            if not data.rol_student or not data.rut_student:
                raise HTTPException(
                    status_code=status.HTTP_400_BAD_REQUEST,
                    detail="Estudiantes deben proporcionar ROL y RUT",
                )

        # Hashear contraseña
        password_hash = hash_password(data.password)

        # Crear usuario
        user = self.repository.create_user(
            email=data.email,
            password_hash=password_hash,
            full_name=data.full_name,
            campus_id=getattr(campus, "id"),
            user_type_id=int(getattr(user_type, "id")),
            rol_student=data.rol_student,
            rut_student=data.rut_student,
        )

        logger.info(
            f"Usuario registrado: {data.email} (ID: {user.id}, Tipo: {data.user_type})"
        )

        # Generar tokens
        tokens = self._generate_tokens(getattr(user, "id"), str(user.auth_user.email))
        user_response = UserResponse(
            id=int(getattr(user, "id")),
            email=str(getattr(user.auth_user, "email")),
            full_name=str(getattr(user, "full_name")),
            campus_acronym=str(getattr(user.campus, "acronym")),
            campus_name=str(getattr(user.campus, "name")),
            user_type=str(getattr(user.user_type, "name")),
            rol_student=(
                str(getattr(user, "rol_student"))
                if getattr(user, "rol_student") is not None
                else None
            ),
            rut_student=(getattr(user, "rut_student", None)),
        )
        return {"user": user_response.model_dump(), "tokens": tokens}

    def refresh_token(self, refresh_token: str) -> Dict[str, str]:
        """
        Genera nuevo access token desde refresh token

        Args:
            refresh_token: Token de refresco

        Returns:
            Dict con nuevo access_token

        Raises:
            UnauthorizedException: Si token es inválido
        """
        try:
            payload = verify_token(refresh_token)
            if not isinstance(payload, dict) or payload.get("type") != "refresh":
                raise HTTPException(
                    status_code=status.HTTP_401_UNAUTHORIZED, detail="Token inválido"
                )
            user_id = payload.get("user_id")
            email = payload.get("sub")
            user = self.repository.get_user_by_id(user_id)
            if not user:
                raise HTTPException(
                    status_code=status.HTTP_401_UNAUTHORIZED,
                    detail="Usuario no encontrado",
                )
            access_token = create_access_token(data={"sub": email, "user_id": user_id})
            return {
                "access_token": str(access_token),
                "token_type": "Bearer",
                "expires_in": "3600",
            }
        except Exception:
            raise HTTPException(
                status_code=status.HTTP_401_UNAUTHORIZED,
                detail="Token inválido o expirado",
            )

    def get_current_user(self, user_id: int) -> UserResponse:
        """
        Obtiene datos del usuario actual

        Args:
            user_id: ID del usuario

        Returns:
            UserResponse con datos del usuario

        Raises:
            NotFoundException: Si usuario no existe
        """
        user = self.repository.get_user_by_id(user_id)
        if not user:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND, detail="Usuario no encontrado"
            )

        return UserResponse(
            id=user_id,
            email=str(getattr(user.auth_user, "email")),
            full_name=str(getattr(user, "full_name")),
            campus_acronym=str(getattr(user.campus, "acronym")),
            campus_name=str(getattr(user.campus, "name")),
            user_type=str(getattr(user.user_type, "name")),
            rol_student=(
                str(getattr(user, "rol_student"))
                if getattr(user, "rol_student") is not None
                else None
            ),
            rut_student=(
                str(getattr(user, "rut_student"))
                if getattr(user, "rut_student") is not None
                else None
            ),
        )

    def _generate_tokens(self, user_id: int, email: str) -> Dict[str, Any]:
        """
        Genera access y refresh tokens

        Args:
            user_id: ID del usuario
            email: Email del usuario

        Returns:
            Dict con ambos tokens
        """
        access_token = create_access_token(data={"sub": email, "user_id": user_id})
        refresh_token = create_refresh_token(user_id)
        return {
            "access_token": access_token,
            "refresh_token": refresh_token,
            "token_type": "Bearer",
            "expires_in": 3600,
        }
