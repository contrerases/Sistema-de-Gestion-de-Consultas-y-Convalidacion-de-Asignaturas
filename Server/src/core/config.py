from pydantic_settings import BaseSettings
import os

class Settings(BaseSettings):
    ENVIRONMENT: str = "dev"
    BACKEND_PORT: int = 8000

    MARIADB_HOST: str = "db"
    MARIADB_PORT: int = 3306
    MARIADB_ADMIN: str = "sgc_admin"
    MARIADB_ADMIN_PASSWORD: str = "sgc_admin_dev_password"
    MARIADB_ROOT_PASSWORD: str = "sgc_root_dev_password"
    MARIADB_DATABASE: str = "sgc_db_dev"
    MARIADB_USER: str = "sgc_user"
    MARIADB_PASSWORD: str = "sgc_user_dev_password"

    ALLOWED_ORIGINS: str = "http://localhost:5173"
    
    HASH_ALGORITHM: str = "bcrypt"
    SALT: str = "supersalto_8f7c2b1a9d6e5f3b0c"

    SECRET_KEY: str = "supersecreto_4e8f7c2b1a9d6e5f3b0c"
    ACCESS_TOKEN_EXPIRE_MINUTES: int = 60
    ALGORITHM: str = "HS256"

    SMTP_SERVER: str = ""
    SMTP_PORT: int = 587
    SMTP_USERNAME: str = ""
    SMTP_PASSWORD: str = ""
    SMTP_FROM_EMAIL: str = ""
    SMTP_TO_EMAIL: str = ""
    
    class Config:
        case_sensitive = True

def create_settings() -> Settings:
    environment = os.getenv("ENVIRONMENT", "dev")
    env_files = {
        "dev": ".env.dev",
        "prod": ".env.prod"
    }
    env_file = env_files.get(environment, ".env.dev")
    return Settings(_env_file=env_file)


settings = create_settings()