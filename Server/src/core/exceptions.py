"""
Excepciones personalizadas del sistema SGSCT
Basadas en la lógica de negocio: Talleres, Convalidaciones, Autenticación
"""

from src.core.constants import HTTPStatus, ErrorCodes


# =============================================================================
# EXCEPCIÓN BASE
# =============================================================================

class SGSCTException(Exception):
    """Excepción base del sistema SGSCT"""
    def __init__(
        self, 
        message: str, 
        status_code: int = HTTPStatus.BAD_REQUEST,
        error_code: str = ErrorCodes.INTERNAL_ERROR,
        details: dict = None
    ):
        self.message = message
        self.status_code = status_code
        self.error_code = error_code
        self.details = details or {}
        super().__init__(self.message)


# =============================================================================
# EXCEPCIONES GENERALES (HTTP ESTÁNDAR)
# =============================================================================

class NotFoundException(SGSCTException):
    """Recurso no encontrado (404)"""
    def __init__(self, message: str = "Recurso no encontrado", details: dict = None):
        super().__init__(
            message=message,
            status_code=HTTPStatus.NOT_FOUND,
            error_code=ErrorCodes.NOT_FOUND,
            details=details
        )


class ConflictException(SGSCTException):
    """Conflicto de datos - recurso ya existe (409)"""
    def __init__(self, message: str = "El recurso ya existe", details: dict = None):
        super().__init__(
            message=message,
            status_code=HTTPStatus.CONFLICT,
            error_code=ErrorCodes.ALREADY_EXISTS,
            details=details
        )


class UnauthorizedException(SGSCTException):
    """No autenticado - token inválido o faltante (401)"""
    def __init__(self, message: str = "No autorizado", details: dict = None):
        super().__init__(
            message=message,
            status_code=HTTPStatus.UNAUTHORIZED,
            error_code=ErrorCodes.AUTH_UNAUTHORIZED,
            details=details
        )


class ForbiddenException(SGSCTException):
    """Autenticado pero sin permisos (403)"""
    def __init__(self, message: str = "Acceso prohibido", details: dict = None):
        super().__init__(
            message=message,
            status_code=HTTPStatus.FORBIDDEN,
            error_code=ErrorCodes.FORBIDDEN,
            details=details
        )


class ValidationException(SGSCTException):
    """Error de validación de datos (422)"""
    def __init__(self, message: str = "Error de validación", details: dict = None):
        super().__init__(
            message=message,
            status_code=HTTPStatus.UNPROCESSABLE_ENTITY,
            error_code=ErrorCodes.VALIDATION_ERROR,
            details=details
        )


class DatabaseException(SGSCTException):
    """Error en operaciones de base de datos (500)"""
    def __init__(self, message: str = "Error en la base de datos", details: dict = None):
        super().__init__(
            message=message,
            status_code=HTTPStatus.INTERNAL_SERVER_ERROR,
            error_code=ErrorCodes.DB_QUERY_ERROR,
            details=details
        )


# =============================================================================
# EXCEPCIONES DE AUTENTICACIÓN
# =============================================================================

class InvalidCredentialsException(SGSCTException):
    """Credenciales inválidas (email/contraseña incorrectos)"""
    def __init__(self, message: str = "Credenciales inválidas"):
        super().__init__(
            message=message,
            status_code=HTTPStatus.UNAUTHORIZED,
            error_code=ErrorCodes.AUTH_INVALID_CREDENTIALS
        )


class TokenExpiredException(SGSCTException):
    """Token JWT expirado"""
    def __init__(self, message: str = "Token expirado"):
        super().__init__(
            message=message,
            status_code=HTTPStatus.UNAUTHORIZED,
            error_code=ErrorCodes.AUTH_TOKEN_EXPIRED
        )


class InvalidTokenException(SGSCTException):
    """Token JWT inválido o malformado"""
    def __init__(self, message: str = "Token inválido"):
        super().__init__(
            message=message,
            status_code=HTTPStatus.UNAUTHORIZED,
            error_code=ErrorCodes.AUTH_TOKEN_INVALID
        )


class InsufficientPermissionsException(SGSCTException):
    """Usuario no tiene permisos suficientes para la operación"""
    def __init__(self, message: str = "Permisos insuficientes", required_role: str = None):
        details = {"required_role": required_role} if required_role else {}
        super().__init__(
            message=message,
            status_code=HTTPStatus.FORBIDDEN,
            error_code=ErrorCodes.INSUFFICIENT_PERMISSIONS,
            details=details
        )


# =============================================================================
# EXCEPCIONES DE TALLERES
# =============================================================================

