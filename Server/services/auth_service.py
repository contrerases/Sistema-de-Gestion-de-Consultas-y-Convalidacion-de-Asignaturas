from fastapi import HTTPException
from schemas.auth.auth_user_out import AuthUserOut
from crud.auth import login as crud_login, logout as crud_logout, change_password as crud_change_password, get_user_by_email as crud_get_user_by_email, get_user_by_id as crud_get_user_by_id
from config.settings import settings
import bcrypt
import mariadb
import jwt
from datetime import datetime, timedelta

# Configuración JWT
SECRET_KEY = settings.SECRET_KEY
ALGORITHM = settings.ALGORITHM
ACCESS_TOKEN_EXPIRE_MINUTES = settings.ACCESS_TOKEN_EXPIRE_MINUTES

# LOGIN
def login_service(email: str, password: str) -> dict:
    try:
        user = crud_get_user_by_email(email)
        if not user:
            raise HTTPException(status_code=401, detail="Credenciales inválidas.")
        if not bcrypt.checkpw(password.encode('utf-8'), user['password_hash'].encode('utf-8')):
            raise HTTPException(status_code=401, detail="Credenciales inválidas.")
        access_token = create_access_token(data={"sub": user['email'], "id": user['id_auth_user'], "user_type": user['user_type']})
        # Excluye password_hash del usuario expuesto
        user_public = {k: v for k, v in user.items() if k != 'password_hash'}
        return {"access_token": access_token, "token_type": "bearer", "user": user_public}
    except mariadb.Error as e:
        raise HTTPException(status_code=500, detail=str(e))

# LOGOUT
def logout_service(user_id: int) -> bool:
    try:
        crud_logout(user_id)
        return True
    except mariadb.Error as e:
        raise HTTPException(status_code=400, detail=str(e))

# CHANGE PASSWORD
def change_password_service(user_id: int, current_password: str, new_password: str) -> bool:
    try:
        user = crud_get_user_by_id(user_id)
        if not user:
            raise HTTPException(status_code=404, detail="Usuario no encontrado.")
        if not bcrypt.checkpw(current_password.encode('utf-8'), user['password_hash'].encode('utf-8')):
            raise HTTPException(status_code=401, detail="Contraseña actual incorrecta.")
        new_password_hash = bcrypt.hashpw(new_password.encode('utf-8'), bcrypt.gensalt()).decode('utf-8')
        crud_change_password(user_id, user['password_hash'], new_password_hash)
        return True
    except mariadb.Error as e:
        raise HTTPException(status_code=400, detail=str(e))

# GET USER BY EMAIL
def get_user_by_email_service(email: str) -> AuthUserOut:
    try:
        user = crud_get_user_by_email(email)
        if not user:
            raise HTTPException(status_code=404, detail="Usuario no encontrado.")
        return AuthUserOut(**user)
    except mariadb.Error as e:
        raise HTTPException(status_code=500, detail=str(e))

# Utilidad para crear JWT
def create_access_token(data: dict) -> str:
    to_encode = data.copy()
    expire = datetime.utcnow() + timedelta(minutes=ACCESS_TOKEN_EXPIRE_MINUTES)
    to_encode.update({"exp": expire})
    encoded_jwt = jwt.encode(to_encode, SECRET_KEY, algorithm=ALGORITHM)
    return encoded_jwt 