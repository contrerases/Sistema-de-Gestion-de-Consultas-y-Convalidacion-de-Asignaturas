from pydantic_settings import BaseSettings
from pydantic import EmailStr, field_validator, computed_field
from typing import List, Optional
from functools import lru_cache
import os


class Settings(BaseSettings):
    # Sistema
    NAME: str
    ACRONYM: str
    VERSION: str
    # Configuración de API
    API_V1_PREFIX: str

    # Configuración del Servidor
    ENVIRONMENT: str
    BACKEND_PORT: int
    BACKEND_HOST: str
    DEBUG: bool
    ALLOWED_ORIGINS: str

    # Configuración Base de Datos
    MARIADB_HOST: str
    MARIADB_PORT: int
    MARIADB_ADMIN: str
    MARIADB_ADMIN_PASSWORD: str
    MARIADB_ROOT_PASSWORD: str
    MARIADB_DATABASE: str
    MARIADB_USER: str
    MARIADB_PASSWORD: str

    # Pool de conexiones
    DB_POOL_SIZE: int
    DB_MAX_OVERFLOW: int
    DB_POOL_TIMEOUT: int
    DB_POOL_RECYCLE: int

    # Configuración de Seguridad
    SECRET_KEY: str
    ALGORITHM: str
    ACCESS_TOKEN_EXPIRE_MINUTES: int
    REFRESH_TOKEN_EXPIRE_DAYS: int
    TOKEN_TYPE: str  # Bearer
    HASH_ALGORITHM: str
    BCRYPT_ROUNDS: int

    # Configuración de Seguridad
    WORKSHOP_TOKEN_LENGTH: int
    WORKSHOP_TOKEN_EXPIRATION_HOURS: int

    # Configuración de Archivos
    UPLOAD_DIR: str
    MAX_UPLOAD_SIZE: int
    ALLOWED_EXTENSIONS: str

    # Configuración de Logging
    LOG_LEVEL: str
    LOG_DIR: str
    LOG_FILE: str
    LOG_MAX_BYTES: int
    LOG_BACKUP_COUNT: int

    # Configuración SMTP
    SMTP_ENABLED: bool
    SMTP_SERVER: Optional[str]
    SMTP_PORT: int
    SMTP_USERNAME: Optional[EmailStr]
    SMTP_PASSWORD: Optional[str]
    SMTP_FROM_EMAIL: Optional[EmailStr]
    SMTP_TLS: bool

    # Paginación
    DEFAULT_PAGE_SIZE: int
    MAX_PAGE_SIZE: int

    @computed_field
    @property
    def ORIGINS_LIST(self) -> List[str]:
        """Convertir ALLOWED_ORIGINS string en lista"""
        return [origin.strip() for origin in self.ALLOWED_ORIGINS.split(",")]

    @computed_field
    @property
    def EXTENSIONS_LIST(self) -> List[str]:
        """Convertir ALLOWED_EXTENSIONS string en lista"""
        return [ext.strip() for ext in self.ALLOWED_EXTENSIONS.split(",")]

    @computed_field
    @property
    def UPLOAD_BASE_PATH(self) -> str:
        """Path base para uploads"""
        from pathlib import Path

        return str(Path(self.UPLOAD_DIR))

    @computed_field
    @property
    def CONVALIDATIONS_PATH(self) -> str:
        """Path para convalidaciones"""
        from pathlib import Path

        return str(Path(self.UPLOAD_DIR) / "convalidations")

    @computed_field
    @property
    def WORKSHOPS_PATH(self) -> str:
        """Path para talleres"""
        from pathlib import Path

        return str(Path(self.UPLOAD_DIR) / "workshops")

    @computed_field
    @property
    def DATABASE_URL(self) -> str:
        return (
            f"mysql+pymysql://{self.MARIADB_USER}:{self.MARIADB_PASSWORD}"
            f"@{self.MARIADB_HOST}:{self.MARIADB_PORT}/{self.MARIADB_DATABASE}"
        )

    @field_validator("ENVIRONMENT")
    def validate_environment(cls, v):
        if v not in ["dev", "prod", "test"]:
            raise ValueError("ENVIRONMENT debe ser dev, prod o test")
        return v

    @field_validator("LOG_LEVEL")
    def validate_log_level(cls, v):
        levels = ["DEBUG", "INFO", "WARNING", "ERROR", "CRITICAL"]
        if v.upper() not in levels:
            raise ValueError(f"LOG_LEVEL debe ser uno de: {', '.join(levels)}")
        return v.upper()

    class Config:
        case_sensitive = True
        env_file = ".env.dev"


def get_environment_file() -> str:
    env = os.getenv("ENVIRONMENT")
    return f".env.{env}"


@lru_cache
def get_settings() -> Settings:
    env_file = get_environment_file()
    return Settings(_env_file=env_file)


settings = get_settings()
