"""
Constantes específicas del submódulo Subjects (Asignaturas)
"""

# =============================================================================
# ASIGNATURAS
# =============================================================================

# Patrón de código de asignatura
# Ej: INF123, MAT1234, QUI2001
CODE_PATTERN = r'^[A-Z]{3}\d{3,4}$'

# Mensajes
MSG_SUBJECT_NOT_FOUND = "Asignatura no encontrada"
MSG_SUBJECT_ALREADY_EXISTS = "Ya existe una asignatura con este código"
MSG_SUBJECT_CREATED = "Asignatura creada exitosamente"
MSG_SUBJECT_UPDATED = "Asignatura actualizada exitosamente"
MSG_SUBJECT_DELETED = "Asignatura eliminada exitosamente"
MSG_SUBJECT_HAS_CONVALIDATIONS = "No se puede eliminar, la asignatura tiene convalidaciones asociadas"
MSG_INVALID_CODE_FORMAT = "El código de asignatura tiene un formato inválido"
MSG_INVALID_DEPARTMENT = "Departamento inválido"

# Reglas de negocio
# Una asignatura debe pertenecer a un departamento
REQUIRES_DEPARTMENT = True

# Código de asignatura debe ser único
CODE_MUST_BE_UNIQUE = True

# Una asignatura puede ser usada en convalidaciones
CAN_BE_CONVALIDATED = True
