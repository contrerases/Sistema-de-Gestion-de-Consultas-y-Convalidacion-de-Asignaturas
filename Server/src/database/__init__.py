"""
Database module - Conexión y sesiones de base de datos
Sistema: SGSCT
"""

from src.database.base import Base
from src.database.connection import (
    engine,
    SessionLocal,
    get_db_connection,
    DatabaseConnection
)
from src.database.sessions import (
    get_db,
    get_db_context,
    TransactionManager,
    execute_in_transaction
)
from src.database.health import (
    DatabaseHealthCheck,
    async_check_db_health,
    require_healthy_db
)

__all__ = [
    # Base
    "Base",
    
    # Connection
    "engine",
    "SessionLocal",
    "get_db_connection",
    "DatabaseConnection",
    
    # Sessions
    "get_db",
    "get_db_context",
    "TransactionManager",
    "execute_in_transaction",
    
    # Health
    "DatabaseHealthCheck",
    "async_check_db_health",
    "require_healthy_db",
]
