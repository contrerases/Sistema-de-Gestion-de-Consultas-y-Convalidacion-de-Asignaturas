"""
Constantes específicas del submódulo Curriculum Courses (Casillas Curriculares)
"""

# =============================================================================
# CASILLAS CURRICULARES
# =============================================================================

# IDs de tipos (referencia a CURRICULUM_COURSES_TYPES)
TYPE_LIBRE = 1
TYPE_ELECTIVO_INFORMATICA = 2
TYPE_ELECTIVO = 3

# Nombres de tipos
TYPE_NAMES = {
    TYPE_LIBRE: "LIBRE",
    TYPE_ELECTIVO_INFORMATICA: "ELECTIVO INFORMATICA",
    TYPE_ELECTIVO: "ELECTIVO"
}

# Labels para UI
TYPE_LABELS = {
    TYPE_LIBRE: "Libre",
    TYPE_ELECTIVO_INFORMATICA: "Electivo Informática",
    TYPE_ELECTIVO: "Electivo"
}

# Validación
NAME_MAX_LENGTH = 255
NAME_MIN_LENGTH = 3

# Slots predefinidos por tipo
SLOTS_LIBRE = ["LIBRE 1", "LIBRE 2", "LIBRE 3", "LIBRE 4"]
SLOTS_ELECTIVO_INFORMATICA = ["ELECTIVO INFORMATICA 1", "ELECTIVO INFORMATICA 2"]
SLOTS_ELECTIVO = ["ELECTIVO 1", "ELECTIVO 2", "ELECTIVO 3", "ELECTIVO 4"]

# Total de slots requeridos para graduación (ejemplo)
TOTAL_SLOTS_REQUIRED = 10

# Mensajes
MSG_SLOT_NOT_FOUND = "Casilla curricular no encontrada"
MSG_SLOT_ALREADY_CONVALIDATED = "Esta casilla curricular ya ha sido convalidada"
MSG_SLOT_CREATED = "Casilla curricular creada exitosamente"
MSG_SLOT_UPDATED = "Casilla curricular actualizada exitosamente"
MSG_SLOT_DELETED = "Casilla curricular eliminada exitosamente"
MSG_INVALID_TYPE = "Tipo de casilla curricular inválido"

# Reglas de negocio
# Un estudiante puede convalidar máximo un slot de cada tipo
MAX_CONVALIDATIONS_PER_TYPE = {
    TYPE_LIBRE: 4,
    TYPE_ELECTIVO_INFORMATICA: 2,
    TYPE_ELECTIVO: 4
}

# Requiere aprobación de DI para convalidar
REQUIRES_DI_APPROVAL = True

# Requiere aprobación de DE para ciertos tipos
REQUIRES_DE_APPROVAL = {
    TYPE_LIBRE: False,
    TYPE_ELECTIVO_INFORMATICA: True,
    TYPE_ELECTIVO: True
}
