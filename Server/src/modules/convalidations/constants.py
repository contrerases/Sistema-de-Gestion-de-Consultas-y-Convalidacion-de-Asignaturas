"""
Constantes específicas del módulo Convalidations
Gestión de solicitudes de convalidación
"""

# =============================================================================
# CONVALIDACIONES
# =============================================================================

class Convalidation:
    """Constantes para convalidaciones"""
    
    # Validación
    COMMENTS_MAX_LENGTH = 1000
    REJECTION_REASON_MAX_LENGTH = 500
    APPROVAL_COMMENTS_MAX_LENGTH = 500
    
    # Estados (IDs de CONVALIDATION_STATES)
    STATE_ENVIADA = 1
    STATE_RECHAZADA_DI = 2
    STATE_APROBADA_DI = 3
    STATE_ENVIADA_DE = 4
    STATE_RECHAZADA_DE = 5
    STATE_APROBADA_DE = 6
    
    # Tipos (IDs de CONVALIDATION_TYPES)
    TYPE_ELECTIVO_DI = 1
    TYPE_ASIGNATURA_EXTERNA_DI = 2
    TYPE_TALLER_DI = 3
    TYPE_PROYECTO_PERSONAL = 4
    TYPE_CURSO_CERTIFICADO = 5
    TYPE_OTRO = 6
    
    # Mensajes
    MSG_CONVALIDATION_NOT_FOUND = "Convalidación no encontrada"
    MSG_CONVALIDATION_CREATED = "Convalidación creada exitosamente"
    MSG_CONVALIDATION_UPDATED = "Convalidación actualizada exitosamente"
    MSG_CONVALIDATION_DELETED = "Convalidación eliminada exitosamente"
    MSG_CONVALIDATION_SUBMITTED = "Solicitud de convalidación enviada"
    MSG_CONVALIDATION_APPROVED = "Convalidación aprobada"
    MSG_CONVALIDATION_REJECTED = "Convalidación rechazada"
    MSG_INVALID_STATE_TRANSITION = "Transición de estado inválida"
    MSG_CANNOT_EDIT = "No se puede editar una convalidación en este estado"
    MSG_CANNOT_DELETE = "No se puede eliminar una convalidación ya procesada"
    MSG_REJECTION_REASON_REQUIRED = "Se requiere especificar razón de rechazo"
    MSG_INVALID_TYPE = "Tipo de convalidación inválido"
    MSG_STUDENT_NOT_FOUND = "Estudiante no encontrado"
    MSG_CURRICULUM_SLOT_NOT_FOUND = "Casilla curricular no encontrada"
    MSG_SLOT_ALREADY_CONVALIDATED = "Esta casilla curricular ya ha sido convalidada"
    MSG_MISSING_DETAILS = "Se requiere especificar detalles de la convalidación"

# =============================================================================
# CONVALIDACIONES DE ASIGNATURAS
# =============================================================================

class ConvalidationSubject:
    """Constantes para convalidaciones de asignaturas"""
    
    # Validación
    INSTITUTION_MAX_LENGTH = 255
    INSTITUTION_MIN_LENGTH = 3
    EXTERNAL_SUBJECT_NAME_MAX_LENGTH = 255
    
    # Mensajes
    MSG_SUBJECT_NOT_FOUND = "Asignatura no encontrada"
    MSG_INSTITUTION_REQUIRED = "Se requiere especificar la institución"
    MSG_EXTERNAL_SUBJECT_REQUIRED = "Se requiere especificar el nombre de la asignatura externa"
    MSG_INVALID_SUBJECT = "Asignatura inválida"

# =============================================================================
# CONVALIDACIONES DE TALLERES
# =============================================================================

class ConvalidationWorkshop:
    """Constantes para convalidaciones de talleres"""
    
    # Mensajes
    MSG_WORKSHOP_NOT_FOUND = "Taller no encontrado"
    MSG_WORKSHOP_NOT_FINISHED = "El taller debe estar finalizado"
    MSG_WORKSHOP_NOT_PASSED = "Debes haber aprobado el taller"
    MSG_INVALID_WORKSHOP = "Taller inválido"
    MSG_ALREADY_CONVALIDATED = "Este taller ya ha sido convalidado"

# =============================================================================
# CONVALIDACIONES DE ACTIVIDADES EXTERNAS
# =============================================================================

class ConvalidationExternalActivity:
    """Constantes para convalidaciones de actividades externas"""
    
    # Validación
    ACTIVITY_NAME_MAX_LENGTH = 255
    ACTIVITY_NAME_MIN_LENGTH = 3
    DESCRIPTION_MAX_LENGTH = 1000
    INSTITUTION_MAX_LENGTH = 255
    
    # Mensajes
    MSG_ACTIVITY_NAME_REQUIRED = "Se requiere especificar el nombre de la actividad"
    MSG_DESCRIPTION_REQUIRED = "Se requiere especificar la descripción"
    MSG_INSTITUTION_REQUIRED = "Se requiere especificar la institución"
    MSG_DURATION_REQUIRED = "Se requiere especificar la duración"

