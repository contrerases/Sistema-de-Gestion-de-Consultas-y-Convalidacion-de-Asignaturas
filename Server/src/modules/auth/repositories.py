"""
Repositorio de autenticación
Sistema: SGSCT
"""
from sqlalchemy.orm import Session, joinedload
from typing import Optional
from src.modules.auth.models import AuthUser
from src.modules.users.models import User
from src.modules.catalog.campus import Campus
from src.modules.catalog.user_types import UserType
from src.core.exceptions import UserNotFoundException, DuplicateEmailException
from src.monitoring.logging import get_logger

logger = get_logger(__name__)


class AuthRepository:
    """
    Repositorio para operaciones de autenticación
    """
    
    @staticmethod
    def get_auth_user_by_email(db: Session, email: str) -> Optional[AuthUser]:
        """
        Obtener usuario auth por email
        
        Args:
            db: Sesión de base de datos
            email: Email del usuario
            
        Returns:
            AuthUser o None
        """
        return db.query(AuthUser).filter(AuthUser.email == email).first()
    
    @staticmethod
    def get_user_by_id(db: Session, user_id: int) -> Optional[User]:
        """
        Obtener usuario por ID con todas sus relaciones
        
        Args:
            db: Sesión de base de datos
            user_id: ID del usuario
            
        Returns:
            User o None
        """
        return (
            db.query(User)
            .options(
                joinedload(User.auth_user),
                joinedload(User.campus),
                joinedload(User.user_type)
            )
            .filter(User.id == user_id)
            .first()
        )
    
    @staticmethod
    def get_user_by_email(db: Session, email: str) -> Optional[User]:
        """
        Obtener usuario completo por email
        
        Args:
            db: Sesión de base de datos
            email: Email del usuario
            
        Returns:
            User o None
        """
        auth_user = AuthRepository.get_auth_user_by_email(db, email)
        if not auth_user:
            return None
        
        return AuthRepository.get_user_by_id(db, auth_user.id)
    
    @staticmethod
    def email_exists(db: Session, email: str) -> bool:
        """
        Verificar si un email ya está registrado
        
        Args:
            db: Sesión de base de datos
            email: Email a verificar
            
        Returns:
            True si existe, False si no
        """
        return db.query(AuthUser).filter(AuthUser.email == email).first() is not None
    
    @staticmethod
    def get_campus_by_acronym(db: Session, acronym: str) -> Optional[Campus]:
        """
        Obtener campus por acrónimo
        
        Args:
            db: Sesión de base de datos
            acronym: Acrónimo del campus (ej: CC, SJ)
            
        Returns:
            Campus o None
        """
        return db.query(Campus).filter(Campus.acronym == acronym).first()
    
    @staticmethod
    def get_user_type_by_name(db: Session, type_name: str) -> Optional[UserType]:
        """
        Obtener tipo de usuario por nombre
        
        Args:
            db: Sesión de base de datos
            type_name: Nombre del tipo (STUDENT, ADMINISTRATOR)
            
        Returns:
            UserType o None
        """
        return db.query(UserType).filter(UserType.user_type == type_name).first()
    
    @staticmethod
    def create_user(
        db: Session,
        email: str,
        password_hash: str,
        full_name: str,
        campus_id: int,
        user_type_id: int,
        rol_student: Optional[str] = None,
        rut_student: Optional[str] = None
    ) -> User:
        """
        Crear nuevo usuario (auth + user)
        
        Args:
            db: Sesión de base de datos
            email: Email del usuario
            password_hash: Hash de la contraseña (bcrypt incluye salt)
            full_name: Nombre completo
            campus_id: ID del campus
            user_type_id: ID del tipo de usuario
            rol_student: ROL estudiantil (opcional)
            rut_student: RUT del estudiante (opcional)
            
        Returns:
            User creado
            
        Raises:
            DuplicateEmailException: Si el email ya existe
        """
        # Verificar email duplicado
        if AuthRepository.email_exists(db, email):
            raise DuplicateEmailException(email)
        
        # Crear auth_user
        auth_user = AuthUser(
            email=email,
            password_hash=password_hash
        )
        db.add(auth_user)
        db.flush()  # Para obtener el ID sin commit
        
        # Crear user
        user = User(
            id=auth_user.id,
            full_name=full_name,
            id_campus=campus_id,
            id_user_type=user_type_id,
            rol_student=rol_student,
            rut_student=rut_student
        )
        db.add(user)
        db.commit()
        db.refresh(user)
        
        logger.info(f"Usuario creado: {email} (ID: {user.id})")
        
        return AuthRepository.get_user_by_id(db, user.id)
    
    @staticmethod
    def update_password(db: Session, user_id: int, new_password_hash: str) -> None:
        """
        Actualizar contraseña de usuario
        
        Args:
            db: Sesión de base de datos
            user_id: ID del usuario
            new_password_hash: Nuevo hash de contraseña (bcrypt incluye salt)
            
        Raises:
            UserNotFoundException: Si el usuario no existe
        """
        auth_user = db.query(AuthUser).filter(AuthUser.id == user_id).first()
        
        if not auth_user:
            raise UserNotFoundException(user_id=user_id)
        
        auth_user.password_hash = new_password_hash
        db.commit()
        
        logger.info(f"Contraseña actualizada para usuario ID: {user_id}")
    
    @staticmethod
    def delete_user(db: Session, user_id: int) -> None:
        """
        Eliminar usuario (cascade elimina auth_user también)
        
        Args:
            db: Sesión de base de datos
            user_id: ID del usuario
            
        Raises:
            UserNotFoundException: Si el usuario no existe
        """
        auth_user = db.query(AuthUser).filter(AuthUser.id == user_id).first()
        
        if not auth_user:
            raise UserNotFoundException(user_id=user_id)
        
        db.delete(auth_user)
        db.commit()
        
        logger.info(f"Usuario eliminado ID: {user_id}")
