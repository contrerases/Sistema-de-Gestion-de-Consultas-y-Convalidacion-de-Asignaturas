"""
Endpoints REST para USER_TYPES
Sistema: SGSCT
"""
from typing import Annotated
from fastapi import APIRouter, Depends, status, Query
from sqlalchemy.orm import Session
from src.database.sessions import get_db
from src.modules.catalog.user_types.service import UserTypeService
from src.modules.catalog.user_types.schemas import UserTypeCreate, UserTypeUpdate
from src.modules.auth.dependencies import require_admin
from src.modules.users.models import User
from src.core.responses import success_response, paginated_response

router = APIRouter(prefix="/user-types", tags=["Tipos de Usuario"])


@router.get("", status_code=status.HTTP_200_OK, summary="Listar tipos de usuario")
async def get_user_types(
    page: Annotated[int, Query(ge=1)] = 1,
    page_size: Annotated[int, Query(ge=1, le=100)] = 20,
    db: Annotated[Session, Depends(get_db)] = None
):
    service = UserTypeService(db)
    result = service.get_all(page=page, page_size=page_size)
    
    return paginated_response(
        data=[item.model_dump() for item in result["items"]],
        page=result["page"],
        page_size=result["page_size"],
        total=result["total"]
    )


@router.get("/{user_type_id}", status_code=status.HTTP_200_OK, summary="Obtener tipo de usuario")
async def get_user_type(
    user_type_id: int,
    db: Annotated[Session, Depends(get_db)] = None
):
    service = UserTypeService(db)
    user_type = service.get_by_id(user_type_id)
    
    return success_response(
        data=user_type.model_dump(),
        message="Tipo de usuario obtenido exitosamente"
    )


@router.post("", status_code=status.HTTP_201_CREATED, summary="Crear tipo de usuario (admin)")
async def create_user_type(
    data: UserTypeCreate,
    db: Annotated[Session, Depends(get_db)] = None,
    admin: Annotated[User, Depends(require_admin)] = None
):
    service = UserTypeService(db)
    user_type = service.create(data)
    
    return success_response(
        data=user_type.model_dump(),
        message="Tipo de usuario creado exitosamente"
    )


@router.put("/{user_type_id}", status_code=status.HTTP_200_OK, summary="Actualizar tipo de usuario (admin)")
async def update_user_type(
    user_type_id: int,
    data: UserTypeUpdate,
    db: Annotated[Session, Depends(get_db)] = None,
    admin: Annotated[User, Depends(require_admin)] = None
):
    service = UserTypeService(db)
    user_type = service.update(user_type_id, data)
    
    return success_response(
        data=user_type.model_dump(),
        message="Tipo de usuario actualizado exitosamente"
    )


@router.delete("/{user_type_id}", status_code=status.HTTP_200_OK, summary="Eliminar tipo de usuario (admin)")
async def delete_user_type(
    user_type_id: int,
    db: Annotated[Session, Depends(get_db)] = None,
    admin: Annotated[User, Depends(require_admin)] = None
):
    service = UserTypeService(db)
    service.delete(user_type_id)
    
    return success_response(
        data=None,
        message="Tipo de usuario eliminado exitosamente"
    )
