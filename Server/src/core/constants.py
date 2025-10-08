"""
Constantes de configuración del sistema SGSCT
Sistema de Gestión de Consultas y Convalidaciones de Talleres

IMPORTANTE: Este archivo contiene SOLO configuración de la aplicación.
Para identificadores de catálogos (estados, tipos, etc.) ver enums.py
Los IDs de base de datos NO deben hardcodearse aquí.
"""

# =============================================================================
# INFORMACIÓN DEL SISTEMA
# =============================================================================

SYSTEM_NAME = "SGSCT"
SYSTEM_FULL_NAME = "Sistema de Gestión de Consultas y Convalidaciones de Talleres"
SYSTEM_VERSION = "1.0.0"
SYSTEM_DESCRIPTION = "Sistema para gestionar consultas de estudiantes y convalidaciones de talleres del Departamento de Informática"

# =============================================================================
# PERÍODOS ACADÉMICOS
# =============================================================================

class AcademicYear:
    """Configuración de años académicos válidos"""
    MIN_YEAR = 2020
    MAX_YEAR = 2100
    
    @staticmethod
    def is_valid(year: int) -> bool:
        """Valida si el año académico es válido"""
        return AcademicYear.MIN_YEAR <= year <= AcademicYear.MAX_YEAR

# =============================================================================
# SEMESTRES
# =============================================================================

class Semester:
    """Configuración de semestres académicos válidos"""
    VALID_SEMESTERS = [1, 2]

    @staticmethod
    def is_valid(semester: int) -> bool:
        """Valida si el semestre académico es válido"""
        return semester in Semester.VALID_SEMESTERS

# =============================================================================
# VALIDACIÓN Y FORMATOS
# =============================================================================

class ValidationRules:
    """Reglas de validación del sistema"""
    # RUT
    RUT_MIN_LENGTH = 8  # 7 dígitos + verificador
    RUT_MAX_LENGTH = 9  # 8 dígitos + verificador
    
    # ROL (Rol único estudiantil)
    ROL_LENGTH = 10  # Exactamente 10 dígitos
    
    # Email
    EMAIL_MAX_LENGTH = 255
    EMAIL_PATTERN = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$'
    
    # Nombres
    NAME_MAX_LENGTH = 255
    NAME_MIN_LENGTH = 2
    
    # Contraseñas
    PASSWORD_MIN_LENGTH = 8
    PASSWORD_MAX_LENGTH = 128
    
    # Teléfonos
    PHONE_MAX_LENGTH = 15
    
    # Años académicos
    YEAR_MIN = 2020
    YEAR_MAX = 2100
    
    # Talleres
    WORKSHOP_MIN_INSCRIPTIONS_PERCENTAGE = 0.5  # 50% del cupo mínimo
    WORKSHOP_MAX_CAPACITY = 200
    WORKSHOP_MIN_CAPACITY = 5
    
    # Créditos de asignaturas
    CREDITS_MIN = 1
    CREDITS_MAX = 10
    
    # Calificaciones (escala 0-100)
    GRADE_MIN = 0
    GRADE_MAX = 100
    GRADE_PASSING = 55  # Nota mínima de aprobación

# =============================================================================
# ARCHIVOS
# =============================================================================

class FileConfig:
    """Configuración de archivos"""
    MAX_SIZE_BYTES = 10 * 1024 * 1024  # 10 MB
    ALLOWED_EXTENSIONS = ['.pdf']
    ALLOWED_DOCUMENT_EXTENSIONS = ['.pdf']
    UPLOAD_PATH = 'uploads'
    SYLLABUS_PATH = 'uploads/syllabus'
    CONVALIDATION_DOCS_PATH = 'uploads/convalidations'

# =============================================================================
# PAGINACIÓN
# =============================================================================

class Pagination:
    """Constantes de paginación"""
    DEFAULT_PAGE = 1
    DEFAULT_PAGE_SIZE = 20
    MAX_PAGE_SIZE = 100
    MIN_PAGE_SIZE = 1

# =============================================================================
# AUTENTICACIÓN
# =============================================================================

class Auth:
    """Constantes de autenticación"""
    # JWT
    TOKEN_TYPE = "Bearer"
    ACCESS_TOKEN_EXPIRE_MINUTES = 60  # 1 hora
    REFRESH_TOKEN_EXPIRE_DAYS = 7  # 7 días
    ALGORITHM = "HS256"
    
    # Workshop Tokens (para profesores)
    WORKSHOP_TOKEN_LENGTH = 32
    WORKSHOP_TOKEN_EXPIRATION_HOURS = 24
    
    # Bcrypt
    BCRYPT_ROUNDS = 12

# =============================================================================
# MENSAJES DEL SISTEMA
# =============================================================================

