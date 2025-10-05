"""
Constantes específicas del módulo Workshops
Gestión de talleres, inscripciones y calificaciones
"""

# =============================================================================
# TALLERES
# =============================================================================

class Workshop:
    """Constantes para talleres"""
    
    # Validación
    NAME_MAX_LENGTH = 255
    NAME_MIN_LENGTH = 3
    DESCRIPTION_MAX_LENGTH = 1000
    PROFESSOR_MAX_LENGTH = 255
    SYLLABUS_MAX_LENGTH = 2000
    LOCATION_MAX_LENGTH = 255
    
    # Capacidad
    MIN_INSCRIPTIONS = 1
    MAX_CAPACITY = 100
    DEFAULT_CAPACITY = 30
    MAX_WORKSHOPS_PER_STUDENT = 3
    
    # Semestres
    SEMESTER_1 = 1
    SEMESTER_2 = 2
    SEMESTER_SUMMER = 3
    
    SEMESTER_NAMES = {
        SEMESTER_1: "PRIMER SEMESTRE",
        SEMESTER_2: "SEGUNDO SEMESTRE",
        SEMESTER_SUMMER: "VERANO"
    }
    
    # Estados (IDs de WORKSHOP_STATES)
    STATE_INSCRIPCION = 1
    STATE_EN_CURSO = 2
    STATE_FINALIZADO = 3
    STATE_CERRADO = 4
    STATE_CANCELADO = 5
    
    # Validación de campos obligatorios
    REQUIRED_FIELDS = ["name", "professor", "syllabus", "min_inscriptions", "max_capacity", "id_workshop_state"]
    
    # Mensajes
    MSG_WORKSHOP_NOT_FOUND = "Taller no encontrado"
    MSG_WORKSHOP_CREATED = "Taller creado exitosamente"
    MSG_WORKSHOP_UPDATED = "Taller actualizado exitosamente"
    MSG_WORKSHOP_DELETED = "Taller eliminado exitosamente"
    MSG_WORKSHOP_FULL = "El taller ha alcanzado su capacidad máxima"
    MSG_INSCRIPTION_CLOSED = "El período de inscripción ha cerrado"
    MSG_INVALID_STATE_TRANSITION = "Transición de estado inválida"
    MSG_CANNOT_CANCEL = "Solo se puede cancelar un taller en estado INSCRIPCION"
    MSG_CANCELLATION_REASON_REQUIRED = "Se requiere especificar razón de cancelación"
    MSG_SYLLABUS_REQUIRED = "El syllabus es obligatorio"
    MSG_MIN_INSCRIPTIONS_REQUIRED = "El número mínimo de inscripciones es obligatorio"

# =============================================================================
# INSCRIPCIONES
# =============================================================================

class Inscription:
    """Constantes para inscripciones a talleres"""
    
    # Estados de inscripción
    STATUS_ACTIVE = "ACTIVE"
    STATUS_CANCELLED = "CANCELLED"
    STATUS_COMPLETED = "COMPLETED"
    
    # Validación
    CANCELLATION_REASON_MAX_LENGTH = 500
    
    # Mensajes
    MSG_INSCRIPTION_NOT_FOUND = "Inscripción no encontrada"
    MSG_INSCRIPTION_SUCCESS = "Inscripción realizada exitosamente"
    MSG_INSCRIPTION_CANCELLED = "Inscripción cancelada exitosamente"
    MSG_ALREADY_INSCRIBED = "Ya estás inscrito en este taller"
    MSG_WORKSHOP_FULL = "El taller está lleno"
    MSG_INSCRIPTION_PERIOD_CLOSED = "El período de inscripción ha cerrado"
    MSG_CANNOT_CANCEL_INSCRIPTION = "No se puede cancelar la inscripción en este estado"
    MSG_STUDENT_NOT_FOUND = "Estudiante no encontrado"
    MSG_INVALID_CURRICULUM_SLOT = "Casilla curricular inválida"
    MSG_SLOT_ALREADY_USED = "Esta casilla curricular ya está en uso"