# =============================================================================
# REQUESTS (Solicitudes de consulta)
# =============================================================================

class Request:
    """Constantes para solicitudes/consultas de estudiantes"""
    
    # Validación
    TITLE_MAX_LENGTH = 255
    TITLE_MIN_LENGTH = 3
    DESCRIPTION_MAX_LENGTH = 2000
    RESPONSE_MAX_LENGTH = 2000
    
    # Estados
    STATUS_PENDING = "PENDING"
    STATUS_IN_PROGRESS = "IN_PROGRESS"
    STATUS_RESOLVED = "RESOLVED"
    STATUS_CLOSED = "CLOSED"
    
    # Mensajes
    MSG_REQUEST_NOT_FOUND = "Solicitud no encontrada"
    MSG_REQUEST_CREATED = "Solicitud creada exitosamente"
    MSG_REQUEST_UPDATED = "Solicitud actualizada exitosamente"
    MSG_REQUEST_RESOLVED = "Solicitud resuelta exitosamente"
    MSG_REQUEST_CLOSED = "Solicitud cerrada exitosamente"
    MSG_RESPONSE_REQUIRED = "Se requiere proporcionar una respuesta"
    MSG_CANNOT_MODIFY = "No se puede modificar una solicitud cerrada"

# =============================================================================
# ARCHIVOS
# =============================================================================

class Files:
    """Constantes para archivos adjuntos"""
    
    # Tamaños
    MAX_FILE_SIZE_BYTES = 10 * 1024 * 1024  # 10 MB
    
    # Tipos permitidos
    ALLOWED_EXTENSIONS = ['.pdf', '.jpg', '.jpeg', '.png', '.doc', '.docx']
    
    # Tipos MIME permitidos
    ALLOWED_MIME_TYPES = [
        'application/pdf',
        'image/jpeg',
        'image/png',
        'application/msword',
        'application/vnd.openxmlformats-officedocument.wordprocessingml.document'
    ]
    
    # Mensajes
    MSG_FILE_TOO_LARGE = "El archivo excede el tamaño máximo permitido (10 MB)"
    MSG_INVALID_FILE_TYPE = "Tipo de archivo no permitido"
    MSG_FILE_UPLOAD_ERROR = "Error al subir el archivo"
    MSG_FILE_NOT_FOUND = "Archivo no encontrado"

# =============================================================================
# REGLAS DE NEGOCIO
# =============================================================================

class BusinessRules:
    """Reglas de negocio del módulo convalidations"""
    
    # Solo el estudiante que creó la convalidación puede editarla
    ONLY_OWNER_CAN_EDIT = True
    
    # Solo se puede editar en estado ENVIADA
    EDITABLE_STATES = [1]  # ENVIADA
    
    # Estados finales (no se pueden modificar)
    FINAL_STATES = [2, 3, 5, 6]  # RECHAZADA_DI, APROBADA_DI, RECHAZADA_DE, APROBADA_DE
    
    # Estados donde DI puede actuar
    DI_ACTIONABLE_STATES = [1]  # ENVIADA
    
    # Estados donde DE puede actuar
    DE_ACTIONABLE_STATES = [4]  # ENVIADA_DE
    
    # Transiciones de estado válidas
    VALID_STATE_TRANSITIONS = {
        1: [2, 3, 4],  # ENVIADA -> RECHAZADA_DI, APROBADA_DI o ENVIADA_DE
        2: [],         # RECHAZADA_DI (final)
        3: [],         # APROBADA_DI (final)
        4: [5, 6],     # ENVIADA_DE -> RECHAZADA_DE o APROBADA_DE
        5: [],         # RECHAZADA_DE (final)
        6: []          # APROBADA_DE (final)
    }
    
    # Se requiere razón al rechazar
    REJECTION_REQUIRES_REASON = True
    
    # Una casilla curricular solo puede convalidarse una vez
    ONE_CONVALIDATION_PER_SLOT = True
    
    # DI revisa primero, luego puede enviar a DE (externo)
    DI_REVIEWS_FIRST = True
    
    # Aprobación de DE es externa, estudiante registra manualmente
    DE_APPROVAL_EXTERNAL = True
    
    # Tipos que requieren aprobación de DE
    TYPES_REQUIRING_DE = [1, 2, 4, 5, 6]  # Todos excepto TALLER_DI
    
    # Tipos que solo requieren DI
    TYPES_ONLY_DI = [3]  # TALLER_DI