class WorkshopNotFoundException(NotFoundException):
    """Taller no encontrado"""
    def __init__(self, workshop_id: int = None):
        details = {"workshop_id": workshop_id} if workshop_id else {}
        super().__init__(message="Taller no encontrado", details=details)


class WorkshopFullException(SGSCTException):
    """Taller alcanzó capacidad máxima"""
    def __init__(self, workshop_id: int, current: int, max_capacity: int):
        super().__init__(
            message="El taller ha alcanzado el límite de inscripciones",
            status_code=HTTPStatus.CONFLICT,
            error_code=ErrorCodes.BUSINESS_RULE_VIOLATION,
            details={
                "workshop_id": workshop_id,
                "current_inscriptions": current,
                "max_capacity": max_capacity
            }
        )


class WorkshopInscriptionClosedException(SGSCTException):
    """Período de inscripción cerrado"""
    def __init__(self, workshop_id: int, current_state: str):
        super().__init__(
            message="El período de inscripción ha cerrado",
            status_code=HTTPStatus.CONFLICT,
            error_code=ErrorCodes.BUSINESS_RULE_VIOLATION,
            details={
                "workshop_id": workshop_id,
                "current_state": current_state
            }
        )


class WorkshopAlreadyInscribedException(ConflictException):
    """Estudiante ya inscrito en el taller"""
    def __init__(self, student_id: int, workshop_id: int):
        super().__init__(
            message="Ya estás inscrito en este taller",
            details={
                "student_id": student_id,
                "workshop_id": workshop_id
            }
        )


class WorkshopStateTransitionException(SGSCTException):
    """Transición de estado de taller no permitida"""
    def __init__(self, from_state: str, to_state: str):
        super().__init__(
            message=f"No se puede transicionar de {from_state} a {to_state}",
            status_code=HTTPStatus.CONFLICT,
            error_code=ErrorCodes.INVALID_STATE_TRANSITION,
            details={
                "from_state": from_state,
                "to_state": to_state
            }
        )


class InvalidWorkshopTokenException(SGSCTException):
    """Token de inscripción de taller inválido o expirado"""
    def __init__(self, message: str = "Token de taller inválido o expirado"):
        super().__init__(
            message=message,
            status_code=HTTPStatus.UNAUTHORIZED,
            error_code=ErrorCodes.AUTH_TOKEN_INVALID
        )


class WorkshopMinInscriptionsNotReachedException(SGSCTException):
    """Taller no alcanzó mínimo de inscripciones"""
    def __init__(self, workshop_id: int, current: int, min_required: int):
        super().__init__(
            message="El taller no alcanzó el mínimo de inscripciones",
            status_code=HTTPStatus.CONFLICT,
            error_code=ErrorCodes.BUSINESS_RULE_VIOLATION,
            details={
                "workshop_id": workshop_id,
                "current_inscriptions": current,
                "min_required": min_required
            }
        )


# =============================================================================
# EXCEPCIONES DE CONVALIDACIONES
# =============================================================================

class ConvalidationNotFoundException(NotFoundException):
    """Convalidación no encontrada"""
    def __init__(self, convalidation_id: int = None):
        details = {"convalidation_id": convalidation_id} if convalidation_id else {}
        super().__init__(message="Convalidación no encontrada", details=details)


class ConvalidationStateTransitionException(SGSCTException):
    """Transición de estado de convalidación no permitida"""
    def __init__(self, from_state: str, to_state: str, allowed_states: list = None):
        details = {
            "from_state": from_state,
            "to_state": to_state
        }
        if allowed_states:
            details["allowed_transitions"] = allowed_states
            
        super().__init__(
            message=f"No se puede transicionar de {from_state} a {to_state}",
            status_code=HTTPStatus.CONFLICT,
            error_code=ErrorCodes.INVALID_STATE_TRANSITION,
            details=details
        )


class InvalidConvalidationTypeException(ValidationException):
    """Tipo de convalidación no válido para el curso"""
    def __init__(self, convalidation_type: str, course_type: str):
        super().__init__(
            message="El tipo de convalidación no corresponde al tipo de curso",
            details={
                "convalidation_type": convalidation_type,
                "course_type": course_type
            }
        )


class DuplicateConvalidationException(ConflictException):
    """Ya existe una convalidación para este curso en esta solicitud"""
    def __init__(self, request_id: int, subject_id: int = None, workshop_id: int = None):
        details = {"request_id": request_id}
        if subject_id:
            details["subject_id"] = subject_id
        if workshop_id:
            details["workshop_id"] = workshop_id
            
        super().__init__(
            message="Ya existe una convalidación para este curso en esta solicitud",
            details=details
        )


