"""
Configuración de directorios de archivos
Sistema: SGSCT
"""
from pathlib import Path
from typing import Set
from src.app.settings import get_settings
from src.monitoring.logging import get_logger

logger = get_logger(__name__)
settings = get_settings()

# Directorios base (desde settings)
UPLOAD_BASE_DIR = Path(settings.UPLOAD_DIR)

# Estructura convalidations
CONVALIDATIONS_DIR = UPLOAD_BASE_DIR / "convalidations"
PERSONAL_PROJECTS_DIR = CONVALIDATIONS_DIR / "personal_projects"
CERTIFICATED_COURSES_DIR = CONVALIDATIONS_DIR / "certificated_courses"

# Estructura workshops
WORKSHOPS_DIR = UPLOAD_BASE_DIR / "workshops"
SYLLABUS_DIR = WORKSHOPS_DIR / "syllabus"
WORKSHOPS_CONVALIDATION_LIST_DIR = WORKSHOPS_DIR / "convalidation_list"

# Límites de archivo (desde settings)
MAX_FILE_SIZE = settings.MAX_UPLOAD_SIZE

# Extensiones permitidas por tipo (desde settings)
SYLLABUS_EXTENSIONS: Set[str] = set(settings.EXTENSIONS_LIST)
PERSONAL_PROJECT_EXTENSIONS: Set[str] = set(settings.EXTENSIONS_LIST)
CERTIFICATE_EXTENSIONS: Set[str] = set(settings.EXTENSIONS_LIST)


def verify_upload_directories() -> None:
    """
    Verifica y crea la estructura de directorios de archivos si no existe.
    Crea automáticamente los directorios faltantes con permisos adecuados.
    """
    required_dirs = [
        UPLOAD_BASE_DIR,
        CONVALIDATIONS_DIR,
        PERSONAL_PROJECTS_DIR,
        CERTIFICATED_COURSES_DIR,
        WORKSHOPS_DIR,
        SYLLABUS_DIR,
        WORKSHOPS_CONVALIDATION_LIST_DIR
    ]
    
    for directory in required_dirs:
        if not directory.exists():
            directory.mkdir(parents=True, exist_ok=True)
            logger.info(f"Directorio de archivos creado: {directory}")
