from pydantic_settings import BaseSettings
from pydantic import EmailStr, field_validator, computed_field
from typing import List, Optional
from functools import lru_cache
import os


class Settings(BaseSettings):
    # Sistema
    NAME: str = "Sistema de Gestión de Solicitudes de Convalidacion y Talleres"
    ACRONYM: str = "SGSCT"
    VERSION: str = "1.0.0" 
    # Configuración de API
    API_V1_PREFIX: str = "/api/v1"

    # Configuración del Servidor
    ENVIRONMENT: str = "dev"
    BACKEND_PORT: int = 8000
    BACKEND_HOST: str = "0.0.0.0"
    DEBUG: bool = True
    ALLOWED_ORIGINS: str = "http://localhost:5173,http://localhost:5174"
    
    CORS_ORIGINS: str = ""
    
    @computed_field
    @property
    def ORIGINS_LIST(self) -> List[str]:
        """Convertir ALLOWED_ORIGINS string en lista"""
        return [origin.strip() for origin in self.ALLOWED_ORIGINS.split(",")]
    
    
    # Configuración Base de Datos
    MARIADB_HOST: str = "db"
    MARIADB_PORT: int = 3306
    MARIADB_ADMIN: str = "sgc_admin"
    MARIADB_ADMIN_PASSWORD: str = "sgc_admin_dev_password"
    MARIADB_ROOT_PASSWORD: str = "sgc_root_dev_password"
    MARIADB_DATABASE: str = "sgc_db_dev"
    MARIADB_USER: str = "sgc_user"
    MARIADB_PASSWORD: str = "sgc_user_dev_password"
    
    # Pool de conexiones
    DB_POOL_SIZE: int = 10
    DB_MAX_OVERFLOW: int = 20
    DB_POOL_TIMEOUT: int = 30
    DB_POOL_RECYCLE: int = 3600
    
    # Configuración de Seguridad
    SECRET_KEY: str = "your_secret_key_here_which_is_at_least_32_characters_long"
    ALGORITHM: str = "HS256"
    HASH_ALGORITHM: str = "bcrypt"
    ACCESS_TOKEN_EXPIRE_MINUTES: int = 60
    REFRESH_TOKEN_EXPIRE_DAYS: int = 7
    
    # Configuración de Archivos
    UPLOAD_DIR: str = "files"
    MAX_UPLOAD_SIZE: int = 10 * 1024 * 1024  # 10 MB
    ALLOWED_EXTENSIONS: str = ".pdf"
    
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
    
    # Configuración de Logging
    LOG_LEVEL: str = "INFO"
    LOG_DIR: str = "logs"
    LOG_FILE: str = "app.log"
    LOG_MAX_BYTES: int = 10 * 1024 * 1024  # 10 MB
    LOG_BACKUP_COUNT: int = 5
    
    # Configuración SMTP
    SMTP_ENABLED: bool = False
    SMTP_SERVER: Optional[str] = None
    SMTP_PORT: int = 587
    SMTP_USERNAME: Optional[EmailStr] = None
    SMTP_PASSWORD: Optional[str] = None
    SMTP_FROM_EMAIL: Optional[EmailStr] = None
    SMTP_TLS: bool = True
    
    # Paginación
    DEFAULT_PAGE_SIZE: int = 20
    MAX_PAGE_SIZE: int = 100

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
        valid_levels = ["DEBUG", "INFO", "WARNING", "ERROR", "CRITICAL"]
        if v.upper() not in valid_levels:
            raise ValueError(f"LOG_LEVEL debe ser uno de: {', '.join(valid_levels)}")
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
