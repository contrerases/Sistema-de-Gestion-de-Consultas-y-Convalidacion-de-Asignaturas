from fastapi import APIRouter, status
from typing import List
from schemas.workshop_token.workshop_token_in import WorkshopTokenIn
from schemas.workshop_token.workshop_token_out import WorkshopTokenOut
from services.workshop_token_service import (
    get_all_workshop_tokens_active_service,
    get_all_workshop_tokens_expired_service,
    create_workshop_token_service,
    use_workshop_token_service
)

router = APIRouter(prefix="/workshop-tokens", tags=["workshop-tokens"])

@router.get("/", response_model=List[WorkshopTokenOut])
def get_workshop_tokens():
    """Lista todos los tokens activos"""
    return get_all_workshop_tokens_active_service()

@router.get("/expired", response_model=List[WorkshopTokenOut])
def get_expired_workshop_tokens():
    """Lista todos los tokens expirados"""
    return get_all_workshop_tokens_expired_service()

@router.post("/", response_model=bool, status_code=status.HTTP_201_CREATED)
def create_workshop_token(token_data: WorkshopTokenIn):
    """Crea un nuevo token para un taller"""
    # TODO: Obtener el ID del administrador logueado
    created_by = 1  # Temporal, debe obtenerse del contexto de autenticación
    return create_workshop_token_service(token_data, created_by)

@router.post("/{token}/use", response_model=bool)
def use_workshop_token(token: str):
    """Usa un token de taller"""
    return use_workshop_token_service(token) 