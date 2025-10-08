"""
Gestión de conexión a MariaDB con SQLAlchemy
Sistema: SGSCT
"""
from sqlalchemy import create_engine, event, text
from sqlalchemy.orm import sessionmaker
from sqlalchemy.pool import QueuePool
from sqlalchemy.exc import SQLAlchemyError
import logging
from typing import Optional

from src.app.settings import get_settings
from src.database.base import Base

logger = logging.getLogger(__name__)


class DatabaseConnection:
    """
    Gestor de conexión a MariaDB con pool de conexiones
    """
    
    def __init__(self):
        self.settings = get_settings()
        self._engine: Optional[object] = None
        self._session_factory: Optional[sessionmaker] = None
    
    @property
    def engine(self):
        """Lazy initialization del engine"""
        if self._engine is None:
            self._create_engine()
        return self._engine
    
    @property
    def session_factory(self) -> sessionmaker:
        """Lazy initialization del session factory"""
        if self._session_factory is None:
            self._create_session_factory()
        return self._session_factory
    
    def _create_engine(self):
        """Crear engine de SQLAlchemy con configuración de pool"""
        try:
            self._engine = create_engine(
                self.settings.DATABASE_URL,
                poolclass=QueuePool,
                pool_size=self.settings.DB_POOL_SIZE,
                max_overflow=self.settings.DB_MAX_OVERFLOW,
                pool_timeout=self.settings.DB_POOL_TIMEOUT,
                pool_recycle=self.settings.DB_POOL_RECYCLE,
                pool_pre_ping=True,  # Verificar conexiones antes de usar
                echo=self.settings.DEBUG,  # SQL queries visible en modo DEBUG
                isolation_level="READ COMMITTED",
                connect_args={
                    "charset": "utf8mb4",
                    "connect_timeout": 10
                }
            )
            
            # Event listeners para monitoreo
            self._setup_event_listeners()
            
            logger.info(f"Engine de base de datos creado: {self.settings.MARIADB_HOST}")
        
        except SQLAlchemyError as e:
            logger.error(f"Error al crear engine de base de datos: {e}")
            raise
    
    def _create_session_factory(self):
        """Crear session factory"""
        self._session_factory = sessionmaker(
            autocommit=False,
            autoflush=False,
            bind=self.engine,
            expire_on_commit=False
        )
        logger.info("Session factory creado")
    
    def _setup_event_listeners(self):
        """Configurar listeners de eventos del pool"""
        
        @event.listens_for(self._engine, "connect")
        def receive_connect(dbapi_conn, connection_record):
            """Evento: Nueva conexión establecida"""
            logger.debug("Nueva conexión establecida al pool de base de datos")
        
        @event.listens_for(self._engine, "checkout")
        def receive_checkout(dbapi_conn, connection_record, connection_proxy):
            """Evento: Conexión obtenida del pool"""
            logger.debug("Conexión obtenida del pool")
        
        @event.listens_for(self._engine, "checkin")
        def receive_checkin(dbapi_conn, connection_record):
            """Evento: Conexión devuelta al pool"""
            logger.debug("Conexión devuelta al pool")
    
    def test_connection(self) -> bool:
        """
        Probar conexión a la base de datos
        
        Returns:
            bool: True si la conexión es exitosa
        """
        try:
            with self.engine.connect() as conn:
                result = conn.execute(text("SELECT 1"))
                result.close()
            logger.info("Conexión a base de datos exitosa")
            return True
        except SQLAlchemyError as e:
            logger.error(f"Error al conectar a base de datos: {e}")
            return False
    
    def get_pool_status(self) -> dict:
        """
        Obtener estado del pool de conexiones
        
        Returns:
            dict: Información del pool
        """
        pool = self.engine.pool
        return {
            "size": pool.size(),
            "checked_in": pool.checkedin(),
            "checked_out": pool.checkedout(),
            "overflow": pool.overflow(),
            "total": pool.size() + pool.overflow()
        }
    
    def dispose(self):
        """Cerrar todas las conexiones del pool"""
        if self._engine:
            self._engine.dispose()
            logger.info("Pool de conexiones cerrado")
    
    def create_tables(self):
        """
        Crear todas las tablas definidas en los modelos
        NOTA: En producción usar Alembic para migraciones
        """
        try:
            Base.metadata.create_all(bind=self.engine)
            logger.info("Tablas creadas exitosamente")
        except SQLAlchemyError as e:
            logger.error(f"Error al crear tablas: {e}")
            raise


# Singleton de la conexión
_db_connection: Optional[DatabaseConnection] = None


def get_db_connection() -> DatabaseConnection:
    """
    Obtener instancia singleton de DatabaseConnection
    
    Returns:
        DatabaseConnection: Instancia de conexión
    """
    global _db_connection
    if _db_connection is None:
        _db_connection = DatabaseConnection()
    return _db_connection


# Alias para facilitar uso
engine = get_db_connection().engine
SessionLocal = get_db_connection().session_factory
