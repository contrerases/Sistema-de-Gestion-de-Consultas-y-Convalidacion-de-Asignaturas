"""
Constantes específicas del módulo Catalog
Gestión de catálogos del sistema (campus, tipos, estados)
"""

# =============================================================================
# CATÁLOGOS GENERALES
# =============================================================================

# Todos los catálogos son de solo lectura para usuarios
CATALOGS_READ_ONLY = True

# Los catálogos se cargan al iniciar el sistema
LOAD_ON_STARTUP = True

# Cache de catálogos (en segundos)
CATALOG_CACHE_TTL = 3600  # 1 hora

# Mensajes generales
MSG_CATALOG_ITEM_NOT_FOUND = "Elemento del catálogo no encontrado"
MSG_CATALOG_ITEM_CREATED = "Elemento del catálogo creado exitosamente"
MSG_CATALOG_ITEM_UPDATED = "Elemento del catálogo actualizado exitosamente"
MSG_CATALOG_ITEM_DELETED = "Elemento del catálogo eliminado exitosamente"
MSG_CATALOG_READ_ONLY = "Los catálogos son de solo lectura"

# =============================================================================
# CAMPUS
# =============================================================================

class Campus:
    """Constantes para campus universitarios"""
    
    # IDs
    CASA_CENTRAL_ID = 1
    SAN_JOAQUIN_ID = 2
    VITACURA_ID = 3
    
    # Acrónimos
    ACRONYM_MAX_LENGTH = 10
    ACRONYMS = ["CC", "SJ", "VSM"]
    
    # Validación
    NAME_MAX_LENGTH = 255
    LOCATION_MAX_LENGTH = 255
    
    # Mensajes
    MSG_CAMPUS_NOT_FOUND = "Campus no encontrado"
    MSG_INVALID_CAMPUS = "Campus inválido"

# =============================================================================
# USER TYPES
# =============================================================================

class UserTypes:
    """Constantes para tipos de usuario"""
    
    # IDs
    STUDENT_ID = 1
    ADMINISTRATOR_ID = 2
    
    # Nombres
    STUDENT = "STUDENT"
    ADMINISTRATOR = "ADMINISTRATOR"
    
    # Validación
    TYPE_MAX_LENGTH = 50
    
    # Mensajes
    MSG_USER_TYPE_NOT_FOUND = "Tipo de usuario no encontrado"
    MSG_INVALID_USER_TYPE = "Tipo de usuario inválido"

# =============================================================================
# WORKSHOP STATES
# =============================================================================

class WorkshopStates:
    """Constantes para estados de talleres"""
    
    # IDs
    INSCRIPCION_ID = 1
    EN_CURSO_ID = 2
    FINALIZADO_ID = 3
    CERRADO_ID = 4
    CANCELADO_ID = 5
    
    # Nombres
    NAMES = ["INSCRIPCION", "EN_CURSO", "FINALIZADO", "CERRADO", "CANCELADO"]
    
    # Validación
    NAME_MAX_LENGTH = 255
    DESCRIPTION_MAX_LENGTH = 1000
    
    # Mensajes
    MSG_STATE_NOT_FOUND = "Estado de taller no encontrado"
    MSG_INVALID_STATE = "Estado de taller inválido"

# =============================================================================
# CONVALIDATION STATES
# =============================================================================

class ConvalidationStates:
    """Constantes para estados de convalidaciones"""
    
    # IDs
    ENVIADA_ID = 1
    RECHAZADA_DI_ID = 2
    APROBADA_DI_ID = 3
    ENVIADA_DE_ID = 4
    RECHAZADA_DE_ID = 5
    APROBADA_DE_ID = 6
    
    # Nombres
    NAMES = ["ENVIADA", "RECHAZADA_DI", "APROBADA_DI", "ENVIADA_DE", "RECHAZADA_DE", "APROBADA_DE"]
    
    # Validación
    NAME_MAX_LENGTH = 255
    
    # Mensajes
    MSG_STATE_NOT_FOUND = "Estado de convalidación no encontrado"
    MSG_INVALID_STATE = "Estado de convalidación inválido"

# =============================================================================
# CONVALIDATION TYPES
# =============================================================================

class ConvalidationTypes:
    """Constantes para tipos de convalidaciones"""
    
    # IDs
    ELECTIVO_DI_ID = 1
    ASIGNATURA_EXTERNA_DI_ID = 2
    TALLER_DI_ID = 3
    PROYECTO_PERSONAL_ID = 4
    CURSO_CERTIFICADO_ID = 5
    OTRO_ID = 6
    
    # Nombres
    NAMES = ["ELECTIVO DI", "ASIGNATURA EXTERNA DI", "TALLER DI", "PROYECTO PERSONAL", "CURSO CERTIFICADO", "OTRO"]
    
    # Validación
    NAME_MAX_LENGTH = 255
    
    # Mensajes
    MSG_TYPE_NOT_FOUND = "Tipo de convalidación no encontrado"
    MSG_INVALID_TYPE = "Tipo de convalidación inválido"

# =============================================================================
# CURRICULUM COURSE TYPES
# =============================================================================

class CurriculumCourseTypes:
    """Constantes para tipos de casillas curriculares"""
    
    # IDs
    LIBRE_ID = 1
    ELECTIVO_INFORMATICA_ID = 2
    ELECTIVO_ID = 3
    
    # Nombres
    NAMES = ["LIBRE", "ELECTIVO INFORMATICA", "ELECTIVO"]
    
    # Validación
    NAME_MAX_LENGTH = 255
    
    # Mensajes
    MSG_TYPE_NOT_FOUND = "Tipo de casilla curricular no encontrado"
    MSG_INVALID_TYPE = "Tipo de casilla curricular inválido"
