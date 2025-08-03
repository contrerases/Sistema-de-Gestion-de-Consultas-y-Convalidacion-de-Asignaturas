from fastapi import HTTPException
import mariadb
from crud.workshop_token import (
    # Funciones Preview
    get_workshop_tokens_active,
    get_workshop_tokens_expired,
    # Funciones Complete
    create_workshop_token,
    use_workshop_token
)
from schemas.workshop_token.workshop_token_out import WorkshopTokenOut
from schemas.workshop_token.workshop_token_in import WorkshopTokenIn
from datetime import datetime, timedelta
import secrets

# =============================================================================
# SERVICIOS PREVIEW (datos mínimos para listas)
# =============================================================================

def get_all_workshop_tokens_active_service():
    """Obtiene lista de tokens activos"""
    try:
        rows = get_workshop_tokens_active()
        return [WorkshopTokenOut(**row) for row in rows]
    except mariadb.Error as e:
        raise HTTPException(status_code=500, detail=str(e))

def get_all_workshop_tokens_expired_service():
    """Obtiene lista de tokens expirados"""
    try:
        rows = get_workshop_tokens_expired()
        return [WorkshopTokenOut(**row) for row in rows]
    except mariadb.Error as e:
        raise HTTPException(status_code=500, detail=str(e))

# =============================================================================
# SERVICIOS COMPLETE (datos completos para detalles)
# =============================================================================

def create_workshop_token_service(token_data: WorkshopTokenIn, created_by: int):
    """Crea un nuevo token para un taller"""
    try:
        # Generar token único
        token = secrets.token_urlsafe(32)
        
        # Calcular fecha de expiración
        expiration_at = datetime.now() + timedelta(hours=token_data.expiration_hours)
        
        return create_workshop_token(
            token_data.id_workshop,
            token,
            token_data.id_professor,
            expiration_at.strftime('%Y-%m-%d %H:%M:%S'),
            created_by
        )
    except mariadb.Error as e:
        raise HTTPException(status_code=400, detail=str(e))

def use_workshop_token_service(token: str):
    """Usa un token de taller"""
    try:
        return use_workshop_token(token)
    except mariadb.Error as e:
        raise HTTPException(status_code=400, detail=str(e)) 