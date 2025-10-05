"""
Constantes específicas del módulo Academic
Gestión de asignaturas, departamentos y casillas curriculares
"""

# =============================================================================
# CURRICULUM COURSE SLOTS (Casillas Curriculares)
# =============================================================================

class CurriculumCourseSlot:
    """Constantes para casillas curriculares"""
    
    # Nombres de slots predefinidos
    LIBRE_1 = "LIBRE 1"
    LIBRE_2 = "LIBRE 2"
    LIBRE_3 = "LIBRE 3"
    LIBRE_4 = "LIBRE 4"
    ELECTIVO_INFORMATICA_1 = "ELECTIVO INFORMATICA 1"
    ELECTIVO_INFORMATICA_2 = "ELECTIVO INFORMATICA 2"
    ELECTIVO_1 = "ELECTIVO 1"
    ELECTIVO_2 = "ELECTIVO 2"
    ELECTIVO_3 = "ELECTIVO 3"
    ELECTIVO_4 = "ELECTIVO 4"
    
    # Validación
    NAME_MAX_LENGTH = 255
    NAME_MIN_LENGTH = 3
    
    # Mensajes
    SLOT_ALREADY_CONVALIDATED = "Esta casilla curricular ya ha sido convalidada"
    SLOT_NOT_FOUND = "Casilla curricular no encontrada"
    SLOT_CREATED = "Casilla curricular creada exitosamente"
    SLOT_UPDATED = "Casilla curricular actualizada exitosamente"
    SLOT_DELETED = "Casilla curricular eliminada exitosamente"

# =============================================================================
# SUBJECTS (Asignaturas)
# =============================================================================

class Subject:
    """Constantes para asignaturas"""
    
    # Validación
    NAME_MAX_LENGTH = 255
    NAME_MIN_LENGTH = 3
    CODE_MAX_LENGTH = 20
    CODE_MIN_LENGTH = 3
    
    # Código típico de asignaturas
    CODE_PATTERN = r'^[A-Z]{3}\d{3,4}$'  # Ej: INF123, MAT1234
    
    # Mensajes
    SUBJECT_NOT_FOUND = "Asignatura no encontrada"
    SUBJECT_ALREADY_EXISTS = "Ya existe una asignatura con este código"
    SUBJECT_CREATED = "Asignatura creada exitosamente"
    SUBJECT_UPDATED = "Asignatura actualizada exitosamente"
    SUBJECT_DELETED = "Asignatura eliminada exitosamente"
    SUBJECT_HAS_DEPENDENCIES = "No se puede eliminar, la asignatura tiene convalidaciones asociadas"

# =============================================================================
# DEPARTMENTS (Departamentos)
# =============================================================================

class Department:
    """Constantes para departamentos académicos"""
    
    # Validación
    NAME_MAX_LENGTH = 255
    NAME_MIN_LENGTH = 3
    
    # Mensajes
    DEPARTMENT_NOT_FOUND = "Departamento no encontrado"
    DEPARTMENT_ALREADY_EXISTS = "Ya existe un departamento con este nombre"
    DEPARTMENT_CREATED = "Departamento creado exitosamente"
    DEPARTMENT_UPDATED = "Departamento actualizado exitosamente"
    DEPARTMENT_DELETED = "Departamento eliminado exitosamente"
    DEPARTMENT_HAS_SUBJECTS = "No se puede eliminar, el departamento tiene asignaturas asociadas"

# =============================================================================
# BUSINESS RULES
# =============================================================================

class BusinessRules:
    """Reglas de negocio del módulo academic"""
    
    # Una asignatura debe pertenecer a un departamento
    SUBJECT_REQUIRES_DEPARTMENT = True
    
    # Un slot curricular debe tener un tipo
    SLOT_REQUIRES_TYPE = True
    
    # Códigos de asignatura deben ser únicos
    SUBJECT_CODE_UNIQUE = True
    
    # Nombres de slots deben ser únicos
    SLOT_NAME_UNIQUE = True
