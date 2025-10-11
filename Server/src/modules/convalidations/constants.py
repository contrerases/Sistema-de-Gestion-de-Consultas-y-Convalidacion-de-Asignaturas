"""
Constantes específicas del módulo Convalidations
Gestión de solicitudes y convalidaciones de asignaturas
"""

# =============================================================================
# CONVALIDACIONES
# =============================================================================

# Mensajes - Convalidaciones
MSG_CONVALIDATION_NOT_FOUND = "Convalidación no encontrada"
MSG_CONVALIDATION_CREATED = "Convalidación creada exitosamente"
MSG_CONVALIDATION_UPDATED = "Convalidación actualizada exitosamente"
MSG_CONVALIDATION_DELETED = "Convalidación eliminada exitosamente"
MSG_CONVALIDATION_APPROVED = "Convalidación aprobada exitosamente"
MSG_CONVALIDATION_REJECTED = "Convalidación rechazada"
MSG_REQUIRES_REQUEST = "Toda convalidación requiere una solicitud (REQUEST)"
MSG_SLOT_ALREADY_CONVALIDATED = "El slot curricular ya ha sido convalidado por este estudiante"
MSG_FILE_REQUIRED_EXTERNAL = "El archivo es obligatorio para actividades externas"
MSG_INVALID_TYPE = "Tipo de convalidación inválido"

# Mensajes - Requests
MSG_REQUEST_NOT_FOUND = "Solicitud no encontrada"
MSG_REQUEST_CREATED = "Solicitud creada exitosamente"
MSG_REQUEST_UPDATED = "Solicitud actualizada exitosamente"
MSG_REQUEST_DELETED = "Solicitud eliminada exitosamente"
MSG_REQUEST_HAS_CONVALIDATIONS = "No se puede eliminar una solicitud con convalidaciones asociadas"

# Reglas de negocio
# Toda convalidación requiere una REQUEST
REQUIRES_REQUEST = True

# Validar slot antes de crear convalidación
VALIDATE_SLOT_BEFORE_CREATE = True

# Archivo obligatorio en actividades externas
FILE_REQUIRED_EXTERNAL = True

# Auto-aprobación de talleres cerrados
AUTO_APPROVE_WORKSHOPS = True
