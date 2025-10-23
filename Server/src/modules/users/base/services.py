"""
Servicios del módulo Users
Sistema: SGSCT
"""

from typing import Dict, Optional
from sqlalchemy.orm import Session
from fastapi import HTTPException
from src.modules.users.base.repository import UserRepository
from src.modules.users.base.schemas import UserCreate, UserUpdate, UserResponse
from src.modules.users.base.constants import TYPE_STUDENT
from src.modules.auth.security import hash_password
from src.monitoring.logging import get_logger

logger = get_logger(__name__)


class UserServices:
    """Servicio con lógica de negocio de usuarios"""

    def __init__(self, db: Session):
        self.repository = UserRepository(db)
        self.db = db

    # ========================================================================
    # READ OPERATIONS
    # ========================================================================

    def get_all(
        self,
        page: int = 1,
        page_size: int = 50,
        user_type_id: Optional[int] = None,
        campus_id: Optional[int] = None,
    ) -> Dict:
        """Obtiene todos los usuarios con paginación"""
        skip = (page - 1) * page_size
        users = self.repository.get_all(
            skip=skip, limit=page_size, user_type_id=user_type_id, campus_id=campus_id
        )
        total = self.repository.count(user_type_id=user_type_id, campus_id=campus_id)

        logger.info(f"Retrieved {len(users)} users (page {page})")

        return {
            "items": [self._user_to_response(u) for u in users],
            "total": total,
            "page": page,
            "page_size": page_size,
        }

    def get_by_id(self, user_id: int) -> UserResponse:
        """Obtiene un usuario por ID"""
        user = self.repository.get_by_id(user_id)
        if not user:
            raise HTTPException(status_code=404, detail="Usuario no encontrado")
        return self._user_to_response(user)

    def get_by_email(self, email: str) -> UserResponse:
        """Obtiene un usuario por email"""
        user = self.repository.get_by_email(email)
        if not user:
            raise HTTPException(status_code=404, detail="Usuario no encontrado")
        return self._user_to_response(user)

    # ========================================================================
    # CREATE OPERATIONS
    # ========================================================================

    def create(self, data: UserCreate) -> UserResponse:
        """Crea un nuevo usuario"""
        # Validar email único
        if self.repository.check_email_exists(data.email):
            raise HTTPException(
                status_code=400, detail="Ya existe un usuario con este email"
            )

        # Validar datos según tipo de usuario
        if getattr(data, "id_user_type", None) == TYPE_STUDENT:
            if not data.rol_student or not data.rut_student:
                raise HTTPException(
                    status_code=400,
                    detail="Los datos de estudiante (ROL y RUT) son obligatorios para usuarios tipo STUDENT",
                )

            # Validar ROL y RUT únicos
            if self.repository.check_rol_exists(data.rol_student):
                raise HTTPException(
                    status_code=400, detail="Ya existe un usuario con este ROL"
                )
            if self.repository.check_rut_exists(data.rut_student):
                raise HTTPException(
                    status_code=400, detail="Ya existe un usuario con este RUT"
                )
        else:
            # Administrador no debe tener datos de estudiante
            if data.rol_student or data.rut_student:
                raise HTTPException(
                    status_code=400,
                    detail="Los datos de estudiante (ROL y RUT) no deben proporcionarse para administradores",
                )

        # Generar hash de contraseña
        password_hash = hash_password(data.password)


        # Crear usuario usando AuthRepository (import local para evitar ciclos)
        from src.modules.auth.repository import AuthRepository
        user = AuthRepository(self.db).create_user(
            email=data.email,
            password_hash=password_hash,
            full_name=data.full_name,
            campus_id=data.id_campus,
            user_type_id=data.id_user_type,
            rol_student=data.rol_student,
            rut_student=data.rut_student,
        )

        logger.info(f"Created user: {user.id} ({data.email})")
        return self._user_to_response(user)

    # ========================================================================
    # UPDATE OPERATIONS
    # ========================================================================

    def update(self, user_id: int, data: UserUpdate) -> UserResponse:
        """Actualiza un usuario"""
        user = self.repository.get_by_id(user_id)
        if not user:
            raise HTTPException(status_code=404, detail="Usuario no encontrado")

        # Validar RUT único si se actualiza
        if data.rut_student and self.repository.check_rut_exists(
            data.rut_student, exclude_id=user_id
        ):
            raise HTTPException(
                status_code=400, detail="Ya existe un usuario con este RUT"
            )

        # Validar ROL único si se actualiza
        if data.rol_student and self.repository.check_rol_exists(
            data.rol_student, exclude_id=user_id
        ):
            raise HTTPException(
                status_code=400, detail="Ya existe un usuario con este ROL"
            )

        updated_user = self.repository.update(
            user_id=user_id,
            full_name=data.full_name,
            id_campus=data.id_campus,
            rol_student=data.rol_student,
            rut_student=data.rut_student,
        )

        logger.info(f"Updated user: {user_id}")
        return self._user_to_response(updated_user)

    # ========================================================================
    # DELETE OPERATIONS
    # ========================================================================

    def delete(self, user_id: int) -> Dict:
        """Elimina un usuario"""
        if not self.repository.get_by_id(user_id):
            raise HTTPException(status_code=404, detail="Usuario no encontrado")

        success = self.repository.delete(user_id)
        if not success:
            raise HTTPException(status_code=500, detail="Error al eliminar usuario")

        logger.info(f"Deleted user: {user_id}")
        return {"message": "Usuario eliminado exitosamente"}

    # ========================================================================
    # HELPER METHODS
    # ========================================================================

    def _user_to_response(self, user) -> UserResponse:
        """Convierte User a UserResponse"""
        return UserResponse(
            id=user.id,
            email=user.auth_user.email,
            full_name=user.full_name,
            id_campus=user.id_campus,
            campus_acronym=user.campus.acronym,
            campus_name=user.campus.name,
            id_user_type=user.id_user_type,
            user_type_name=user.user_type.name,
            rol_student=user.rol_student,
            rut_student=user.rut_student,
        )