# =============================================================================
# CALIFICACIONES
# =============================================================================

class Grade:
    """Constantes para calificaciones de talleres"""
    
    # Escala de calificación chilena (1.0 - 7.0)
    MIN_GRADE = 1.0
    MAX_GRADE = 7.0
    PASSING_GRADE = 4.0
    
    # Estados de aprobación
    STATUS_PASSED = "APROBADO"
    STATUS_FAILED = "REPROBADO"
    STATUS_PENDING = "PENDIENTE"
    
    # Validación
    GRADE_DECIMAL_PLACES = 1
    COMMENTS_MAX_LENGTH = 500
    
    # Mensajes
    MSG_GRADE_NOT_FOUND = "Calificación no encontrada"
    MSG_GRADE_ASSIGNED = "Calificación asignada exitosamente"
    MSG_GRADE_UPDATED = "Calificación actualizada exitosamente"
    MSG_INVALID_GRADE = f"La calificación debe estar entre {MIN_GRADE} y {MAX_GRADE}"
    MSG_GRADE_ALREADY_EXISTS = "Ya existe una calificación para esta inscripción"
    MSG_WORKSHOP_NOT_FINISHED = "El taller debe estar finalizado para asignar calificaciones"
    MSG_INSCRIPTION_NOT_FOUND = "Inscripción no encontrada"
    MSG_CANNOT_MODIFY_GRADE = "No se puede modificar una calificación aprobada"

# =============================================================================
# TOKENS DE TALLERES
# =============================================================================

class WorkshopToken:
    """Constantes para tokens de talleres (profesores externos)"""
    
    # Validación
    TOKEN_LENGTH = 32
    TOKEN_EXPIRATION_HOURS = 720  # 30 días
    
    # Caracteres permitidos en token
    TOKEN_CHARS = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
    
    # Mensajes
    MSG_TOKEN_NOT_FOUND = "Token no encontrado"
    MSG_TOKEN_EXPIRED = "Token expirado"
    MSG_TOKEN_INVALID = "Token inválido"
    MSG_TOKEN_CREATED = "Token creado exitosamente"
    MSG_TOKEN_REVOKED = "Token revocado exitosamente"

# =============================================================================
# REGLAS DE NEGOCIO
# =============================================================================

class BusinessRules:
    """Reglas de negocio del módulo workshops"""
    
    # Un estudiante solo puede inscribirse una vez por taller
    ONE_INSCRIPTION_PER_WORKSHOP = True
    
    # Solo se puede inscribir en estado INSCRIPCION
    INSCRIPTION_ONLY_WHEN_OPEN = True
    
    # El taller debe tener syllabus obligatoriamente
    SYLLABUS_IS_MANDATORY = True
    
    # min_inscriptions es obligatorio
    MIN_INSCRIPTIONS_IS_MANDATORY = True
    
    # Solo se puede cancelar taller desde estado INSCRIPCION
    CANCEL_ONLY_FROM_INSCRIPCION = True
    
    # Se requiere razón al cancelar
    CANCELLATION_REQUIRES_REASON = True
    
    # Solo se pueden asignar calificaciones a talleres finalizados
    GRADE_ONLY_FINISHED_WORKSHOPS = True
    
    # Transiciones de estado válidas
    VALID_STATE_TRANSITIONS = {
        1: [2, 5],  # INSCRIPCION -> EN_CURSO o CANCELADO
        2: [3],     # EN_CURSO -> FINALIZADO
        3: [4],     # FINALIZADO -> CERRADO
        4: [],      # CERRADO (final)
        5: []       # CANCELADO (final)
    }
    
    # Estados desde los cuales se puede cancelar
    CANCELABLE_STATES = [1]  # Solo INSCRIPCION
    
    # Estados que permiten inscripciones
    INSCRIPTION_ALLOWED_STATES = [1]  # Solo INSCRIPCION
    
    # Estados que permiten asignar calificaciones
    GRADING_ALLOWED_STATES = [3, 4]  # FINALIZADO y CERRADO