class RequestNotFoundException(NotFoundException):
    """Solicitud de convalidación no encontrada"""
    def __init__(self, request_id: int = None):
        details = {"request_id": request_id} if request_id else {}
        super().__init__(message="Solicitud no encontrada", details=details)


# =============================================================================
# EXCEPCIONES DE VALIDACIÓN DE DATOS
# =============================================================================

class InvalidRUTException(ValidationException):
    """RUT inválido (formato o dígito verificador)"""
    def __init__(self, rut: str = None):
        details = {"rut": rut} if rut else {}
        super().__init__(message="El RUT ingresado no es válido", details=details)


class InvalidROLException(ValidationException):
    """ROL estudiantil inválido (debe ser 10 dígitos)"""
    def __init__(self, rol: str = None):
        details = {"rol": rol} if rol else {}
        super().__init__(message="El ROL debe tener exactamente 10 dígitos", details=details)


class InvalidEmailException(ValidationException):
    """Email inválido"""
    def __init__(self, email: str = None):
        details = {"email": email} if email else {}
        super().__init__(message="El email ingresado no es válido", details=details)


class InvalidGradeException(ValidationException):
    """Calificación fuera del rango válido (0-100)"""
    def __init__(self, grade: float, min_grade: int = 0, max_grade: int = 100):
        super().__init__(
            message=f"La calificación debe estar entre {min_grade} y {max_grade}",
            details={
                "grade": grade,
                "min": min_grade,
                "max": max_grade
            }
        )


class WeakPasswordException(ValidationException):
    """Contraseña no cumple requisitos mínimos"""
    def __init__(self, message: str = "La contraseña no cumple los requisitos mínimos"):
        super().__init__(message=message)


# =============================================================================
# EXCEPCIONES DE ARCHIVOS
# =============================================================================

class InvalidFileTypeException(ValidationException):
    """Tipo de archivo no permitido"""
    def __init__(self, file_type: str, allowed_types: list):
        super().__init__(
            message=f"Tipo de archivo no permitido. Formatos permitidos: {', '.join(allowed_types)}",
            details={
                "file_type": file_type,
                "allowed_types": allowed_types
            }
        )


class FileTooLargeException(ValidationException):
    """Archivo excede tamaño máximo"""
    def __init__(self, file_size: int, max_size: int):
        super().__init__(
            message=f"El archivo excede el tamaño máximo permitido ({max_size} bytes)",
            details={
                "file_size": file_size,
                "max_size": max_size
            }
        )


class FileUploadException(SGSCTException):
    """Error al cargar archivo"""
    def __init__(self, message: str = "Error al cargar el archivo", details: dict = None):
        super().__init__(
            message=message,
            status_code=HTTPStatus.INTERNAL_SERVER_ERROR,
            error_code=ErrorCodes.FILE_UPLOAD_FAILED,
            details=details
        )


# =============================================================================
# EXCEPCIONES DE BASE DE DATOS
# =============================================================================

class DatabaseConnectionException(DatabaseException):
    """Error de conexión a la base de datos"""
    def __init__(self, message: str = "Error de conexión con la base de datos"):
        super().__init__(message=message)


class DatabaseIntegrityException(DatabaseException):
    """Error de integridad referencial"""
    def __init__(self, message: str = "Error de integridad referencial", constraint: str = None):
        details = {"constraint": constraint} if constraint else {}
        super().__init__(message=message, details=details)


# =============================================================================
# EXCEPCIONES DE USUARIOS Y PROFESORES
# =============================================================================

class UserNotFoundException(NotFoundException):
    """Usuario no encontrado"""
    def __init__(self, user_id: int = None, email: str = None):
        details = {}
        if user_id:
            details["user_id"] = user_id
        if email:
            details["email"] = email
        super().__init__(message="Usuario no encontrado", details=details)


class ProfessorNotFoundException(NotFoundException):
    """Profesor no encontrado"""
    def __init__(self, professor_id: int = None, email: str = None):
        details = {}
        if professor_id:
            details["professor_id"] = professor_id
        if email:
            details["email"] = email
        super().__init__(message="Profesor no encontrado", details=details)


class DuplicateEmailException(ConflictException):
    """Email ya registrado en el sistema"""
    def __init__(self, email: str):
        super().__init__(
            message="El email ya está registrado",
            details={"email": email}
        )


class DuplicateRUTException(ConflictException):
    """RUT ya registrado en el sistema"""
    def __init__(self, rut: str):
        super().__init__(
            message="El RUT ya está registrado",
            details={"rut": rut}
        )