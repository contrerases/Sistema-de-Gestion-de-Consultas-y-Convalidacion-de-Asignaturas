from fastapi import APIRouter, Depends, HTTPException, status
from services.auth_service import login_service, change_password_service, reset_password_service, get_user_by_email_service
from schemas.auth.auth_user_out import AuthUserOut
from fastapi.security import OAuth2PasswordRequestForm
from typing import Dict
from schemas.auth.change_password_in import ChangePasswordIn
from schemas.auth.login_out import LoginOut
from pydantic import EmailStr

router = APIRouter(prefix="/auth", tags=["auth"])

@router.post("/login/", response_model=LoginOut)
def login(form_data: OAuth2PasswordRequestForm = Depends()):
    """Autentica un usuario y genera token JWT"""
    return login_service(form_data.username, form_data.password)

@router.put("/change-password/", response_model=bool)
def change_password(data: ChangePasswordIn):
    """Cambia la contraseña de un usuario"""
    return change_password_service(data.user_id, data.current_password, data.new_password)

@router.put("/reset-password/", response_model=bool)
def reset_password(email: EmailStr, new_password: str):
    """Resetea la contraseña de un usuario"""
    return reset_password_service(email, new_password)

@router.get("/user-by-email", response_model=AuthUserOut)
def get_user_by_email(email: EmailStr):
    return get_user_by_email_service(email) 