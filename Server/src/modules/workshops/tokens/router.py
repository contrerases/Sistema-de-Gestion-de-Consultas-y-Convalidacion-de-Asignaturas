"""
Router de Tokens
Sistema: SGSCT
"""
from fastapi import APIRouter, Depends, status, Query
from sqlalchemy.orm import Session
from typing import Annotated, Optional
from src.database.sessions import get_db
from src.modules.workshops.tokens.service import TokenService
from src.modules.workshops.tokens.schemas import TokenCreate, TokenValidate
from src.core.responses import success_response, paginated_response

router = APIRouter(prefix="/tokens", tags=["Tokens"])


@router.get("", status_code=status.HTTP_200_OK, summary="Listar tokens")
async def get_tokens(
    page: Annotated[int, Query(ge=1)] = 1,
    page_size: Annotated[int, Query(ge=1, le=100)] = 20,
    workshop_id: Optional[int] = None,
    is_active: Optional[bool] = None,
    db: Annotated[Session, Depends(get_db)] = None
):
    """Lista todos los tokens con filtros"""
    service = TokenService(db)
    result = service.get_all(page=page, page_size=page_size, workshop_id=workshop_id, is_active=is_active)
    
    return paginated_response(
        data=[item.model_dump() for item in result["items"]],
        page=result["page"],
        page_size=result["page_size"],
        total=result["total"]
    )


@router.get("/{token_id}", status_code=status.HTTP_200_OK, summary="Obtener token")
async def get_token(
    token_id: int,
    db: Annotated[Session, Depends(get_db)] = None
):
    """Obtiene un token específico"""
    service = TokenService(db)
    token = service.get_by_id(token_id)
    
    return success_response(
        data=token.model_dump(),
        message="Token obtenido exitosamente"
    )


@router.get("/workshop/{workshop_id}", status_code=status.HTTP_200_OK, summary="Tokens de taller")
async def get_tokens_by_workshop(
    workshop_id: int,
    page: Annotated[int, Query(ge=1)] = 1,
    page_size: Annotated[int, Query(ge=1, le=100)] = 20,
    db: Annotated[Session, Depends(get_db)] = None
):
    """Obtiene todos los tokens de un taller"""
    service = TokenService(db)
    result = service.get_by_workshop(workshop_id, page=page, page_size=page_size)
    
    return paginated_response(
        data=[item.model_dump() for item in result["items"]],
        page=result["page"],
        page_size=result["page_size"],
        total=result["total"]
    )


@router.post("", status_code=status.HTTP_201_CREATED, summary="Crear token")
async def create_token(
    data: TokenCreate,
    db: Annotated[Session, Depends(get_db)] = None
):
    """Crea un nuevo token de acceso"""
    service = TokenService(db)
    token = service.create(data)
    
    return success_response(
        data=token.model_dump(),
        message="Token creado exitosamente"
    )


@router.post("/validate", status_code=status.HTTP_200_OK, summary="Validar token")
async def validate_token(
    data: TokenValidate,
    db: Annotated[Session, Depends(get_db)] = None
):
    """Valida un token de acceso"""
    service = TokenService(db)
    result = service.validate_token(data)
    
    return success_response(
        data=result,
        message="Token válido"
    )


@router.patch("/{token_id}/deactivate", status_code=status.HTTP_200_OK, summary="Desactivar token")
async def deactivate_token(
    token_id: int,
    db: Annotated[Session, Depends(get_db)] = None
):
    """Desactiva un token"""
    service = TokenService(db)
    token = service.deactivate(token_id)
    
    return success_response(
        data=token.model_dump(),
        message="Token desactivado exitosamente"
    )


@router.delete("/{token_id}", status_code=status.HTTP_200_OK, summary="Eliminar token")
async def delete_token(
    token_id: int,
    db: Annotated[Session, Depends(get_db)] = None
):
    """Elimina un token"""
    service = TokenService(db)
    service.delete(token_id)
    
    return success_response(
        data=None,
        message="Token eliminado exitosamente"
    )
