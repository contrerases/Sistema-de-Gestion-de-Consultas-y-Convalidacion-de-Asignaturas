"""
Constantes de configuración del sistema SGSCT
Sistema de Gestión de Consultas y Convalidaciones de Talleres
"""

# =============================================================================
# INFORMACIÓN DEL SISTEMA
# =============================================================================
# NOTA: Nombres y versiones del sistema ahora están en src/app/settings.py
# Usar get_settings().PROJECT_NAME, get_settings().VERSION, etc.


# =============================================================================
# PERÍODOS ACADÉMICOS
# =============================================================================


class AcademicYear:
    """Configuración de años académicos válidos"""

    MIN_YEAR = 2020
    MAX_YEAR = 2100

    @staticmethod
    def is_valid(year: int) -> bool:
        """Valida si el año académico es válido"""
        return AcademicYear.MIN_YEAR <= year <= AcademicYear.MAX_YEAR


# =============================================================================
# SEMESTRES
# =============================================================================


class Semester:
    """Configuración de semestres académicos válidos"""

    VALID_SEMESTERS = [1, 2]

    @staticmethod
    def is_valid(semester: int) -> bool:
        """Valida si el semestre académico es válido"""
        return semester in Semester.VALID_SEMESTERS


# =============================================================================
# VALIDACIÓN Y FORMATOS
# =============================================================================


class ValidationRules:
    """Reglas de validación del sistema"""

    # RUT
    RUT_MIN_LENGTH = 8  # 7 dígitos + verificador
    RUT_MAX_LENGTH = 9  # 8 dígitos + verificador

    # ROL (Rol único estudiantil)
    ROL_LENGTH = 10  # Exactamente 10 dígitos

    # Email
    EMAIL_MAX_LENGTH = 255
    EMAIL_PATTERN = r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$"

    # Nombres
    NAME_MAX_LENGTH = 255
    NAME_MIN_LENGTH = 2

    # Contraseñas
    PASSWORD_MIN_LENGTH = 8
    PASSWORD_MAX_LENGTH = 128

    # Teléfonos
    PHONE_MAX_LENGTH = 15

    # Años académicos
    YEAR_MIN = 2020
    YEAR_MAX = 2100

    # Talleres
    WORKSHOP_MIN_INSCRIPTIONS_PERCENTAGE = 0.5  # 50% del cupo mínimo
    WORKSHOP_MAX_CAPACITY = 200
    WORKSHOP_MIN_CAPACITY = 5

    # Créditos de asignaturas
    CREDITS_MIN = 1
    CREDITS_MAX = 10

    # Calificaciones (escala 0-100)
    GRADE_MIN = 0
    GRADE_MAX = 100
    GRADE_PASSING = 55  # Nota mínima de aprobación


# =============================================================================
# PAGINACIÓN
# =============================================================================


class Pagination:
    """Constantes de paginación"""

    DEFAULT_PAGE = 1
    DEFAULT_PAGE_SIZE = 20
    MAX_PAGE_SIZE = 100
    MIN_PAGE_SIZE = 1


# =============================================================================
# PATRONES DE VALIDACIÓN
# =============================================================================


class ValidationPatterns:
    """Patrones regex para validación"""

    # RUT: 7-8 dígitos + dígito verificador (puede ser K)
    RUT = r"^[0-9]{7,8}[0-9kK]$"

    # ROL: Exactamente 10 dígitos
    ROL = r"^[0-9]{10}$"

    # Email
    EMAIL = r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$"

    # Teléfono: formato chileno
    PHONE = r"^\+?56?[2-9]\d{8}$"

    # Slug (para URLs amigables)
    SLUG = r"^[a-z0-9]+(?:-[a-z0-9]+)*$"


class Limits:
    """Límites de longitud para validación y uso general"""

    DESCRIPTION_MAX = 1000
    COMMENT_MAX = 1000
    MESSAGE_MAX = 1000
    TITLE_MAX = 255
    NAME_MAX = 255
    NAME_MIN = 3
    ACRONYM_MAX = 10
    ACRONYM_MIN = 2
    CODE_MAX = 20
    CODE_MIN = 3
    SLUG_MAX = 255
    PATH_MAX = 500
    TOKEN_MAX = 255
