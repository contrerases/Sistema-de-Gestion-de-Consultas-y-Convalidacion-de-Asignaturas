"""
Repositorio de Tokens
Sistema: SGSCT
"""
from typing import List, Optional
from sqlalchemy.orm import Session
from datetime import datetime
from src.modules.workshops.tokens.models import WorkshopToken


class TokenRepository:
    """Repositorio para operaciones CRUD de tokens"""
    
    def __init__(self, db: Session):
        self.db = db
    
    def get_all(self, skip: int = 0, limit: int = 100, workshop_id: Optional[int] = None, is_active: Optional[bool] = None) -> List[WorkshopToken]:
        """Obtiene todos los tokens con filtros"""
        query = self.db.query(WorkshopToken)
        
        if workshop_id:
            query = query.filter(WorkshopToken.id_workshop == workshop_id)
        if is_active is not None:
            query = query.filter(WorkshopToken.is_active == is_active)
        
        return query.order_by(WorkshopToken.created_at.desc()).offset(skip).limit(limit).all()
    
    def get_by_id(self, token_id: int) -> Optional[WorkshopToken]:
        """Obtiene un token por ID"""
        return self.db.query(WorkshopToken).filter(WorkshopToken.id == token_id).first()
    
    def get_by_token(self, token: str) -> Optional[WorkshopToken]:
        """Obtiene un token por su valor"""
        return self.db.query(WorkshopToken).filter(WorkshopToken.token == token).first()
    
    def get_by_workshop(self, workshop_id: int, skip: int = 0, limit: int = 100) -> List[WorkshopToken]:
        """Obtiene tokens de un taller"""
        return (
            self.db.query(WorkshopToken)
            .filter(WorkshopToken.id_workshop == workshop_id)
            .order_by(WorkshopToken.created_at.desc())
            .offset(skip)
            .limit(limit)
            .all()
        )
    
    def create(self, workshop_id: int, token: str, expires_at: datetime) -> WorkshopToken:
        """Crea un nuevo token"""
        workshop_token = WorkshopToken(
            id_workshop=workshop_id,
            token=token,
            expires_at=expires_at,
            is_active=True
        )
        self.db.add(workshop_token)
        self.db.flush()  # Flush en lugar de commit
        self.db.refresh(workshop_token)
        return workshop_token
    
    def deactivate(self, token_id: int) -> Optional[WorkshopToken]:
        """Desactiva un token"""
        token = self.get_by_id(token_id)
        if token:
            token.is_active = False
            self.db.flush()  # Flush en lugar de commit
            self.db.refresh(token)
        return token
    
    def delete(self, token_id: int) -> bool:
        """Elimina un token"""
        token = self.get_by_id(token_id)
        if token:
            self.db.delete(token)
            self.db.flush()  # Flush en lugar de commit
            return True
        return False
    
    def count(self, workshop_id: Optional[int] = None, is_active: Optional[bool] = None) -> int:
        """Cuenta tokens con filtros"""
        query = self.db.query(WorkshopToken)
        
        if workshop_id:
            query = query.filter(WorkshopToken.id_workshop == workshop_id)
        if is_active is not None:
            query = query.filter(WorkshopToken.is_active == is_active)
        
        return query.count()
