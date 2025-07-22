import os
from pathlib import Path
from dotenv import load_dotenv
from pydantic_settings import BaseSettings

# Ruta base del proyecto (raíz)
BASE_DIR = Path(__file__).resolve().parent.parent

# Cargar .env o .env.dev según variable de entorno ENV_PATH, o por defecto .env.dev
ENV_PATH = os.getenv('ENV_PATH', BASE_DIR / '.env.dev')
load_dotenv(dotenv_path=ENV_PATH)

class Settings(BaseSettings):
    # === BASE DE DATOS ===
    DB_HOST: str = os.getenv('DB_HOST', 'localhost')
    DB_PORT: int = int(os.getenv('DB_PORT', 3306))
    DB_USER: str = os.getenv('DB_USER', 'root')
    DB_USER_PASSWORD: str = os.getenv('DB_USER_PASSWORD', '')
    DB_NAME: str = os.getenv('DB_NAME', 'sgsct')

    # === SEGURIDAD Y JWT ===
    SECRET_KEY: str = os.getenv('SECRET_KEY', '')
    ACCESS_TOKEN_EXPIRE_MINUTES: int = int(os.getenv('ACCESS_TOKEN_EXPIRE_MINUTES', 60))
    ALGORITHM: str = os.getenv('ALGORITHM', 'HS256')

    # === CONTRASEÑAS ===
    PASSWORD_HASH_ALGORITHM: str = 'bcrypt'  # Algoritmo estándar para hashear contraseñas

    # === CORREO (si usas notificaciones por email) ===
    SMTP_HOST: str = os.getenv('SMTP_HOST', '')
    SMTP_PORT: int = int(os.getenv('SMTP_PORT', 587))
    SMTP_USER: str = os.getenv('SMTP_USER', '')
    SMTP_PASSWORD: str = os.getenv('SMTP_PASSWORD', '')
    EMAIL_FROM: str = os.getenv('EMAIL_FROM', '')

    # === OTROS ===
    ENV: str = os.getenv('ENV', 'development')  # development, production, etc.
    DEBUG: bool = os.getenv('DEBUG', 'True').lower() in ('true', '1', 'yes')

    class Config:
        case_sensitive = True

settings = Settings() 