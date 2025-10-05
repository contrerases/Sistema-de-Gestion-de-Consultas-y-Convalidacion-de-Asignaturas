"""
Constantes generales del sistema SGSCT
Sistema de Gestión de Consultas y Convalidaciones de Talleres

Este archivo contiene constantes globales utilizadas en toda la aplicación.
Para constantes específicas de módulos, ver src/modules/<modulo>/constants.py
"""

# =============================================================================
# INFORMACIÓN DEL SISTEMA
# =============================================================================

SYSTEM_NAME = "SGSCT"
SYSTEM_FULL_NAME = "Sistema de Gestión de Consultas y Convalidaciones de Talleres"
SYSTEM_VERSION = "1.0.0"
SYSTEM_DESCRIPTION = "Sistema para gestionar consultas de estudiantes y convalidaciones de talleres del Departamento de Informática"

# =============================================================================
# CAMPUS UNIVERSITARIOS
# =============================================================================

class Campus:
    """IDs de campus universitarios"""
    CASA_CENTRAL = 1
    SAN_JOAQUIN = 2
    VITACURA = 3
    
    ACRONYMS = {1: "CC", 2: "SJ", 3: "VSM"}
    NAMES = {1: "CASA CENTRAL", 2: "SAN JOAQUIN", 3: "VITACURA"}
    LOCATIONS = {1: "VALPARAISO", 2: "SANTIAGO", 3: "SANTIAGO"}

# =============================================================================
# TIPOS DE USUARIO
# =============================================================================

class UserType:
    """IDs de tipos de usuario"""
    STUDENT = 1
    ADMINISTRATOR = 2
    
    NAMES = {1: "STUDENT", 2: "ADMINISTRATOR"}
    LABELS = {1: "Estudiante", 2: "Administrador"}

# =============================================================================
# ESTADOS DE TALLERES
# =============================================================================

class WorkshopState:
    """IDs de estados de talleres"""
    INSCRIPCION = 1
    EN_CURSO = 2
    FINALIZADO = 3
    CERRADO = 4
    CANCELADO = 5
    
    NAMES = {1: "INSCRIPCION", 2: "EN_CURSO", 3: "FINALIZADO", 4: "CERRADO", 5: "CANCELADO"}
    LABELS = {1: "Inscripción", 2: "En Curso", 3: "Finalizado", 4: "Cerrado", 5: "Cancelado"}
    CANCELABLE_STATES = [1]  # Solo desde INSCRIPCION
    
    VALID_TRANSITIONS = {
        1: [2, 5],  # INSCRIPCION -> EN_CURSO o CANCELADO
        2: [3],     # EN_CURSO -> FINALIZADO
        3: [4],     # FINALIZADO -> CERRADO
        4: [],      # CERRADO (final)
        5: []       # CANCELADO (final)
    }

# =============================================================================
# ESTADOS DE CONVALIDACIONES
# =============================================================================

class ConvalidationState:
    """IDs de estados de convalidaciones"""
    ENVIADA = 1
    RECHAZADA_DI = 2
    APROBADA_DI = 3
    ENVIADA_DE = 4
    RECHAZADA_DE = 5
    APROBADA_DE = 6
    
    NAMES = {1: "ENVIADA", 2: "RECHAZADA_DI", 3: "APROBADA_DI", 4: "ENVIADA_DE", 5: "RECHAZADA_DE", 6: "APROBADA_DE"}
    LABELS = {1: "Enviada", 2: "Rechazada por DI", 3: "Aprobada por DI", 4: "Enviada a DE", 5: "Rechazada por DE", 6: "Aprobada por DE"}
    
    VALID_TRANSITIONS = {
        1: [2, 3, 4],  # ENVIADA -> RECHAZADA_DI, APROBADA_DI o ENVIADA_DE
        2: [],         # RECHAZADA_DI (final)
        3: [],         # APROBADA_DI (final)
        4: [5, 6],     # ENVIADA_DE -> RECHAZADA_DE o APROBADA_DE
        5: [],         # RECHAZADA_DE (final)
        6: []          # APROBADA_DE (final)
    }
    
    FINAL_STATES = [2, 3, 5, 6]
    DI_ACTIONABLE = [1]
    DE_ACTIONABLE = [4]

# =============================================================================
# TIPOS DE CONVALIDACIONES
# =============================================================================

class ConvalidationType:
    """IDs de tipos de convalidaciones"""
    ELECTIVO_DI = 1
    ASIGNATURA_EXTERNA_DI = 2
    TALLER_DI = 3
    PROYECTO_PERSONAL = 4
    CURSO_CERTIFICADO = 5
    OTRO = 6
    
    NAMES = {1: "ELECTIVO DI", 2: "ASIGNATURA EXTERNA DI", 3: "TALLER DI", 4: "PROYECTO PERSONAL", 5: "CURSO CERTIFICADO", 6: "OTRO"}

# =============================================================================
# TIPOS DE CURSOS CURRICULARES
# =============================================================================

class CurriculumCourseType:
    """IDs de tipos de casillas curriculares"""
    LIBRE = 1
    ELECTIVO_INFORMATICA = 2
    ELECTIVO = 3
    
    NAMES = {1: "LIBRE", 2: "ELECTIVO INFORMATICA", 3: "ELECTIVO"}

