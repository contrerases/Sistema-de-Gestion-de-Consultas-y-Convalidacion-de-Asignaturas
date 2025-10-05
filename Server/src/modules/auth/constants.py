"""
Constantes específicas del módulo Auth
Autenticación y seguridad
"""

# =============================================================================
# AUTENTICACIÓN
# =============================================================================

class Authentication:
    """Constantes para autenticación"""
    
    # JWT
    ALGORITHM = "HS256"
    TOKEN_TYPE = "Bearer"
    ACCESS_TOKEN_EXPIRE_MINUTES = 60
    REFRESH_TOKEN_EXPIRE_DAYS = 30
    
    # Password hashing
    HASH_ALGORITHM = "bcrypt"
    BCRYPT_ROUNDS = 12
    
    # Validación de contraseñas
    PASSWORD_MIN_LENGTH = 8
    PASSWORD_MAX_LENGTH = 128
    PASSWORD_REQUIRE_UPPERCASE = True
    PASSWORD_REQUIRE_LOWERCASE = True
    PASSWORD_REQUIRE_DIGIT = True
    PASSWORD_REQUIRE_SPECIAL = False
    
    # Intentos de login
    MAX_LOGIN_ATTEMPTS = 5
    LOCKOUT_DURATION_MINUTES = 15
    
    # Mensajes
    MSG_LOGIN_SUCCESS = "Login exitoso"
    MSG_LOGOUT_SUCCESS = "Logout exitoso"
    MSG_INVALID_CREDENTIALS = "Credenciales inválidas"
    MSG_USER_NOT_FOUND = "Usuario no encontrado"
    MSG_USER_INACTIVE = "Usuario inactivo"
    MSG_USER_LOCKED = "Usuario bloqueado por múltiples intentos fallidos"
    MSG_PASSWORD_CHANGED = "Contraseña cambiada exitosamente"
    MSG_PASSWORD_RESET = "Contraseña restablecida exitosamente"
    MSG_WEAK_PASSWORD = "La contraseña no cumple con los requisitos mínimos"
    MSG_TOKEN_EXPIRED = "Token expirado"
    MSG_TOKEN_INVALID = "Token inválido"
    MSG_UNAUTHORIZED = "No autorizado"
    MSG_FORBIDDEN = "Acceso prohibido"

# =============================================================================
# SESIONES
# =============================================================================

class Session:
    """Constantes para sesiones"""
    
    # Duración de sesión
    SESSION_TIMEOUT_MINUTES = 120  # 2 horas
    
    # Refresh de sesión
    SESSION_REFRESH_THRESHOLD_MINUTES = 10
    
    # Mensajes
    MSG_SESSION_EXPIRED = "Sesión expirada"
    MSG_SESSION_INVALID = "Sesión inválida"
    MSG_SESSION_REFRESHED = "Sesión renovada"

# =============================================================================
# PERMISOS
# =============================================================================

class Permissions:
    """Constantes para permisos"""
    
    # Acciones
    CREATE = "create"
    READ = "read"
    UPDATE = "update"
    DELETE = "delete"
    
    # Permisos especiales
    APPROVE = "approve"
    REVIEW = "review"
    MANAGE = "manage"
    
    # Recursos
    RESOURCE_WORKSHOPS = "workshops"
    RESOURCE_CONVALIDATIONS = "convalidations"
    RESOURCE_STUDENTS = "students"
    RESOURCE_ADMINISTRATORS = "administrators"
    RESOURCE_SUBJECTS = "subjects"
    RESOURCE_DEPARTMENTS = "departments"
    RESOURCE_CURRICULUM_SLOTS = "curriculum_slots"
    
    # Mensajes
    MSG_PERMISSION_DENIED = "Permiso denegado"
    MSG_INSUFFICIENT_PERMISSIONS = "Permisos insuficientes"
    MSG_INVALID_PERMISSION = "Permiso inválido"

# =============================================================================
# ROLES
# =============================================================================

class Roles:
    """Constantes para roles de usuario"""
    
    # Roles del sistema
    STUDENT = "STUDENT"
    ADMINISTRATOR = "ADMINISTRATOR"
    SUPER_ADMIN = "SUPER_ADMIN"
    
    # Permisos por rol
    STUDENT_PERMISSIONS = {
        "workshops": ["read", "inscribe"],
        "convalidations": ["create", "read", "update"],  # Solo propias
        "requests": ["create", "read", "update"],  # Solo propias
        "grades": ["read"],  # Solo propias
        "profile": ["read", "update"]  # Solo propio
    }
    
    ADMINISTRATOR_PERMISSIONS = {
        "workshops": ["create", "read", "update", "delete"],
        "convalidations": ["read", "review", "approve"],
        "requests": ["read", "update", "resolve"],
        "students": ["read"],
        "grades": ["create", "read", "update"],
        "subjects": ["create", "read", "update", "delete"],
        "curriculum_slots": ["create", "read", "update", "delete"]
    }
    
    SUPER_ADMIN_PERMISSIONS = {
        "*": ["*"]  # Todos los permisos
    }

# =============================================================================
# SEGURIDAD
# =============================================================================

class Security:
    """Constantes de seguridad"""
    
    # Headers de seguridad
    SECURITY_HEADERS = {
        "X-Content-Type-Options": "nosniff",
        "X-Frame-Options": "DENY",
        "X-XSS-Protection": "1; mode=block",
        "Strict-Transport-Security": "max-age=31536000; includeSubDomains"
    }
    
    # CORS
    ALLOWED_ORIGINS = ["http://localhost:5173", "http://localhost:3000"]
    ALLOW_CREDENTIALS = True
    ALLOWED_METHODS = ["GET", "POST", "PUT", "DELETE", "PATCH"]
    ALLOWED_HEADERS = ["*"]
    
    # Rate limiting
    RATE_LIMIT_REQUESTS = 100
    RATE_LIMIT_WINDOW_SECONDS = 60
    
    # Mensajes
    MSG_RATE_LIMIT_EXCEEDED = "Límite de solicitudes excedido"
    MSG_CORS_ERROR = "Error de CORS"
    MSG_CSRF_ERROR = "Error de CSRF"

# =============================================================================
# SALT Y TOKENS
# =============================================================================

class Tokens:
    """Constantes para tokens y salt"""
    
    # Salt para hashing
    SALT_LENGTH = 32
    
    # Reset tokens
    RESET_TOKEN_LENGTH = 64
    RESET_TOKEN_EXPIRE_HOURS = 24
    
    # Verification tokens
    VERIFICATION_TOKEN_LENGTH = 64
    VERIFICATION_TOKEN_EXPIRE_HOURS = 48
    
    # API tokens
    API_TOKEN_LENGTH = 64
    
    # Mensajes
    MSG_TOKEN_SENT = "Token enviado exitosamente"
    MSG_TOKEN_VERIFIED = "Token verificado exitosamente"
    MSG_TOKEN_EXPIRED = "Token expirado"
    MSG_TOKEN_INVALID = "Token inválido"
