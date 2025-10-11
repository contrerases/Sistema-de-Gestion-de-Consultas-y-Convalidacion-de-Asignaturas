"""
Servicio de lógica de negocio para USER_TYPES
Sistema: SGSCT
"""
from typing import Dict, Any
from sqlalchemy.orm import Session
from src.modules.catalog.user_types.repositories import UserTypeRepository
from src.modules.catalog.user_types.schemas import UserTypeCreate, UserTypeUpdate, UserTypeResponse
from src.core.exceptions import NotFoundException, ValidationException
from src.monitoring.logging import get_logger

logger = get_logger(__name__)


class UserTypeService:
    """Servicio para gestión de tipos de usuario"""
    
    def __init__(self, db: Session):
        self.db = db
        self.repository = UserTypeRepository(db)
    
    def get_all(self, page: int = 1, page_size: int = 20) -> Dict[str, Any]:
        """Obtiene todos los tipos de usuario paginados"""
        skip = (page - 1) * page_size
        user_types = self.repository.get_all(skip=skip, limit=page_size)
        total = self.repository.count()
        
        return {
            "items": [UserTypeResponse.model_validate(ut) for ut in user_types],
            "page": page,
            "page_size": page_size,
            "total": total
        }
    
    def get_by_id(self, user_type_id: int) -> UserTypeResponse:
        """Obtiene un tipo de usuario por ID"""
        user_type = self.repository.get_by_id(user_type_id)
        
        if not user_type:
            raise NotFoundException(f"Tipo de usuario con ID {user_type_id} no encontrado")
        
        return UserTypeResponse.model_validate(user_type)
    
    def create(self, data: UserTypeCreate) -> UserTypeResponse:
        """Crea un nuevo tipo de usuario"""
        existing = self.repository.get_by_type(data.user_type)
        if existing:
            raise ValidationException(
                message="Ya existe un tipo de usuario con ese nombre",
                details=[{"field": "user_type", "message": "Tipo duplicado"}]
            )
        
        user_type = self.repository.create(user_type=data.user_type)
        return UserTypeResponse.model_validate(user_type)
    
    def update(self, user_type_id: int, data: UserTypeUpdate) -> UserTypeResponse:
        """Actualiza un tipo de usuario"""
        existing = self.repository.get_by_id(user_type_id)
        if not existing:
            raise NotFoundException(f"Tipo de usuario con ID {user_type_id} no encontrado")
        
        type_check = self.repository.get_by_type(data.user_type)
        if type_check and type_check.id != user_type_id:
            raise ValidationException(
                message="Ya existe otro tipo de usuario con ese nombre",
                details=[{"field": "user_type", "message": "Tipo duplicado"}]
            )
        
        user_type = self.repository.update(user_type_id, data.user_type)
        return UserTypeResponse.model_validate(user_type)
    
    def delete(self, user_type_id: int) -> None:
        """Elimina un tipo de usuario"""
        existing = self.repository.get_by_id(user_type_id)
        if not existing:
            raise NotFoundException(f"Tipo de usuario con ID {user_type_id} no encontrado")
        
        success = self.repository.delete(user_type_id)
        if not success:
            raise ValidationException("No se pudo eliminar el tipo de usuario")