# =============================================================================
# DEPARTAMENTOS
# =============================================================================

class Department:
    """IDs de departamentos"""
    INFORMATICA = 1
    QUIMICA = 2
    ELECTRONICA = 3
    DEFIDER = 4
    ESTUDIOS_HUMANISTICOS = 5
    MATEMATICA = 6
    
    NAMES = {1: "INFORMATICA", 2: "QUIMICA", 3: "ELECTRONICA", 4: "DEFIDER", 5: "ESTUDIOS HUMANISTICOS", 6: "MATEMATICA"}

# =============================================================================
# VALIDACIÓN Y FORMATOS
# =============================================================================

class ValidationRules:
    """Reglas de validación del sistema"""
    RUT_MIN_LENGTH = 8
    RUT_MAX_LENGTH = 9
    ROL_MIN_LENGTH = 7
    ROL_MAX_LENGTH = 10
    EMAIL_MAX_LENGTH = 255
    NAME_MAX_LENGTH = 255
    PASSWORD_MIN_LENGTH = 8
    PHONE_MAX_LENGTH = 15
    WORKSHOP_MIN_INSCRIPTIONS = 1
    WORKSHOP_MAX_CAPACITY = 100
    GRADE_MIN = 1.0
    GRADE_MAX = 7.0
    GRADE_PASSING = 4.0

# =============================================================================
# ARCHIVOS
# =============================================================================

MAX_FILE_SIZE_BYTES = 10 * 1024 * 1024  # 10 MB
ALLOWED_FILE_EXTENSIONS = ['.pdf']

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
    TOKEN_TYPE = "Bearer"
    TOKEN_EXPIRE_MINUTES = 60
    ALGORITHM = "HS256"
    WORKSHOP_TOKEN_LENGTH = 32
    TOKEN_EXPIRATION_HOURS = 24
    REFRESH_TOKEN_EXPIRATION_DAYS = 30

# =============================================================================
# MENSAJES DEL SISTEMA
# =============================================================================

class Messages:
    """Mensajes estándar del sistema"""
    # Éxito
    CREATED_SUCCESS = "Creado exitosamente"
    UPDATED_SUCCESS = "Actualizado exitosamente"
    DELETED_SUCCESS = "Eliminado exitosamente"
    
    # Errores genéricos
    NOT_FOUND = "Recurso no encontrado"
    ALREADY_EXISTS = "El recurso ya existe"
    INVALID_DATA = "Datos inválidos"
    UNAUTHORIZED = "No autorizado"
    FORBIDDEN = "Acceso prohibido"
    
    # Talleres
    WORKSHOP_CREATED = "Taller creado exitosamente"
    WORKSHOP_FULL = "El taller ha alcanzado el límite de inscripciones"
    INSCRIPTION_SUCCESS = "Inscripción realizada exitosamente"
    INSCRIPTION_CLOSED = "El período de inscripción ha cerrado"
    GRADE_ASSIGNED = "Calificación asignada exitosamente"
    
    # Convalidaciones
    CONVALIDATION_SUBMITTED = "Solicitud de convalidación enviada"
    
    # Archivos
    INVALID_FILE_TYPE = "Tipo de archivo no permitido"
    FILE_TOO_LARGE = "El archivo excede el tamaño máximo permitido"
    
    # Validación
    INVALID_RUT = "El RUT ingresado no es válido"
    INVALID_GRADE = "La calificación debe estar entre 1.0 y 7.0"
    WEAK_PASSWORD = "La contraseña debe tener al menos 8 caracteres"

# =============================================================================
# CÓDIGOS DE ERROR
# =============================================================================

class ErrorCodes:
    """Códigos de error del sistema"""
    INTERNAL_ERROR = "ERR_INTERNAL"
    VALIDATION_ERROR = "ERR_VALIDATION"
    NOT_FOUND = "ERR_NOT_FOUND"
    ALREADY_EXISTS = "ERR_ALREADY_EXISTS"
    AUTH_INVALID_CREDENTIALS = "ERR_AUTH_INVALID_CREDENTIALS"
    AUTH_TOKEN_EXPIRED = "ERR_AUTH_TOKEN_EXPIRED"
    AUTH_UNAUTHORIZED = "ERR_AUTH_UNAUTHORIZED"
    DB_CONNECTION_ERROR = "ERR_DB_CONNECTION"
    DB_QUERY_ERROR = "ERR_DB_QUERY"
    BUSINESS_RULE_VIOLATION = "ERR_BUSINESS_RULE"
    INVALID_STATE_TRANSITION = "ERR_INVALID_TRANSITION"

# =============================================================================
# CONFIGURACIÓN
# =============================================================================

# Patrones de validación
RUT_PATTERN = r'^\d{7,8}$'

# Longitudes
DESCRIPTION_MAX_LENGTH = 1000
COMMENT_MAX_LENGTH = 1000

# Testing
TEST_USER_EMAIL = 'test@usm.cl'
TEST_ADMIN_EMAIL = 'admin@usm.cl'

# Logging
LOG_FORMAT = '%(asctime)s - %(name)s - %(levelname)s - %(message)s'
LOG_DATE_FORMAT = '%Y-%m-%d %H:%M:%S'