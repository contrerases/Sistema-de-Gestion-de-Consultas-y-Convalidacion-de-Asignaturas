"""
Servicio de autenticación
Sistema: SGSCT
"""
from typing import Optional, Dict, Any
from sqlalchemy.orm import Session
from src.modules.auth.repositories import AuthRepository
from src.monitoring.logging import get_logger
from src.modules.auth.schemas import (
    LoginRequest,
    RegisterRequest,
    UserResponse
)
from src.modules.catalog.campus import Campus
from src.modules.catalog.user_types import UserType
from src.core import security
from src.core.exceptions import (
    UnauthorizedException,
    ValidationException,
    NotFoundException
)
from src.core.enums import UserType as UserTypeEnum

logger = get_logger(__name__)


class AuthService:
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
            logger.warning(f"Intento de login fallido: email no encontrado - {credentials.email}")
            raise UnauthorizedException("Credenciales inválidas")
        
        # Verificar contraseña
        if not security.verify_password(
            credentials.password,
            user.auth_user.password_hash
        ):
            logger.warning(f"Intento de login fallido: contraseña incorrecta - {credentials.email}")
            raise UnauthorizedException("Credenciales inválidas")
        
        # Generar tokens
        tokens = self._generate_tokens(user.id, user.auth_user.email)
        
        # Construir respuesta de usuario
        user_response = UserResponse(
            id=user.id,
            email=user.auth_user.email,
            full_name=user.full_name,
            campus_acronym=user.campus.acronym,
            campus_name=user.campus.name,
            user_type=user.user_type.user_type,
            rol_student=user.rol_student,
            rut_student=user.rut_student
        )
        
        logger.info(f"Login exitoso: {credentials.email} (ID: {user.id})")
        
        return {
            "user": user_response.model_dump(),
            "tokens": tokens
        }
    
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
            raise ValidationException(
                message="El email ya está registrado",
                details=[{"field": "email", "message": "Email ya existe"}]
            )
        
        # Validar campus
        campus = self.db.query(Campus).filter(
            Campus.acronym == data.campus_acronym
        ).first()
        
        if not campus:
            raise ValidationException(
                message="Campus inválido",
                details=[{"field": "campus_acronym", "message": "Campus no existe"}]
            )
        
        # Validar user_type
        user_type = self.db.query(UserType).filter(
            UserType.user_type == data.user_type.value
        ).first()
        
        if not user_type:
            raise ValidationException(
                message="Tipo de usuario inválido",
                details=[{"field": "user_type", "message": "Tipo no existe"}]
            )
        
        # Validar que estudiantes tengan ROL y RUT
        if data.user_type == UserTypeEnum.STUDENT:
            if not data.rol_student or not data.rut_student:
                raise ValidationException(
                    message="Estudiantes deben proporcionar ROL y RUT",
                    details=[
                        {"field": "rol_student", "message": "ROL es obligatorio para estudiantes"},
                        {"field": "rut_student", "message": "RUT es obligatorio para estudiantes"}
                    ]
                )
        
        # Hashear contraseña
        password_hash = security.hash_password(data.password)
        
        # Crear usuario
        user = self.repository.create_user(
            email=data.email,
            password_hash=password_hash,
            full_name=data.full_name,
            campus_id=campus.id,
            user_type_id=user_type.id,
            rol_student=data.rol_student,
            rut_student=data.rut_student
        )
        
        logger.info(f"Usuario registrado: {data.email} (ID: {user.id}, Tipo: {data.user_type.value})")
        
        # Generar tokens
        tokens = self._generate_tokens(user.id, user.auth_user.email)
        
        # Construir respuesta
        user_response = UserResponse(
            id=user.id,
            email=user.auth_user.email,
            full_name=user.full_name,
            campus_acronym=user.campus.acronym,
            campus_name=user.campus.name,
            user_type=user.user_type.user_type,
            rol_student=user.rol_student,
            rut_student=user.rut_student
        )
        
        return {
            "user": user_response.model_dump(),
            "tokens": tokens
        }
    
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
            payload = security.verify_token(refresh_token)
            
            # Verificar que es refresh token
            if payload.get("type") != "refresh":
                raise UnauthorizedException("Token inválido")
            
            user_id = payload.get("user_id")
            email = payload.get("sub")
            
            # Verificar que usuario existe
            user = self.repository.get_user_by_id(user_id)
            if not user:
                raise UnauthorizedException("Usuario no encontrado")
            
            # Generar nuevo access token
            access_token = security.create_access_token(
                data={"sub": email, "user_id": user_id}
            )
            
            return {
                "access_token": access_token,
                "token_type": "Bearer",
                "expires_in": 3600  # 1 hora
            }
            
        except Exception as e:
            raise UnauthorizedException("Token inválido o expirado")
    
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
            raise NotFoundException("Usuario no encontrado")
        
        return UserResponse(
            id=user.id,
            email=user.auth_user.email,
            full_name=user.full_name,
            campus_acronym=user.campus.acronym,
            campus_name=user.campus.name,
            user_type=user.user_type.user_type,
            rol_student=user.rol_student,
            rut_student=user.rut_student
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
        access_token = security.create_access_token(
            data={"sub": email, "user_id": user_id}
        )
        
        refresh_token = security.create_refresh_token(
            data={"sub": email, "user_id": user_id}
        )
        
        return {
            "access_token": access_token,
            "refresh_token": refresh_token,
            "token_type": "Bearer",
            "expires_in": 3600  # 1 hora
        }
