"""
Constantes específicas del módulo Workshops
Gestión de talleres DI
"""

# =============================================================================
# TALLERES
# =============================================================================

# Mensajes
MSG_WORKSHOP_NOT_FOUND = "Taller no encontrado"
MSG_WORKSHOP_CREATED = "Taller creado exitosamente"
MSG_WORKSHOP_UPDATED = "Taller actualizado exitosamente"
MSG_WORKSHOP_DELETED = "Taller eliminado exitosamente"
MSG_WORKSHOP_FULL = "El taller ha alcanzado el límite de inscripciones"
MSG_WORKSHOP_CLOSED = "El taller está cerrado para inscripciones"
MSG_INVALID_DATES = "Las fechas del taller son inválidas"

# Inscripciones
MSG_INSCRIPTION_NOT_FOUND = "Inscripción no encontrada"
MSG_INSCRIPTION_CREATED = "Inscripción realizada exitosamente"
MSG_INSCRIPTION_DELETED = "Inscripción cancelada exitosamente"
MSG_ALREADY_INSCRIBED = "Ya estás inscrito en este taller"
MSG_STUDENT_NOT_INSCRIBED = "El estudiante no está inscrito en este taller"

# Calificaciones
MSG_GRADE_NOT_FOUND = "Calificación no encontrada"
MSG_GRADE_ASSIGNED = "Calificación asignada exitosamente"
MSG_GRADE_UPDATED = "Calificación actualizada exitosamente"
MSG_GRADE_DELETED = "Calificación eliminada exitosamente"
MSG_GRADE_ALREADY_EXISTS = "El estudiante ya tiene una calificación asignada"
MSG_ONLY_INSCRIBED_STUDENTS = "Solo se pueden calificar estudiantes inscritos"

# Tokens
MSG_TOKEN_NOT_FOUND = "Token no encontrado"
MSG_TOKEN_CREATED = "Token creado exitosamente"
MSG_TOKEN_INVALID = "Token inválido o expirado"
MSG_TOKEN_DEACTIVATED = "Token desactivado exitosamente"

# Reglas de negocio
# Validar capacidad antes de inscribir
CHECK_CAPACITY_BEFORE_INSCRIPTION = True

# Solo calificar estudiantes inscritos
VALIDATE_INSCRIPTION_BEFORE_GRADE = True

# Auto-crear convalidación al cerrar taller
AUTO_CREATE_CONVALIDATION_ON_CLOSE = True

# Nota mínima para aprobar
PASSING_GRADE = 55
