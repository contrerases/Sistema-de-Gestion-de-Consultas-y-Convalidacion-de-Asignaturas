"""
Script de prueba de conexión a base de datos
Ejecutar: python -m src.database.test_connection
"""
import sys
from src.monitoring.logging import get_logger

from src.database import (
    get_db_connection,
    DatabaseHealthCheck,
    require_healthy_db
)

logger = get_logger(__name__)


def main():
    """Probar conexión a la base de datos"""
    
    logger.info("=" * 60)
    logger.info("PRUEBA DE CONEXIÓN A BASE DE DATOS")
    logger.info("=" * 60)
    
    # 1. Obtener conexión
    logger.info("\n1. Obteniendo conexión...")
    try:
        db_conn = get_db_connection()
        logger.info("   ✓ Conexión obtenida")
    except Exception as e:
        logger.error(f"   ✗ Error: {e}")
        return False
    
    # 2. Probar conexión básica
    logger.info("\n2. Probando conexión básica...")
    if db_conn.test_connection():
        logger.info("   ✓ Conexión exitosa")
    else:
        logger.error("   ✗ Conexión fallida")
        return False
    
    # 3. Health check
    logger.info("\n3. Health check...")
    health = DatabaseHealthCheck.check_connection()
    logger.info(f"   Status: {health['status']}")
    logger.info(f"   Database: {health.get('database', 'N/A')}")
    logger.info(f"   Host: {health.get('host', 'N/A')}")
    logger.info(f"   Response time: {health.get('response_time_ms', 'N/A')} ms")
    
    # 4. Versión de la base de datos
    logger.info("\n4. Versión de base de datos...")
    version = DatabaseHealthCheck.check_database_version()
    logger.info(f"   Versión: {version.get('version', 'N/A')}")
    
    # 5. Estado del pool
    logger.info("\n5. Estado del pool de conexiones...")
    pool = DatabaseHealthCheck.check_pool_status()
    logger.info(f"   Pool size: {pool.get('pool_size', 'N/A')}")
    logger.info(f"   Checked out: {pool.get('checked_out', 'N/A')}")
    logger.info(f"   Checked in: {pool.get('checked_in', 'N/A')}")
    logger.info(f"   Total: {pool.get('total_connections', 'N/A')}")
    
    # 6. Health check completo
    logger.info("\n6. Health check detallado...")
    detailed = DatabaseHealthCheck.detailed_health_check()
    logger.info(f"   Status general: {detailed['status']}")
    
    logger.info("\n" + "=" * 60)
    logger.info("PRUEBA COMPLETADA EXITOSAMENTE")
    logger.info("=" * 60)
    
    return True


if __name__ == "__main__":
    try:
        success = main()
        sys.exit(0 if success else 1)
    except Exception as e:
        logger.error(f"\n✗ Error crítico: {e}")
        import traceback
        traceback.print_exc()
        sys.exit(1)
