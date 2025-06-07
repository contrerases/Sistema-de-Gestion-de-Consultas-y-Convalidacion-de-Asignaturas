import os
from dotenv import load_dotenv
import mysql.connector

def test_connection():
    """
    Prueba la conexión a la base de datos usando las variables de entorno.
    """
    # Cargar variables de entorno
    load_dotenv()
    
    try:
        # Establecer conexión
        conn = mysql.connector.connect(
            host=os.getenv('DB_HOST'),
            user=os.getenv('DB_USER'),
            password=os.getenv('DB_PASSWORD'),
            database=os.getenv('DB_NAME'),
            port=int(os.getenv('DB_PORT', '3306'))
        )
        
        print("✅ ¡Conexión exitosa!")
        
        # Mostrar información de la base de datos
        cursor = conn.cursor()
        
        # Obtener versión de la base de datos
        cursor.execute("SELECT VERSION()")
        version = cursor.fetchone()
        print(f"\n🔍 Versión de la base de datos: {version[0]}")
        
        # Obtener tablas
        cursor.execute("SHOW TABLES")
        tables = cursor.fetchall()
        
        print("\n📋 Tablas en la base de datos:")
        for i, table in enumerate(tables, 1):
            print(f"   {i}. {table[0]}")
        
        # Cerrar cursor y conexión
        cursor.close()
        conn.close()
        
    except mysql.connector.Error as err:
        print(f"❌ Error al conectar a la base de datos: {err}")
        print("\n🔍 Verifica las siguientes configuraciones:")
        print(f"   - Host: {os.getenv('DB_HOST')}")
        print(f"   - Usuario: {os.getenv('DB_USER')}")
        print(f"   - Base de datos: {os.getenv('DB_NAME')}")
        print(f"   - Puerto: {os.getenv('DB_PORT')}")
        print("\nAsegúrate de que el servicio de base de datos esté en ejecución.")

if __name__ == "__main__":
    test_connection()
