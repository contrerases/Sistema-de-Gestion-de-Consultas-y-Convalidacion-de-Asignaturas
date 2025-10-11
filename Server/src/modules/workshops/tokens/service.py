"""
Servicio de Tokens
Sistema: SGSCT
"""
import secrets
from typing import Dict, Optional
from datetime import datetime
from sqlalchemy.orm import Session
from src.modules.workshops.tokens.repositories import TokenRepository
from src.modules.workshops.tokens.schemas import TokenCreate, TokenValidate, TokenResponse
from src.modules.workshops.constants import MSG_TOKEN_INVALID
from src.core.exceptions import NotFoundException, ValidationException
from src.monitoring.logging import get_logger

logger = get_logger(__name__)


class TokenService:
    """Servicio para gestión de tokens"""
    
    def __init__(self, db: Session):
        self.db = db
        self.repository = TokenRepository(db)
    
    def get_all(self, page: int = 1, page_size: int = 20, workshop_id: Optional[int] = None, is_active: Optional[bool] = None) -> Dict:
        """Obtiene todos los tokens con filtros"""
        skip = (page - 1) * page_size
        tokens_db = self.repository.get_all(skip=skip, limit=page_size, workshop_id=workshop_id, is_active=is_active)
        total = self.repository.count(workshop_id=workshop_id, is_active=is_active)
        
        return {
            "items": [TokenResponse.model_validate(t) for t in tokens_db],
            "page": page,
            "page_size": page_size,
            "total": total
        }
    
    def get_by_id(self, token_id: int) -> TokenResponse:
        """Obtiene un token por ID"""
        token = self.repository.get_by_id(token_id)
        if not token:
            raise NotFoundException(f"Token con ID {token_id} no encontrado")
        
        return TokenResponse.model_validate(token)
    
    def get_by_workshop(self, workshop_id: int, page: int = 1, page_size: int = 20) -> Dict:
        """Obtiene tokens de un taller"""
        skip = (page - 1) * page_size
        tokens_db = self.repository.get_by_workshop(workshop_id, skip=skip, limit=page_size)
        total = self.repository.count(workshop_id=workshop_id)
        
        return {
            "items": [TokenResponse.model_validate(t) for t in tokens_db],
            "page": page,
            "page_size": page_size,
            "total": total
        }
    
    def create(self, data: TokenCreate) -> TokenResponse:
        """Crea un nuevo token"""
        # Generar token único
        token_value = secrets.token_urlsafe(32)
        
        logger.info(f"Creando token para taller {data.id_workshop}")
        
        token = self.repository.create(
            workshop_id=data.id_workshop,
            token=token_value,
            expires_at=data.expires_at
        )
        
        logger.info(f"Token creado con ID {token.id}")
        return TokenResponse.model_validate(token)
    
    def validate_token(self, data: TokenValidate) -> Dict:
        """Valida un token"""
        token = self.repository.get_by_token(data.token)
        
        if not token:
            raise ValidationException(MSG_TOKEN_INVALID)
        
        if not token.is_active:
            raise ValidationException(MSG_TOKEN_INVALID)
        
        if datetime.now() > token.expires_at:
            raise ValidationException(MSG_TOKEN_INVALID)
        
        return {
            "valid": True,
            "workshop_id": token.id_workshop,
            "expires_at": token.expires_at
        }
    
    def deactivate(self, token_id: int) -> TokenResponse:
        """Desactiva un token"""
        existing = self.repository.get_by_id(token_id)
        if not existing:
            raise NotFoundException(f"Token con ID {token_id} no encontrado")
        
        logger.info(f"Desactivando token {token_id}")
        
        token = self.repository.deactivate(token_id)
        return TokenResponse.model_validate(token)
    
    def delete(self, token_id: int) -> None:
        """Elimina un token"""
        existing = self.repository.get_by_id(token_id)
        if not existing:
            raise NotFoundException(f"Token con ID {token_id} no encontrado")
        
        logger.info(f"Eliminando token {token_id}")
        self.repository.delete(token_id)
