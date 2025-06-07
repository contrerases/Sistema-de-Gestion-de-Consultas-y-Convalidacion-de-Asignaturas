import os
from dotenv import load_dotenv
import mysql.connector

# Cargar variables de entorno desde .env
load_dotenv()

def get_db_connection():
    """
    Establece y retorna una conexión a la base de datos usando las variables de entorno.
    """
    try:
        conn = mysql.connector.connect(
            host=os.getenv('DB_HOST'),
            user=os.getenv('DB_USER'),
            password=os.getenv('DB_PASSWORD'),
            database=os.getenv('DB_NAME'),
            port=int(os.getenv('DB_PORT', '3306'))
        )
        print("✅ Conexión exitosa a la base de datos")
        return conn
    except mysql.connector.Error as err:
        print(f"❌ Error al conectar a la base de datos: {err}")
        return None