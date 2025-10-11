"""
Constantes específicas del submódulo Departments (Departamentos)
"""

# =============================================================================
# DEPARTAMENTOS
# =============================================================================

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
