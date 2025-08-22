from enum import Enum

class UserType(str, Enum):
    """Tipos de usuario del sistema"""
    STUDENT = "STUDENT"
    ADMINISTRATOR = "ADMINISTRATOR"

class Semester(str, Enum):
    """Semestres académicos"""
    FIRST = "1"
    SECOND = "2"

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
    """Tipos de notificaciones del sistema"""
    SUCCESSFUL_REQUEST_CONVALIDATION = "Solicitud de Convalidación enviada con éxito"
    CONVALIDATION_APPROVED_DI = "Convalidación Aprobada por Departamento de Informática"
    CONVALIDATION_SEND_TO_DE = "Convalidación Enviada a Dirección de Estudios"
    CONVALIDATION_REJECTED = "Convalidación Rechazada"
    NEW_REQUEST_CONVALIDATION = "Nueva Solicitud de Convalidación"
    NEW_WORKSHOP_INSCRIPTION = "Inscripción a Taller realizada con éxito"
    SUCCESSFUL_WORKSHOP_INSCRIPTION = "Inscripción a Taller Exitosa"
    WORKSHOP_INSCRIPTION_OPEN = "Inscripción a Taller Abierta"
    WORKSHOP_INSCRIPTION_CLOSE = "Inscripción a Taller Cerrada"
    WORKSHOP_START = "Taller Comenzado"
    WORKSHOP_END = "Taller Finalizado"
    WORKSHOP_CLOSED = "Taller Cerrado"
    UPLOAD_WORKSHOPS_GRADES = "Notas de Talleres Subidas"
    UPLOAD_WORKSHOP_GRADE = "Nota de Taller Subida"

class Campus(str, Enum):
    """Campus universitarios"""
    CASA_CENTRAL = "Casa Central"
    SAN_JOAQUIN = "San Joaquín"
    VITACURA = "Vitacura"