class Messages:
    """Mensajes estándar del sistema"""
    # Éxito
    CREATED_SUCCESS = "Creado exitosamente"
    UPDATED_SUCCESS = "Actualizado exitosamente"
    DELETED_SUCCESS = "Eliminado exitosamente"
    OPERATION_SUCCESS = "Operación realizada exitosamente"
    
    # Errores genéricos
    NOT_FOUND = "Recurso no encontrado"
    ALREADY_EXISTS = "El recurso ya existe"
    INVALID_DATA = "Datos inválidos"
    UNAUTHORIZED = "No autorizado"
    FORBIDDEN = "Acceso prohibido"
    INTERNAL_ERROR = "Error interno del servidor"
    
    # Autenticación
    LOGIN_SUCCESS = "Inicio de sesión exitoso"
    LOGOUT_SUCCESS = "Cierre de sesión exitoso"
    INVALID_CREDENTIALS = "Credenciales inválidas"
    TOKEN_EXPIRED = "Token expirado"
    TOKEN_INVALID = "Token inválido"
    
    # Talleres
    WORKSHOP_CREATED = "Taller creado exitosamente"
    WORKSHOP_UPDATED = "Taller actualizado exitosamente"
    WORKSHOP_DELETED = "Taller eliminado exitosamente"
    WORKSHOP_FULL = "El taller ha alcanzado el límite de inscripciones"
    WORKSHOP_MIN_NOT_REACHED = "El taller no alcanzó el mínimo de inscripciones"
    WORKSHOP_CANCELLED = "Taller cancelado"
    INSCRIPTION_SUCCESS = "Inscripción realizada exitosamente"
    INSCRIPTION_CANCELLED = "Inscripción cancelada exitosamente"
    INSCRIPTION_CLOSED = "El período de inscripción ha cerrado"
    INSCRIPTION_NOT_STARTED = "El período de inscripción no ha iniciado"
    GRADE_ASSIGNED = "Calificación asignada exitosamente"
    GRADE_UPDATED = "Calificación actualizada exitosamente"
    ALREADY_INSCRIBED = "Ya estás inscrito en este taller"
    
    # Convalidaciones
    CONVALIDATION_SUBMITTED = "Solicitud de convalidación enviada exitosamente"
    CONVALIDATION_APPROVED = "Convalidación aprobada"
    CONVALIDATION_REJECTED = "Convalidación rechazada"
    CONVALIDATION_SENT_DE = "Convalidación enviada a Dirección de Estudio"
    INVALID_STATE_TRANSITION = "Transición de estado no válida"
    
    # Archivos
    INVALID_FILE_TYPE = "Tipo de archivo no permitido. Formatos permitidos: PDF"
    FILE_TOO_LARGE = "El archivo excede el tamaño máximo permitido (10 MB)"
    FILE_UPLOAD_SUCCESS = "Archivo cargado exitosamente"
    FILE_UPLOAD_ERROR = "Error al cargar el archivo"
    
    # Validación
    INVALID_RUT = "El RUT ingresado no es válido"
    INVALID_ROL = "El ROL ingresado no es válido (debe tener 10 dígitos)"
    INVALID_EMAIL = "El email ingresado no es válido"
    INVALID_GRADE = "La calificación debe estar entre 0 y 100"
    WEAK_PASSWORD = "La contraseña debe tener al menos 8 caracteres"
    REQUIRED_FIELD = "Este campo es obligatorio"
    
    # Base de datos
    DB_CONNECTION_ERROR = "Error de conexión con la base de datos"
    DB_QUERY_ERROR = "Error al ejecutar la consulta"
    
    # Business Rules
    CONVALIDATION_TYPE = "La convalidación debe ser del tipo de curso correspondiente"
    CONVALIDATION_DUPLICATE = "Ya existe una convalidación para este curso en esta solicitud"

# =============================================================================
# CÓDIGOS DE ERROR
# =============================================================================

class ErrorCodes:
    """Códigos de error del sistema"""
    # Errores generales
    INTERNAL_ERROR = "ERR_INTERNAL"
    VALIDATION_ERROR = "ERR_VALIDATION"
    NOT_FOUND = "ERR_NOT_FOUND"
    ALREADY_EXISTS = "ERR_ALREADY_EXISTS"
    FORBIDDEN = "ERR_FORBIDDEN"
    
    # Errores de autenticación
    AUTH_INVALID_CREDENTIALS = "ERR_AUTH_INVALID_CREDENTIALS"
    AUTH_TOKEN_EXPIRED = "ERR_AUTH_TOKEN_EXPIRED"
    AUTH_TOKEN_INVALID = "ERR_AUTH_TOKEN_INVALID"
    AUTH_UNAUTHORIZED = "ERR_AUTH_UNAUTHORIZED"
    
    # Errores de base de datos
    DB_CONNECTION_ERROR = "ERR_DB_CONNECTION"
    DB_QUERY_ERROR = "ERR_DB_QUERY"
    DB_INTEGRITY_ERROR = "ERR_DB_INTEGRITY"
    
    # Errores de negocio
    BUSINESS_RULE_VIOLATION = "ERR_BUSINESS_RULE"
    INVALID_STATE_TRANSITION = "ERR_INVALID_TRANSITION"
    INSUFFICIENT_PERMISSIONS = "ERR_INSUFFICIENT_PERMISSIONS"
    
    # Errores de archivos
    FILE_TOO_LARGE = "ERR_FILE_TOO_LARGE"
    FILE_INVALID_TYPE = "ERR_FILE_INVALID_TYPE"
    FILE_UPLOAD_FAILED = "ERR_FILE_UPLOAD_FAILED"

