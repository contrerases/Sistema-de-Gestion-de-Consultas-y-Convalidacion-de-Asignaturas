"""
Módulo de seguridad: JWT, hashing de contraseñas
"""
from datetime import datetime, timedelta, timezone
from typing import Dict, Any, Optional
from jose import JWTError, jwt
from passlib.context import CryptContext
from src.app.settings import get_settings
from src.core.exceptions import SGSCTException
from src.monitoring.logging import get_logger

logger = get_logger(__name__)
settings = get_settings()

# Contexto para hashing de contraseñas
pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")


# =============================================================================
# PASSWORD HASHING
# =============================================================================

def hash_password(password: str) -> str:
    """
    Hashea una contraseña usando bcrypt
    
    Args:
        password: Contraseña en texto plano
        
    Returns:
        Hash de la contraseña
        
    Raises:
        ValueError: Si la contraseña está vacía
    """
    if not password or not password.strip():
        raise ValueError("La contraseña no puede estar vacía")
    
    return pwd_context.hash(password)


def verify_password(plain_password: str, hashed_password: str) -> bool:
    """
    Verifica si una contraseña coincide con su hash
    
    Args:
        plain_password: Contraseña en texto plano
        hashed_password: Hash almacenado
        
    Returns:
        True si coinciden, False en caso contrario
    """
    if not plain_password or not hashed_password:
        return False
    
    try:
        return pwd_context.verify(plain_password, hashed_password)
    except Exception as e:
        logger.error(f"Error verificando contraseña: {e}")
        return False


# =============================================================================
# JWT TOKENS
# =============================================================================

def create_access_token(
    data: Dict[str, Any],
    expires_delta: Optional[timedelta] = None
) -> str:
    """
    Crea un token JWT de acceso
    
    Args:
        data: Datos a codificar en el token (debe incluir 'sub' con ID de usuario)
        expires_delta: Tiempo de expiración personalizado
        
    Returns:
        Token JWT codificado
        
    Raises:
        ValueError: Si los datos están vacíos
    """
    if not data:
        raise ValueError("Los datos del token no pueden estar vacíos")
    
    if "sub" not in data:
        raise ValueError("El token debe incluir 'sub' (subject/user_id)")
    
    to_encode = data.copy()
    
    # Calcular tiempo de expiración
    if expires_delta:
        expire = datetime.now(timezone.utc) + expires_delta
    else:
        expire = datetime.now(timezone.utc) + timedelta(
            minutes=settings.ACCESS_TOKEN_EXPIRE_MINUTES
        )
    
    to_encode.update({
        "exp": expire,
        "iat": datetime.now(timezone.utc),
        "type": "access"
    })
    
    try:
        encoded_jwt = jwt.encode(
            to_encode,
            settings.SECRET_KEY,
            algorithm=settings.ALGORITHM
        )
        logger.debug(f"Token creado para user_id: {data.get('sub')}")
        return encoded_jwt
    except Exception as e:
        logger.error(f"Error creando token: {e}")
        raise ValueError(f"Error al crear el token: {str(e)}")


def create_refresh_token(user_id: int) -> str:
    """
    Crea un token JWT de refresco
    
    Args:
        user_id: ID del usuario
        
    Returns:
        Token JWT de refresco
    """
    data = {"sub": str(user_id), "type": "refresh"}
    expire = datetime.now(timezone.utc) + timedelta(
        days=settings.REFRESH_TOKEN_EXPIRE_DAYS
    )
    
    to_encode = data.copy()
    to_encode.update({
        "exp": expire,
        "iat": datetime.now(timezone.utc)
    })
    
    return jwt.encode(
        to_encode,
        settings.SECRET_KEY,
        algorithm=settings.ALGORITHM
    )


def decode_token(token: str) -> Dict[str, Any]:
    """
    Decodifica un token JWT y retorna el payload
    
    Args:
        token: Token JWT a decodificar
        
    Returns:
        Payload decodificado
        
    Raises:
        SGSCTException: Si el token es inválido o expirado
    """
    if not token or not token.strip():
        raise SGSCTException(
            status_code=401,
            message="Token requerido"
        )
    
    try:
        payload = jwt.decode(
            token,
            settings.SECRET_KEY,
            algorithms=[settings.ALGORITHM]
        )
        return payload
        
    except jwt.ExpiredSignatureError:
        raise SGSCTException(
            status_code=401,
            message="Token expirado"
        )
    except jwt.JWTClaimsError:
        raise SGSCTException(
            status_code=401,
            message="Claims del token inválidos"
        )
    except JWTError as e:
        logger.warning(f"Error JWT: {e}")
        raise SGSCTException(
            status_code=401,
            message="Token inválido"
        )
    except Exception as e:
        logger.error(f"Error decodificando token: {e}")
        raise SGSCTException(
            status_code=500,
            message="Error al procesar el token"
        )


def verify_token(token: str) -> bool:
    """
    Verifica si un token es válido
    
    Args:
        token: Token a verificar
        
    Returns:
        True si el token es válido, False en caso contrario
    """
    try:
        decode_token(token)
        return True
    except SGSCTException:
        return False


def extract_user_id_from_token(token: str) -> int:
    """
    Extrae el ID de usuario desde un token JWT
    
    Args:
        token: Token JWT
        
    Returns:
        ID del usuario
        
    Raises:
        SGSCTException: Si el token es inválido o no contiene user_id
    """
    payload = decode_token(token)
    
    user_id = payload.get("sub")
    if user_id is None:
        raise SGSCTException(
            status_code=401,
            message="Token inválido: falta información del usuario"
        )
    
    try:
        return int(user_id)
    except (ValueError, TypeError):
        raise SGSCTException(
            status_code=401,
            message="Token inválido: ID de usuario inválido"
        )


# =============================================================================
# HELPERS
# =============================================================================

def validate_token_format(token: str) -> bool:
    """
    Valida el formato básico de un token JWT
    
    Args:
        token: Token a validar
        
    Returns:
        True si el formato es válido
    """
    if not token or not isinstance(token, str):
        return False
    
    # JWT tiene 3 partes separadas por puntos
    parts = token.split(".")
    return len(parts) == 3
