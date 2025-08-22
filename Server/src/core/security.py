from datetime import datetime, timedelta
from typing import Dict, Any, Optional
from jose import JWTError, jwt
from passlib.context import CryptContext
from core.config import settings
from core.exceptions import (
    UnauthorizedException,
    AuthenticationException,
    ValidationException
)
from schemas.auth_user import AuthUser

# Configuración para hashing de contraseñas
pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")

def hash_password(password: str) -> str:
    """Hashea una contraseña usando bcrypt"""
    if not password:
        raise ValidationException("La contraseña no puede estar vacía")
    return pwd_context.hash(password + settings.SALT)

def verify_password(plain_password: str, hashed_password: str) -> bool:
    """Verifica si una contraseña coincide con su hash"""
    if not plain_password or not hashed_password:
        return False
    return pwd_context.verify(plain_password + settings.SALT, hashed_password)

def create_access_token(data: Dict[str, Any], expires_delta: Optional[timedelta] = None) -> str:
    """Crea un token JWT de acceso"""
    if not data:
        raise ValidationException("Los datos del token no pueden estar vacíos")
    
    to_encode = data.copy()
    if expires_delta:
        expire = datetime.utcnow() + expires_delta
    else:
        expire = datetime.utcnow() + timedelta(minutes=settings.ACCESS_TOKEN_EXPIRE_MINUTES)
    
    to_encode.update({"exp": expire})
    
    try:
        encoded_jwt = jwt.encode(to_encode, settings.SECRET_KEY, algorithm=settings.ALGORITHM)
        return encoded_jwt
    except Exception as e:
        raise AuthenticationException(f"Error al crear el token: {str(e)}")

def decode_access_token(token: str) -> Dict[str, Any]:
    """Decodifica un token JWT y retorna el payload"""
    if not token:
        raise UnauthorizedException("Token requerido")
    
    try:
        payload = jwt.decode(token, settings.SECRET_KEY, algorithms=[settings.ALGORITHM])
        return payload
    except jwt.ExpiredSignatureError:
        raise UnauthorizedException("Token expirado")
    except jwt.JWTClaimsError:
        raise UnauthorizedException("Claims del token inválidos")
    except jwt.JWTError:
        raise UnauthorizedException("Token inválido")
    except Exception as e:
        raise AuthenticationException(f"Error al decodificar token: {str(e)}")

def extract_user_from_token(token: str) -> AuthUser:
    """Extrae información del usuario desde un token JWT y retorna un modelo AuthUser"""
    if not token:
        raise UnauthorizedException("Token requerido")
    
    if not validate_token_format(token):
        raise UnauthorizedException("Formato de token inválido")
    
    try:
        payload = decode_access_token(token)
        
        # Verificar que el token no haya expirado
        exp = payload.get("exp")
        if exp is None:
            raise UnauthorizedException("Token sin fecha de expiración")
        
        if datetime.utcnow().timestamp() > exp:
            raise UnauthorizedException("Token expirado")
        
        # Extraer información del usuario
        id_user = payload.get("sub")
        if id_user is None:
            raise UnauthorizedException("Token inválido: falta información del usuario")
        
        email = payload.get("email")
        if not email:
            raise UnauthorizedException("Token inválido: falta email del usuario")
        
        user_type = payload.get("user_type")
        if not user_type:
            raise UnauthorizedException("Token inválido: falta tipo de usuario")
        
        campus = payload.get("campus")
        if not campus:
            raise UnauthorizedException("Token inválido: falta campus del usuario")
        
        # Crear y retornar el modelo AuthUser
        return AuthUser(
            id_user=id_user,
            email=email,
            rut=payload.get("rut"),
            rol_student=payload.get("rol_student"),
            user_type=user_type,
            name=payload.get("name"),
            campus=campus,
            exp=exp
        )
        
    except (UnauthorizedException, AuthenticationException):
        # Re-lanzar excepciones personalizadas
        raise
    except JWTError as e:
        raise UnauthorizedException(f"Error al procesar token: {str(e)}")
    except Exception as e:
        raise AuthenticationException(f"Error inesperado al extraer usuario: {str(e)}")

def create_user_token(user_data: Dict[str, Any]) -> str:
    """Crea un token para un usuario específico"""
    if not user_data:
        raise ValidationException("Datos del usuario requeridos")
    
    required_fields = ["id", "email", "user_type", "campus"]
    missing_fields = [field for field in required_fields if field not in user_data]
    
    if missing_fields:
        raise ValidationException(f"Campos requeridos faltantes: {', '.join(missing_fields)}")
    
    token_data = {
        "sub": str(user_data["id"]),
        "email": user_data["email"],
        "user_type": user_data["user_type"],
        "campus": user_data["campus"],
        "name": user_data.get("name", ""),
        "rut": user_data.get("rut"),
        "rol_student": user_data.get("rol_student")
    }
    
    return create_access_token(token_data)

def validate_token_format(token: str) -> bool:
    """Valida el formato básico de un token JWT"""
    if not token or not isinstance(token, str):
        return False
    
    try:
        parts = token.split(".")
        return len(parts) == 3 and all(part for part in parts)
    except Exception:
        return False

def validate_password_strength(password: str) -> bool:
    """Valida la fortaleza de una contraseña"""
    if not password:
        raise ValidationException("La contraseña es requerida")
    
    if len(password) < 8:
        raise ValidationException("La contraseña debe tener al menos 8 caracteres")
    
    if not any(c.isupper() for c in password):
        raise ValidationException("La contraseña debe contener al menos una letra mayúscula")
    
    if not any(c.islower() for c in password):
        raise ValidationException("La contraseña debe contener al menos una letra minúscula")
    
    if not any(c.isdigit() for c in password):
        raise ValidationException("La contraseña debe contener al menos un número")
    
    return True

def extract_token_from_header(authorization_header: str) -> str:
    """Extrae el token del header de autorización"""
    if not authorization_header:
        raise UnauthorizedException("Header de autorización requerido")
    
    if not authorization_header.startswith("Bearer "):
        raise UnauthorizedException("Formato de autorización inválido. Use 'Bearer <token>'")
    
    token = authorization_header.replace("Bearer ", "").strip()
    if not token:
        raise UnauthorizedException("Token vacío en header de autorización")
    
    return token