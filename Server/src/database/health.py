"""
Health check para base de datos
Sistema: SGSCT
"""
from sqlalchemy import text
from sqlalchemy.exc import SQLAlchemyError
from datetime import datetime
import logging

from src.database.connection import get_db_connection
from src.core.exceptions import DatabaseConnectionException

logger = logging.getLogger(__name__)


class DatabaseHealthCheck:
    """
    Verificador de salud de la base de datos
    """
    
    @staticmethod
    def check_connection() -> dict:
        """
        Verificar conexión básica a la base de datos
        
        Returns:
            dict: Estado de la conexión
            
        Ejemplo:
        ```python
        {
            "status": "healthy",
            "timestamp": "2025-10-06T10:30:00",
            "database": "sgc_db_dev",
            "response_time_ms": 15.5
        }
        ```
        """
        start_time = datetime.now()
        
        try:
            db_conn = get_db_connection()
            
            with db_conn.engine.connect() as conn:
                result = conn.execute(text("SELECT 1 as health_check"))
                result.close()
            
            end_time = datetime.now()
            response_time = (end_time - start_time).total_seconds() * 1000
            
            return {
                "status": "healthy",
                "timestamp": datetime.now().isoformat(),
                "database": db_conn.settings.MARIADB_DATABASE,
                "host": db_conn.settings.MARIADB_HOST,
                "response_time_ms": round(response_time, 2)
            }
        
        except SQLAlchemyError as e:
            logger.error(f"Database health check falló: {e}")
            return {
                "status": "unhealthy",
                "timestamp": datetime.now().isoformat(),
                "error": str(e)
            }
        except Exception as e:
            logger.error(f"Error inesperado en health check: {e}")
            return {
                "status": "unhealthy",
                "timestamp": datetime.now().isoformat(),
                "error": f"Error inesperado: {str(e)}"
            }
    
    @staticmethod
    def check_pool_status() -> dict:
        """
        Verificar estado del pool de conexiones
        
        Returns:
            dict: Estado del pool
            
        Ejemplo:
        ```python
        {
            "pool_size": 10,
            "checked_in": 8,
            "checked_out": 2,
            "overflow": 0,
            "total_connections": 10
        }
        ```
        """
        try:
            db_conn = get_db_connection()
            pool_status = db_conn.get_pool_status()
            
            return {
                "status": "ok",
                "pool_size": pool_status["size"],
                "checked_in": pool_status["checked_in"],
                "checked_out": pool_status["checked_out"],
                "overflow": pool_status["overflow"],
                "total_connections": pool_status["total"]
            }
        
        except Exception as e:
            logger.error(f"Error al obtener estado del pool: {e}")
            return {
                "status": "error",
                "error": str(e)
            }
    
    @staticmethod
    def check_database_version() -> dict:
        """
        Obtener versión de MariaDB
        
        Returns:
            dict: Información de versión
        """
        try:
            db_conn = get_db_connection()
            
            with db_conn.engine.connect() as conn:
                result = conn.execute(text("SELECT VERSION() as version"))
                row = result.fetchone()
                version = row[0] if row else "unknown"
                result.close()
            
            return {
                "status": "ok",
                "version": version,
                "database_type": "MariaDB"
            }
        
        except SQLAlchemyError as e:
            logger.error(f"Error al obtener versión de base de datos: {e}")
            return {
                "status": "error",
                "error": str(e)
            }
    
    @staticmethod
    def detailed_health_check() -> dict:
        """
        Health check completo con toda la información
        
        Returns:
            dict: Estado completo del sistema de base de datos
        """
        connection_status = DatabaseHealthCheck.check_connection()
        pool_status = DatabaseHealthCheck.check_pool_status()
        version_info = DatabaseHealthCheck.check_database_version()
        
        is_healthy = connection_status["status"] == "healthy"
        
        return {
            "status": "healthy" if is_healthy else "unhealthy",
            "timestamp": datetime.now().isoformat(),
            "connection": connection_status,
            "pool": pool_status,
            "version": version_info
        }


async def async_check_db_health() -> bool:
    """
    Async wrapper para health check - útil en lifespan de FastAPI
    
    Returns:
        bool: True si la base de datos está saludable
    """
    result = DatabaseHealthCheck.check_connection()
    return result["status"] == "healthy"


def require_healthy_db():
    """
    Verificar que la base de datos esté disponible, lanza excepción si no
    
    Raises:
        DatabaseConnectionException: Si la base de datos no está disponible
        
    Uso:
    ```python
    # Al inicio de la aplicación
    require_healthy_db()
    ```
    """
    result = DatabaseHealthCheck.check_connection()
    
    if result["status"] != "healthy":
        error_msg = result.get("error", "Base de datos no disponible")
        logger.critical(f"Base de datos no disponible: {error_msg}")
        raise DatabaseConnectionException(error_msg)
    
    logger.info("Base de datos disponible y saludable")
