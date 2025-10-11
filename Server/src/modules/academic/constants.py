"""
Constantes específicas del módulo Academic
Gestión de asignaturas, departamentos y casillas curriculares
"""

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
