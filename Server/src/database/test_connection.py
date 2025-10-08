"""
Script de prueba de conexión a base de datos
Ejecutar: python -m src.database.test_connection
"""
import sys

from src.database import (
    get_db_connection,
    DatabaseHealthCheck,
    require_healthy_db
)


def main():
    """Probar conexión a la base de datos"""
    
    print("=" * 60)
    print("PRUEBA DE CONEXIÓN A BASE DE DATOS")
    print("=" * 60)
    
    # 1. Obtener conexión
    print("\n1. Obteniendo conexión...")
    try:
        db_conn = get_db_connection()
        print("   ✓ Conexión obtenida")
    except Exception as e:
        print(f"   ✗ Error: {e}")
        return False
    
    # 2. Probar conexión básica
    print("\n2. Probando conexión básica...")
    if db_conn.test_connection():
        print("   ✓ Conexión exitosa")
    else:
        print("   ✗ Conexión fallida")
        return False
    
    # 3. Health check
    print("\n3. Health check...")
    health = DatabaseHealthCheck.check_connection()
    print(f"   Status: {health['status']}")
    print(f"   Database: {health.get('database', 'N/A')}")
    print(f"   Host: {health.get('host', 'N/A')}")
    print(f"   Response time: {health.get('response_time_ms', 'N/A')} ms")
    
    # 4. Versión de la base de datos
    print("\n4. Versión de base de datos...")
    version = DatabaseHealthCheck.check_database_version()
    print(f"   Versión: {version.get('version', 'N/A')}")
    
    # 5. Estado del pool
    print("\n5. Estado del pool de conexiones...")
    pool = DatabaseHealthCheck.check_pool_status()
    print(f"   Pool size: {pool.get('pool_size', 'N/A')}")
    print(f"   Checked out: {pool.get('checked_out', 'N/A')}")
    print(f"   Checked in: {pool.get('checked_in', 'N/A')}")
    print(f"   Total: {pool.get('total_connections', 'N/A')}")
    
    # 6. Health check completo
    print("\n6. Health check detallado...")
    detailed = DatabaseHealthCheck.detailed_health_check()
    print(f"   Status general: {detailed['status']}")
    
    print("\n" + "=" * 60)
    print("PRUEBA COMPLETADA EXITOSAMENTE")
    print("=" * 60)
    
    return True


if __name__ == "__main__":
    try:
        success = main()
        sys.exit(0 if success else 1)
    except Exception as e:
        print(f"\n✗ Error crítico: {e}")
        import traceback
        traceback.print_exc()
        sys.exit(1)
