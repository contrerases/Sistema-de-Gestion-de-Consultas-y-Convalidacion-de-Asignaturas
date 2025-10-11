"""
Servicio del submódulo Administrators
Sistema: SGSCT
"""
from typing import Dict
from sqlalchemy.orm import Session
from src.modules.users.administrators.repositories import AdministratorRepository
from src.modules.users.administrators.schemas import (
    AdministratorCreate,
    AdministratorUpdate,
    AdministratorResponse
)
from src.modules.users.models import User
from src.modules.auth.models import AuthUser
from src.modules.users.constants import (
    TYPE_ADMINISTRATOR,
    MSG_USER_NOT_FOUND,
    MSG_EMAIL_ALREADY_EXISTS
)
from src.core.exceptions import NotFoundException, ValidationException
from src.core.security import hash_password
from src.monitoring.logging import get_logger

logger = get_logger(__name__)


class AdministratorService:
    """Servicio con lógica de negocio de administradores"""
    
    def __init__(self, db: Session):
        self.repository = AdministratorRepository(db)
        self.db = db
    
    def get_all(
        self,
        page: int = 1,
        page_size: int = 50,
        campus_id: int = None
    ) -> Dict:
        """Obtiene todos los administradores con paginación"""
        skip = (page - 1) * page_size
        admins = self.repository.get_all(
            skip=skip,
            limit=page_size,
            campus_id=campus_id
        )
        total = self.repository.count(campus_id=campus_id)
        
        logger.info(f"Retrieved {len(admins)} administrators (page {page})")
        
        return {
            "items": [self._to_response(a) for a in admins],
            "total": total,
            "page": page,
            "page_size": page_size
        }
    
    def get_by_id(self, admin_id: int) -> AdministratorResponse:
        """Obtiene un administrador por ID"""
        admin = self.repository.get_by_id(admin_id)
        if not admin:
            raise NotFoundException(MSG_USER_NOT_FOUND)
        return self._to_response(admin)
    
    def create(self, data: AdministratorCreate) -> AdministratorResponse:
        """Crea un nuevo administrador"""
        # Validar email único
        existing_auth = self.db.query(AuthUser).filter(AuthUser.email == data.email).first()
        if existing_auth:
            raise ValidationException(MSG_EMAIL_ALREADY_EXISTS)
        
        # Crear auth_user
        auth_user = AuthUser(
            email=data.email,
            password_hash=hash_password(data.password)
        )
        self.db.add(auth_user)
        self.db.flush()
        
        # Crear user (administrador)
        user = User(
            id=auth_user.id,
            full_name=data.full_name,
            id_campus=data.id_campus,
            id_user_type=TYPE_ADMINISTRATOR,
            rol_student=None,
            rut_student=None
        )
        
        admin = self.repository.create(user)
        logger.info(f"Administrator created: {admin.id} - {admin.full_name}")
        
        return self._to_response(admin)
    
    def update(self, admin_id: int, data: AdministratorUpdate) -> AdministratorResponse:
        """Actualiza un administrador"""
        admin = self.repository.get_by_id(admin_id)
        if not admin:
            raise NotFoundException(MSG_USER_NOT_FOUND)
        
        # Actualizar campos
        if data.full_name:
            admin.full_name = data.full_name
        if data.id_campus:
            admin.id_campus = data.id_campus
        
        updated_admin = self.repository.update(admin)
        logger.info(f"Administrator updated: {updated_admin.id}")
        
        return self._to_response(updated_admin)
    
    def delete(self, admin_id: int) -> None:
        """Elimina un administrador"""
        admin = self.repository.get_by_id(admin_id)
        if not admin:
            raise NotFoundException(MSG_USER_NOT_FOUND)
        
        # Eliminar auth_user (cascade delete eliminará user)
        auth_user = admin.auth_user
        self.db.delete(auth_user)
        self.db.commit()
        
        logger.info(f"Administrator deleted: {admin_id}")
    
    def _to_response(self, admin: User) -> AdministratorResponse:
        """Convierte modelo a response"""
        return AdministratorResponse(
            id=admin.id,
            email=admin.auth_user.email,
            full_name=admin.full_name,
            id_campus=admin.id_campus,
            id_user_type=admin.id_user_type
        )
