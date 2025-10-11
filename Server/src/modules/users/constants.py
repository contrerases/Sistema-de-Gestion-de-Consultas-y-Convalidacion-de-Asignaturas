"""
Constantes específicas del módulo Users
Sistema: SGSCT
"""

# =============================================================================
# VALIDACIÓN
# =============================================================================

# RUT
RUT_MIN_LENGTH = 8
RUT_MAX_LENGTH = 9
RUT_PATTERN = r'^\d{7,8}$'

# ROL Estudiante
ROL_MIN_LENGTH = 9
ROL_MAX_LENGTH = 11
ROL_PATTERN = r'^\d{9,11}$'

# Nombres
NAME_MAX_LENGTH = 255
NAME_MIN_LENGTH = 2

# Email
EMAIL_MAX_LENGTH = 255
EMAIL_DOMAIN_USM = "@usm.cl"
EMAIL_DOMAIN_SANSANO = "@sansano.usm.cl"
EMAIL_DOMAIN_STUDENT = "@estudiante.usm.cl"
VALID_EMAIL_DOMAINS = [EMAIL_DOMAIN_USM, EMAIL_DOMAIN_SANSANO, EMAIL_DOMAIN_STUDENT]

# =============================================================================
# TIPOS DE USUARIO (IDs en USER_TYPES)
# =============================================================================

TYPE_STUDENT = 1
TYPE_ADMINISTRATOR = 2

# =============================================================================
# MENSAJES - USUARIOS
# =============================================================================

MSG_USER_NOT_FOUND = "Usuario no encontrado"
MSG_USER_CREATED = "Usuario creado exitosamente"
MSG_USER_UPDATED = "Usuario actualizado exitosamente"
MSG_USER_DELETED = "Usuario eliminado exitosamente"

# Validaciones
MSG_INVALID_RUT = "RUT inválido (debe tener 7-8 dígitos)"
MSG_INVALID_ROL = "ROL inválido (debe tener 9-11 dígitos)"
MSG_RUT_ALREADY_EXISTS = "Ya existe un usuario con este RUT"
MSG_ROL_ALREADY_EXISTS = "Ya existe un usuario con este ROL"
MSG_EMAIL_ALREADY_EXISTS = "Ya existe un usuario con este email"
MSG_INVALID_EMAIL_DOMAIN = "El email debe pertenecer al dominio usm.cl, estudiante.usm.cl, sansano.usm.cl"
MSG_INVALID_USER_TYPE = "Tipo de usuario inválido"
MSG_INVALID_CAMPUS = "Campus inválido"

# Estudiantes
MSG_STUDENT_DATA_REQUIRED = "Los datos de estudiante (ROL y RUT) son obligatorios para usuarios tipo STUDENT"
MSG_STUDENT_DATA_FORBIDDEN = "Los datos de estudiante (ROL y RUT) no deben proporcionarse para administradores"

# =============================================================================
# MENSAJES - PROFESORES
# =============================================================================

MSG_PROFESSOR_NOT_FOUND = "Profesor no encontrado"
MSG_PROFESSOR_CREATED = "Profesor creado exitosamente"
MSG_PROFESSOR_UPDATED = "Profesor actualizado exitosamente"
MSG_PROFESSOR_DELETED = "Profesor eliminado exitosamente"
MSG_PROFESSOR_EMAIL_EXISTS = "Ya existe un profesor con este email"
MSG_PROFESSOR_HAS_WORKSHOPS = "No se puede eliminar el profesor porque tiene talleres asignados"

# =============================================================================
# PAGINACIÓN
# =============================================================================

DEFAULT_PAGE_SIZE = 50
MAX_PAGE_SIZE = 100
