"""
Repositorio de autenticación
Sistema: SGSCT
"""

from sqlalchemy.orm import Session, joinedload
from typing import Optional
from src.modules.auth.models import AuthUser
from src.monitoring.logging import get_logger

from src.modules.users.base.models import User
from src.modules.academic.campus.models import Campus
from src.modules.users.types.models import UserType

logger = get_logger(__name__)


class AuthRepository:
    """
    Repositorio para operaciones de autenticación y usuarios relacionados
    """

    def __init__(self, db: Session):
        self.db = db

    # ===================== AUTH USERS =====================
    def get_auth_user_by_email(self, email: str) -> Optional[AuthUser]:
        """Obtener usuario auth por email"""
        return self.db.query(AuthUser).filter(AuthUser.email == email).first()

    # ===================== USERS =====================
    def get_user_by_id(self, user_id: int) -> Optional[User]:
        """Obtener usuario por ID con relaciones"""
        return (
            self.db.query(User)
            .options(
                joinedload(User.auth_user),
                joinedload(User.campus),
                joinedload(User.user_type),
            )
            .filter(User.id == user_id)
            .first()
        )

    def get_user_by_email(self, email: str) -> Optional[User]:
        """Obtener usuario por email (busca en AuthUser y luego en User)"""
        auth_user = self.get_auth_user_by_email(email)
        if not auth_user:
            return None
        return self.get_user_by_id(getattr(auth_user, "id"))

    # ===================== CAMPUS =====================
    def get_campus_by_acronym(self, acronym: str) -> Optional[Campus]:
        """Obtener campus por acrónimo"""
        return self.db.query(Campus).filter(Campus.acronym == acronym).first()

    # ===================== USER TYPES =====================
    def get_user_type_by_name(self, type_name: str) -> Optional[UserType]:
        """Obtener tipo de usuario por nombre"""
        return self.db.query(UserType).filter(UserType.user_type == type_name).first()

    # ===================== CREAR/ACTUALIZAR/ELIMINAR =====================
    def create_user(
        self,
        email: str,
        password_hash: str,
        full_name: str,
        campus_id: int,
        user_type_id: int,
        rol_student: Optional[str] = None,
        rut_student: Optional[str] = None,
    ) -> User:
        """Crear nuevo usuario (auth + user)"""
        if self.email_exists(email):
            raise Exception(f"Email duplicado: {email}")
        auth_user = AuthUser(email=email, password_hash=password_hash)
        self.db.add(auth_user)
        self.db.flush()
        user = User(
            id=auth_user.id,
            full_name=full_name,
            id_campus=campus_id,
            id_user_type=user_type_id,
            rol_student=rol_student,
            rut_student=rut_student,
        )
        self.db.add(user)
        self.db.commit()
        self.db.refresh(user)
        logger.info(f"Usuario creado: {email} (ID: {user.id})")
        return self.get_user_by_id(getattr(user, "id"))

    def update_password(self, user_id: int, new_password_hash: str) -> None:
        """Actualizar contraseña de usuario"""
        auth_user = self.db.query(AuthUser).filter(AuthUser.id == user_id).first()
        if not auth_user:
            raise Exception(f"Usuario no encontrado: {user_id}")
        setattr(auth_user, "password_hash", new_password_hash)
        self.db.commit()
        logger.info(f"Contraseña actualizada para usuario ID: {user_id}")

    def delete_user(self, user_id: int) -> None:
        """Eliminar usuario (cascade elimina auth_user también)"""
        auth_user = self.db.query(AuthUser).filter(AuthUser.id == user_id).first()
        if not auth_user:
            return None
        self.db.delete(auth_user)
        self.db.commit()
        logger.info(f"Usuario eliminado ID: {user_id}")

    def email_exists(self, email: str) -> bool:
        """Verifica si un email ya existe en AuthUser"""
        return (
            self.db.query(AuthUser).filter(AuthUser.email == email).first() is not None
        )