# =============================================================================
# HTTP STATUS CODES
# =============================================================================

class HTTPStatus:
    """Códigos de estado HTTP utilizados"""
    OK = 200
    CREATED = 201
    NO_CONTENT = 204
    BAD_REQUEST = 400
    UNAUTHORIZED = 401
    FORBIDDEN = 403
    NOT_FOUND = 404
    CONFLICT = 409
    UNPROCESSABLE_ENTITY = 422
    INTERNAL_SERVER_ERROR = 500

# =============================================================================
# PATRONES DE VALIDACIÓN
# =============================================================================

class ValidationPatterns:
    """Patrones regex para validación"""
    # RUT: 7-8 dígitos + dígito verificador (puede ser K)
    RUT = r'^[0-9]{7,8}[0-9kK]$'
    
    # ROL: Exactamente 10 dígitos
    ROL = r'^[0-9]{10}$'
    
    # Email
    EMAIL = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$'
    
    # Teléfono: formato chileno
    PHONE = r'^\+?56?[2-9]\d{8}$'
    
    # Slug (para URLs amigables)
    SLUG = r'^[a-z0-9]+(?:-[a-z0-9]+)*$'

# =============================================================================
# LONGITUDES Y LÍMITES PARA CAMPOS DE BASE DE DATOS
# =============================================================================

class DBLength:
    """
    Límites de longitud para columnas de base de datos.
    Estos valores deben coincidir EXACTAMENTE con las definiciones en database/02_structure.sql
    Usar estas constantes en modelos SQLAlchemy para mantener sincronización.
    """
    
    # Campos comunes
    EMAIL = 255
    PASSWORD_HASH = 255
    SALT = 255
    NAME = 255
    FULL_NAME = 255
    ACRONYM = 255
    LOCATION = 255
    
    # RUT y ROL
    RUT = 12  # formato: 12345678-K
    ROL = 11  # formato: 2019012345
    
    # Talleres
    WORKSHOP_NAME = 255
    WORKSHOP_DESCRIPTION = 1000
    WORKSHOP_SLUG = 255
    SYLLABUS_PATH = 500
    
    # Asignaturas
    SUBJECT_ACRONYM = 255
    SUBJECT_NAME = 255
    
    # Convalidaciones
    REVIEW_COMMENTS = 1000
    ACTIVITY_NAME = 255
    ACTIVITY_DESCRIPTION = 255
    FILE_PATH = 500
    
    # Notificaciones
    NOTIFICATION_TYPE = 50
    NOTIFICATION_MESSAGE = 1000
    
    # Tokens
    TOKEN = 255
    
    # User types
    USER_TYPE = 50

class Limits:
    """Límites de longitud para validación y uso general"""
    DESCRIPTION_MAX = 1000
    COMMENT_MAX = 1000
    MESSAGE_MAX = 1000
    TITLE_MAX = 255
    NAME_MAX = 255
    ACRONYM_MAX = 10
    SLUG_MAX = 255
    PATH_MAX = 500
    TOKEN_MAX = 255

# =============================================================================
# CONFIGURACIÓN DE TESTING
# =============================================================================

class TestConfig:
    """Configuración para ambiente de testing"""
    TEST_STUDENT_EMAIL = 'estudiante.test@usm.cl'
    TEST_ADMIN_EMAIL = 'admin.test@usm.cl'
    TEST_STUDENT_RUT = '12345678K'
    TEST_STUDENT_ROL = '2019012345'
    TEST_PASSWORD = 'Test1234!'

# =============================================================================
# CONFIGURACIÓN DE LOGGING
# =============================================================================

class LogConfig:
    """Configuración de logging"""
    FORMAT = '%(asctime)s - %(name)s - %(levelname)s - %(message)s'
    DATE_FORMAT = '%Y-%m-%d %H:%M:%S'
    MAX_BYTES = 10 * 1024 * 1024  # 10 MB por archivo
    BACKUP_COUNT = 5
    LOG_FILE = 'logs/sgsct.log'
    ERROR_LOG_FILE = 'logs/sgsct_error.log'