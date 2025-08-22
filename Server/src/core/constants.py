# =============================================================================
# CONSTANTES DEL SISTEMA DE GESTIÓN DE SOLICITUDES Y TALLERES DI
# =============================================================================

# =============================================================================
# CONFIGURACIÓN DE ARCHIVOS
# =============================================================================

# Tamaños máximos de archivos (en bytes)

MAX_FILE_SIZE_BYTES = 10 * 1024 * 1024  # 10 MB para archivos generales

# Tipos de archivos permitidos
ALLOWED_FILE_EXTENSIONS = ['.pdf']

# =============================================================================
# CONFIGURACIÓN DE TALLERES
# =============================================================================

# Calificaciones
MIN_GRADE = 0
MAX_GRADE = 100
PASSING_GRADE = 55

# =============================================================================
# CONFIGURACIÓN DE AUTENTICACIÓN
# =============================================================================

# Tokens
TOKEN_EXPIRATION_HOURS = 24
REFRESH_TOKEN_EXPIRATION_DAYS = 30
WORKSHOP_TOKEN_EXPIRATION_HOURS = 24

# =============================================================================
# CONFIGURACIÓN DE PAGINACIÓN
# =============================================================================

DEFAULT_PAGE_SIZE = 20
MAX_PAGE_SIZE = 30
MIN_PAGE_SIZE = 1

# =============================================================================


# =============================================================================
# CONFIGURACIÓN DE VALIDACIONES
# =============================================================================

# RUT chileno
RUT_MAX_LENGTH = 9
RUT_MIN_LENGTH = 8
RUT_PATTERN = r'^\d{7,8}$'

# Descripciones
DESCRIPTION_MAX_LENGTH = 1000
COMMENT_MAX_LENGTH = 1000

# =============================================================================
# CONFIGURACIÓN DE ESTADOS
# =============================================================================

# Estados que permiten edición
EDITABLE_CONVALIDATION_STATES = ['ENVIADA']

# Estados finales Convalidaciones
FINAL_CONVALIDATION_STATES = ['APROBADA_DE', 'RECHAZADA_DE', 'APROBADA_DI']

# Estados que requieren revisión de DI
DI_REVIEW_STATES = ['ENVIADA_DE']

# Estados que requieren revisión de DE
DE_REVIEW_STATES = ['APROBADA_DI']

# =============================================================================
# CONFIGURACIÓN DE ROLES Y PERMISOS
# =============================================================================



# Permisos por módulo
PERMISSIONS = {
    'workshops': {
        'create': ADMIN_ROLES,
        'read': ALL_ROLES,
        'update': ADMIN_ROLES,
        'delete': ADMIN_ROLES,
        'inscribe': STUDENT_ROLES
    },
    'convalidations': {
        'create': STUDENT_ROLES,
        'read': ALL_ROLES,
        'update': STUDENT_ROLES,  # Solo propias
        'review': ADMIN_ROLES,
        'approve': ADMIN_ROLES
    }
}

# =============================================================================
# MENSAJES DEL SISTEMA
# =============================================================================

ERROR_MESSAGES = {
    'INVALID_FILE_TYPE': 'Tipo de archivo no permitido',
    'FILE_TOO_LARGE': 'El archivo excede el tamaño máximo permitido',
    'WORKSHOP_FULL': 'El taller ha alcanzado el límite de inscripciones',
    'INSCRIPTION_CLOSED': 'El período de inscripción ha cerrado',
    'INVALID_GRADE': f'La calificación debe estar entre {MIN_GRADE} y {MAX_GRADE}',
    'UNAUTHORIZED_ACTION': 'No tienes permisos para realizar esta acción',
    'INVALID_RUT': 'El RUT ingresado no es válido',
    'WEAK_PASSWORD': f'La contraseña debe tener al menos {PASSWORD_MIN_LENGTH} caracteres'
}

SUCCESS_MESSAGES = {
    'WORKSHOP_CREATED': 'Taller creado exitosamente',
    'INSCRIPTION_SUCCESS': 'Inscripción realizada exitosamente',
    'CONVALIDATION_SUBMITTED': 'Solicitud de convalidación enviada',
    'GRADE_ASSIGNED': 'Calificación asignada exitosamente',
    'NOTIFICATION_SENT': 'Notificación enviada exitosamente'
}

# =============================================================================
# CONFIGURACIÓN DE DESARROLLO
# =============================================================================

# Configuración para testing
TEST_USER_EMAIL = 'test@usm.cl'
TEST_ADMIN_EMAIL = 'admin@usm.cl'

# Configuración de logging
LOG_FORMAT = '%(asctime)s - %(name)s - %(levelname)s - %(message)s'
LOG_DATE_FORMAT = '%Y-%m-%d %H:%M:%S'