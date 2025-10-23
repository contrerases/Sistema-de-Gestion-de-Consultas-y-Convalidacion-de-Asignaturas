"""
Router para USER_TYPES
"""

from fastapi import APIRouter, Depends, status
from sqlalchemy.orm import Session
from src.database.sessions import get_db
from src.modules.users.types.schemas import (
    UserTypeCreate,
    UserTypeUpdate,
    UserTypeResponse,
)
from .services import UserTypeServices
from src.core.responses import PaginatedResponse

router = APIRouter(prefix="/types", tags=["User Types"])


@router.get(
    "",
    response_model=PaginatedResponse[UserTypeResponse],
    status_code=status.HTTP_200_OK,
)
def list_user_types(db: Session = Depends(get_db)):
    service = UserTypeServices(db)
    return [UserTypeResponse.model_validate(ut) for ut in service.get_all()]


@router.get(
    "/{id_type}", response_model=UserTypeResponse, status_code=status.HTTP_200_OK
)
def get_user_type(id_type: int, db: Session = Depends(get_db)):
    service = UserTypeServices(db)
    return UserTypeResponse.model_validate(service.get_by_id(id_type))


@router.post("", status_code=status.HTTP_201_CREATED)
def create_user_type(data: UserTypeCreate, db: Session = Depends(get_db)):
    service = UserTypeServices(db)
    return UserTypeResponse.model_validate(service.create(data))


@router.put("/{id_type}", status_code=status.HTTP_200_OK)
def update_user_type(id_type: int, data: UserTypeUpdate, db: Session = Depends(get_db)):
    service = UserTypeServices(db)
    return UserTypeResponse.model_validate(service.update(id_type, data))


@router.delete("/{id_type}", status_code=status.HTTP_204_NO_CONTENT)
def delete_user_type(id_type: int, db: Session = Depends(get_db)):
    service = UserTypeServices(db)
    service.delete(id_type)
    return None
