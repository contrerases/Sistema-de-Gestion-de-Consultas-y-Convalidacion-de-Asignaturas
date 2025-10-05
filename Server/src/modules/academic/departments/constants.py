"""
Constantes específicas del submódulo Departments (Departamentos)
"""

# =============================================================================
# DEPARTAMENTOS
# =============================================================================

# IDs de departamentos predefinidos (referencia a tabla DEPARTMENTS)
INFORMATICA_ID = 1
QUIMICA_ID = 2
ELECTRONICA_ID = 3
DEFIDER_ID = 4
ESTUDIOS_HUMANISTICOS_ID = 5
MATEMATICA_ID = 6

# Nombres oficiales
DEPARTMENT_NAMES = {
    INFORMATICA_ID: "INFORMATICA",
    QUIMICA_ID: "QUIMICA",
    ELECTRONICA_ID: "ELECTRONICA",
    DEFIDER_ID: "DEFIDER",
    ESTUDIOS_HUMANISTICOS_ID: "ESTUDIOS HUMANISTICOS",
    MATEMATICA_ID: "MATEMATICA"
}

# Labels para UI
DEPARTMENT_LABELS = {
    INFORMATICA_ID: "Informática",
    QUIMICA_ID: "Química",
    ELECTRONICA_ID: "Electrónica",
    DEFIDER_ID: "DEFIDER",
    ESTUDIOS_HUMANISTICOS_ID: "Estudios Humanísticos",
    MATEMATICA_ID: "Matemática"
}

# Validación
NAME_MAX_LENGTH = 255
NAME_MIN_LENGTH = 3

# Departamento por defecto para talleres DI
DEFAULT_DEPARTMENT_ID = INFORMATICA_ID

# Mensajes
MSG_DEPARTMENT_NOT_FOUND = "Departamento no encontrado"
MSG_DEPARTMENT_ALREADY_EXISTS = "Ya existe un departamento con este nombre"
MSG_DEPARTMENT_CREATED = "Departamento creado exitosamente"
MSG_DEPARTMENT_UPDATED = "Departamento actualizado exitosamente"
MSG_DEPARTMENT_DELETED = "Departamento eliminado exitosamente"
MSG_DEPARTMENT_HAS_SUBJECTS = "No se puede eliminar, el departamento tiene asignaturas asociadas"

# Reglas de negocio
# Un departamento puede tener múltiples asignaturas
CAN_HAVE_MULTIPLE_SUBJECTS = True

# No se puede eliminar un departamento con asignaturas asociadas
PREVENT_DELETE_WITH_SUBJECTS = True
