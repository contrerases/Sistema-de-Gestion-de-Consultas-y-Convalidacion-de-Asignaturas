"""
Gestión de conexión a MariaDB con SQLAlchemy
"""
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker, Session
from sqlalchemy.pool import QueuePool
from typing import Generator
from src.app.settings import Settings

settings = Settings()

# Construcción de URL de conexión a MariaDB
DATABASE_URL = (
    f"mariadb+mariadbconnector://{settings.MARIADB_USER}:{settings.MARIADB_PASSWORD}"
    f"@{settings.MARIADB_HOST}:{settings.MARIADB_PORT}/{settings.MARIADB_DATABASE}"
)

# Engine de SQLAlchemy con pool de conexiones
engine = create_engine(
    DATABASE_URL,
    poolclass=QueuePool,
    pool_size=10,
    max_overflow=20,
    pool_pre_ping=True,  # Verificar conexión antes de usar
    echo=settings.DEBUG,  # Log de queries en modo debug
)

# Session factory
SessionLocal = sessionmaker(
    autocommit=False,
    autoflush=False,
    bind=engine
)


def get_db() -> Generator[Session, None, None]:
    """
    Dependency para obtener sesión de base de datos
    
    Uso en FastAPI:
    ```python
    @router.get("/items")
    def get_items(db: Session = Depends(get_db)):
        return db.query(Item).all()
    ```
    """
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()


class Database:
    """
    Clase utilitaria para operaciones de base de datos
    """
    
    @staticmethod
    def init_db():
        """Inicializar tablas (si se usa create_all)"""
        from src.core.database import Base
        Base.metadata.create_all(bind=engine)
    
    @staticmethod
    def get_session() -> Session:
        """Obtener sesión individual"""
        return SessionLocal()
