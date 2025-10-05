"""
Constantes específicas del módulo Users
Gestión de usuarios, estudiantes y administradores
"""

# =============================================================================
# USUARIOS
# =============================================================================

class User:
    """Constantes para usuarios base"""
    
    # Validación
    RUT_MIN_LENGTH = 8
    RUT_MAX_LENGTH = 9
    RUT_PATTERN = r'^\d{7,8}$'
    
    NAME_MAX_LENGTH = 255
    NAME_MIN_LENGTH = 2
    
    EMAIL_MAX_LENGTH = 255
    EMAIL_DOMAIN_USACH = "@usach.cl"
    EMAIL_DOMAIN_STUDENT = "@estudiante.usach.cl"
    
    PHONE_MIN_LENGTH = 9
    PHONE_MAX_LENGTH = 15
    PHONE_PATTERN = r'^\+?[\d\s\-\(\)]+$'
    
    # Tipos de usuario (IDs de USER_TYPES)
    TYPE_STUDENT = 1
    TYPE_ADMINISTRATOR = 2
    
    # Mensajes
    MSG_USER_NOT_FOUND = "Usuario no encontrado"
    MSG_USER_CREATED = "Usuario creado exitosamente"
    MSG_USER_UPDATED = "Usuario actualizado exitosamente"
    MSG_USER_DELETED = "Usuario eliminado exitosamente"
    MSG_INVALID_RUT = "RUT inválido"
    MSG_RUT_ALREADY_EXISTS = "Ya existe un usuario con este RUT"
    MSG_EMAIL_ALREADY_EXISTS = "Ya existe un usuario con este email"
    MSG_INVALID_EMAIL_DOMAIN = "El email debe pertenecer al dominio @usach.cl"
    MSG_INVALID_PHONE = "Número de teléfono inválido"

# =============================================================================
# ESTUDIANTES
# =============================================================================

class Student:
    """Constantes para estudiantes"""
    
    # Validación
    ROL_MIN_LENGTH = 7
    ROL_MAX_LENGTH = 10
    ROL_PATTERN = r'^\d{7,10}$'
    
    CAREER_MAX_LENGTH = 255
    
    # Año de ingreso válido
    MIN_ENTRY_YEAR = 2000
    MAX_ENTRY_YEAR = 2099
    
    # Mensajes
    MSG_STUDENT_NOT_FOUND = "Estudiante no encontrado"
    MSG_STUDENT_CREATED = "Estudiante creado exitosamente"
    MSG_STUDENT_UPDATED = "Estudiante actualizado exitosamente"
    MSG_STUDENT_DELETED = "Estudiante eliminado exitosamente"
    MSG_INVALID_ROL = "Rol estudiantil inválido"
    MSG_ROL_ALREADY_EXISTS = "Ya existe un estudiante con este rol"
    MSG_INVALID_ENTRY_YEAR = "Año de ingreso inválido"
    MSG_INVALID_CAMPUS = "Campus inválido"
    MSG_EMAIL_MUST_BE_STUDENT = "El email debe pertenecer al dominio @estudiante.usach.cl"

# =============================================================================
# ADMINISTRADORES
# =============================================================================

class Administrator:
    """Constantes para administradores"""
    
    # Validación
    POSITION_MAX_LENGTH = 255
    
    # Mensajes
    MSG_ADMINISTRATOR_NOT_FOUND = "Administrador no encontrado"
    MSG_ADMINISTRATOR_CREATED = "Administrador creado exitosamente"
    MSG_ADMINISTRATOR_UPDATED = "Administrador actualizado exitosamente"
    MSG_ADMINISTRATOR_DELETED = "Administrador eliminado exitosamente"
    MSG_INVALID_CAMPUS = "Campus inválido"
    MSG_EMAIL_MUST_BE_USACH = "El email debe pertenecer al dominio @usach.cl"

# =============================================================================
# PROFESORES
# =============================================================================

class Professor:
    """Constantes para profesores"""
    
    # Validación
    NAME_MAX_LENGTH = 255
    EMAIL_MAX_LENGTH = 255
    DEPARTMENT_MAX_LENGTH = 255
    
    # Mensajes
    MSG_PROFESSOR_NOT_FOUND = "Profesor no encontrado"
    MSG_PROFESSOR_CREATED = "Profesor creado exitosamente"
    MSG_PROFESSOR_UPDATED = "Profesor actualizado exitosamente"
    MSG_PROFESSOR_DELETED = "Profesor eliminado exitosamente"

# =============================================================================
# REGLAS DE NEGOCIO
# =============================================================================

class BusinessRules:
    """Reglas de negocio del módulo users"""
    
    # RUT debe ser único en todo el sistema
    RUT_MUST_BE_UNIQUE = True
    
    # Email debe ser único
    EMAIL_MUST_BE_UNIQUE = True
    
    # Rol estudiantil debe ser único
    ROL_MUST_BE_UNIQUE = True
    
    # Estudiantes deben tener email @estudiante.usach.cl
    STUDENTS_REQUIRE_STUDENT_EMAIL = True
    
    # Administradores deben tener email @usach.cl
    ADMINISTRATORS_REQUIRE_USACH_EMAIL = True
    
    # Un usuario debe pertenecer a un campus
    USER_REQUIRES_CAMPUS = True
    
    # Un usuario debe tener un tipo
    USER_REQUIRES_TYPE = True
