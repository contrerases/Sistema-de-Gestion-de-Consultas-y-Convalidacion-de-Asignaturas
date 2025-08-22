class SGSCTException(Exception):
    """Excepción base del sistema SGSCT"""
    def __init__(self, message: str, status_code: int = 400):
        self.message = message
        self.status_code = status_code
        super().__init__(self.message)


class NotFoundException(SGSCTException):
    """Excepción para recursos no encontrados"""
    def __init__(self, message: str = "Recurso no encontrado"):
        super().__init__(message, 404)


class ConflictException(SGSCTException):
    """Excepción para conflictos de datos"""
    def __init__(self, message: str = "Conflicto en los datos"):
        super().__init__(message, 409)


class UnauthorizedException(SGSCTException):
    """Excepción para acceso no autorizado"""
    def __init__(self, message: str = "Acceso no autorizado"):
        super().__init__(message, 401)


class ForbiddenException(SGSCTException):
    """Excepción para acceso prohibido"""
    def __init__(self, message: str = "Acceso prohibido"):
        super().__init__(message, 403)


class ValidationException(SGSCTException):
    """Excepción para errores de validación"""
    def __init__(self, message: str = "Error de validación"):
        super().__init__(message, 422)

class DatabaseException(SGSCTException):
    """Excepción para errores de base de datos"""
    def __init__(self, message: str = "Error en la base de datos"):
        super().__init__(message, 500)

class EmailException(SGSCTException):
    """Excepción para errores de correo electrónico"""
    def __init__(self, message: str = "Error en el correo electrónico"):
        super().__init__(message, 500)

class AuthenticationException(SGSCTException):
    """Excepción para errores de autenticación"""
    def __init__(self, message: str = "Error en la autenticación"):
        super().__init__(message, 401)