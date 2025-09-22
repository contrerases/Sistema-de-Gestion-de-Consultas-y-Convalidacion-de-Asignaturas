from pydantic_settings import BaseSettings
from pydantic import EmailStr, field_validator
from typing import List, Optional
from functools import lru_cache
import os


class Settings(BaseSettings):
    # Configuración del Servidor
    ENVIRONMENT: str = "dev"
    BACKEND_PORT: int = 8000
    BACKEND_HOST: str = "localhost"
    DEBUG: bool = True
    ALLOWED_ORIGINS: List[str] = ["http://localhost:5173"]

    # Configuración Base de Datos
    MARIADB_HOST: str = "db"
    MARIADB_PORT: int = 3306
    MARIADB_ADMIN: str = "sgc_admin"
    MARIADB_ADMIN_PASSWORD: str = "sgc_admin_dev_password"
    MARIADB_ROOT_PASSWORD: str = "sgc_root_dev_password"
    MARIADB_DATABASE: str = "sgc_db_dev"
    MARIADB_USER: str = "sgc_user"
    MARIADB_PASSWORD: str = "sgc_user_dev_password"

    # Configuración de Seguridad
    SECRET_KEY: str = "your_secret_key_here_which_is_at_least_32_characters_long"
    ALGORITHM: str = "HS256"
    HASH_ALGORITHM: str = "bcrypt"
    SALT: str = "some_salt_value"
    ACCESS_TOKEN_EXPIRE_MINUTES: int = 60

    # Configuración SMTP
    SMTP_SERVER: Optional[str] = None
    SMTP_PORT: int = 587
    SMTP_USERNAME: Optional[EmailStr] = None
    SMTP_PASSWORD: Optional[str] = None
    SMTP_FROM_EMAIL: Optional[EmailStr] = None
    SMTP_TO_EMAIL: Optional[EmailStr] = None
    SMTP_TLS: bool = True

    @field_validator("ENVIRONMENT")
    def validate_environment(cls, e):
        if e not in ["dev", "prod", "test"]:
            raise ValueError("ENVIRONMENT debe ser dev, prod o test")
        return e

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
