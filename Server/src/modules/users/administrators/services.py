"""
Servicio del submódulo Administrators
Sistema: SGSCT
"""

from typing import Optional
from sqlalchemy.orm import Session
from src.modules.users.administrators.repository import AdministratorRepository
from src.modules.users.administrators.schemas import (
    AdministratorCreate,
    AdministratorUpdate,
    AdministratorResponse,
)
from src.modules.users.base.models import User
from src.modules.auth.models import AuthUser
from src.modules.auth.security import hash_password
from src.modules.users.types.models import UserType
from src.monitoring.logging import get_logger
from fastapi import HTTPException
from src.core.responses import PaginatedResponse

logger = get_logger(__name__)


class AdministratorServices:
    """Servicio con lógica de negocio de administradores"""

    def __init__(self, db: Session):
        self.repository = AdministratorRepository(db)
        self.db = db

    def get_all(
        self, skip: int = 0, limit: int = 50, campus_id: Optional[int] = None
    ) -> PaginatedResponse[AdministratorResponse]:
        """Obtiene todos los administradores con paginación"""
        admins = self.repository.get_all(skip=skip, limit=limit, campus_id=campus_id)
        total = self.repository.count(campus_id=campus_id)

        logger.info(f"Retrieved {len(admins)} administrators")

        return PaginatedResponse(
            total=total,
            items=[self._to_response(a) for a in admins],
            skip=skip,
            limit=limit,
        )

    def get_by_id(self, admin_id: int) -> AdministratorResponse:
        """Obtiene un administrador por ID"""
        admin = self.repository.get_by_id(admin_id)
        if not admin:
            raise HTTPException(status_code=404, detail="Administrador no encontrado")
        return self._to_response(admin)

    def create(self, data: AdministratorCreate) -> AdministratorResponse:
        """Crea un nuevo administrador"""
        # Validar email único
        existing_auth = (
            self.db.query(AuthUser).filter(AuthUser.email == data.email).first()
        )
        if existing_auth:
            raise HTTPException(status_code=400, detail="El email ya está registrado")

        # Obtener id de user_type ADMINISTRATOR
        admin_type = (
            self.db.query(UserType).filter(UserType.name == "ADMINISTRATOR").first()
        )
        if not admin_type:
            raise HTTPException(
                status_code=500, detail="Tipo de usuario ADMINISTRATOR no encontrado"
            )

        # Crear auth_user
        auth_user = AuthUser(
            email=data.email, password_hash=hash_password(data.password)
        )
        self.db.add(auth_user)
        self.db.flush()

        # Crear user (administrador)
        user = User(
            id=auth_user.id,
            full_name=data.full_name,
            id_campus=data.id_campus,
            id_user_type=admin_type.id,
            rol_student=None,
            rut_student=None,
        )

        admin = self.repository.create(user)
        logger.info(f"Administrator created: {admin.id} - {admin.full_name}")

        return self._to_response(admin)

    def update(self, admin_id: int, data: AdministratorUpdate) -> AdministratorResponse:
        """Actualiza un administrador"""
        admin = self.repository.get_by_id(admin_id)
        if not admin:
            raise HTTPException(status_code=404, detail="Administrador no encontrado")

        # Actualizar campos
        if data.full_name:
            setattr(admin, "full_name", data.full_name)
        if data.id_campus:
            setattr(admin, "id_campus", data.id_campus)

        updated_admin = self.repository.update(admin)
        logger.info(f"Administrator updated: {updated_admin.id}")

        return self._to_response(updated_admin)

    def delete(self, admin_id: int) -> None:
        """Elimina un administrador"""
        admin = self.repository.get_by_id(admin_id)
        if not admin:
            raise HTTPException(status_code=404, detail="Administrador no encontrado")

        # Eliminar auth_user (cascade delete eliminará user)
        auth_user = admin.auth_user
        self.db.delete(auth_user)
        self.db.commit()

        logger.info(f"Administrator deleted: {admin_id}")

    def _to_response(self, admin: User) -> AdministratorResponse:
        """Convierte modelo a response"""
        return AdministratorResponse(
            id=getattr(admin, "id"),
            email=getattr(admin.auth_user, "email"),
            full_name=getattr(admin, "full_name"),
            id_campus=getattr(admin, "id_campus"),
            id_user_type=getattr(admin, "id_user_type"),
        )
