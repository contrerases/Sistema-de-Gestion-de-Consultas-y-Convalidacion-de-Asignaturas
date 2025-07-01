import os
from dotenv import load_dotenv
import mariadb 

# Cargar variables de entorno desde .env
dotenv_path = os.getenv('ENV_PATH', '.env.dev')
load_dotenv(dotenv_path)

def get_db_connection():
   
    db_host =  os.getenv('DB_HOST')
    db_port =  int(os.getenv('DB_PORT', '3306'))
    db_user = os.getenv('DB_USER')
    db_password = os.getenv('DB_USER_PASSWORD')
    db_name = os.getenv('DB_NAME')

    try:
        print(f"Intentando conectar a la base de datos en host: {db_host}, puerto: {db_port}, usuario: {db_user}, base: {db_name}")
        conn = mariadb.connect(
            host=db_host,
            user=db_user,
            password=db_password,
            database=db_name,
            port=db_port
        )
        print(f"✅ Conexión exitosa a la base de datos en host: {db_host}, puerto: {db_port}")
        return conn
    except mariadb.Error as err:
        print(f"❌ Error al conectar a la base de datos en host: {db_host}, puerto: {db_port}: {err}")
        raise
