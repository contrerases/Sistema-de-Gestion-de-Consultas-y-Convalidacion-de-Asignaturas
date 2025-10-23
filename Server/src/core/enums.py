from enum import Enum


class UserType(str, Enum):
    """Tipos de usuario del sistema"""

    STUDENT = "STUDENT"
    ADMINISTRATOR = "ADMINISTRATOR"




class WorkshopState(str, Enum):
    """Estados de los talleres"""

    INSCRIPCION = "INSCRIPCION"
    EN_CURSO = "EN_CURSO"
    FINALIZADO = "FINALIZADO"
    CERRADO = "CERRADO"
    CANCELADO = "CANCELADO"


class ConvalidationState(str, Enum):
    """Estados de las convalidaciones"""

    ENVIADA = "ENVIADA"
    RECHAZADA_DI = "RECHAZADA_DI"
    APROBADA_DI = "APROBADA_DI"
    ENVIADA_DE = "ENVIADA_DE"
    RECHAZADA_DE = "RECHAZADA_DE"
    APROBADA_DE = "APROBADA_DE"


class ConvalidationType(str, Enum):
    """Tipos de convalidaciones disponibles"""

    ELECTIVO_DI = "ELECTIVO DI"
    ASIGNATURA_EXTERNA_DI = "ASIGNATURA EXTERNA DI"
    TALLER_DI = "TALLER DI"
    PROYECTO_PERSONAL = "PROYECTO PERSONAL"
    CURSO_CERTIFICADO = "CURSO CERTIFICADO"
    OTRO = "OTRO"


class CurriculumCourseType(str, Enum):
    """Tipos de cursos curriculares"""

    LIBRE = "LIBRE"
    ELECTIVO_INFORMATICA = "ELECTIVO INFORMATICA"
    ELECTIVO = "ELECTIVO"


class NotificationType(str, Enum):
    """
    Tipos de notificaciones del sistema.
    Los valores deben coincidir con la columna notification_type de la tabla NOTIFICATIONS.
    """

    # Talleres
    WORKSHOP_CREATED = "WORKSHOP_CREATED"
    WORKSHOP_CANCELLED = "WORKSHOP_CANCELLED"
    WORKSHOP_STARTED = "WORKSHOP_STARTED"
    WORKSHOP_FINISHED = "WORKSHOP_FINISHED"
    WORKSHOP_CLOSED = "WORKSHOP_CLOSED"

    # Inscripciones
    INSCRIPTION_CONFIRMED = "INSCRIPTION_CONFIRMED"
    INSCRIPTION_CANCELLED = "INSCRIPTION_CANCELLED"

    # Calificaciones
    GRADE_ASSIGNED = "GRADE_ASSIGNED"
    GRADE_UPDATED = "GRADE_UPDATED"

    # Convalidaciones
    CONVALIDATION_SUBMITTED = "CONVALIDATION_SUBMITTED"
    CONVALIDATION_APPROVED_DI = "CONVALIDATION_APPROVED_DI"
    CONVALIDATION_REJECTED_DI = "CONVALIDATION_REJECTED_DI"
    CONVALIDATION_SENT_DE = "CONVALIDATION_SENT_DE"

    # Administrativo
    PENDING_CONVALIDATION = "PENDING_CONVALIDATION"
    SYSTEM_NOTIFICATION = "SYSTEM_NOTIFICATION"


class Campus(str, Enum):
    """
    Campus universitarios por acrónimo.
    Los valores deben coincidir con la columna acronym de la tabla CAMPUS.
    """

    CC = "CC"  # Casa Central
    SJ = "SJ"  # San Joaquín
