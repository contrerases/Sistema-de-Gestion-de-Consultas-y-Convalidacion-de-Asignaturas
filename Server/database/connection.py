import mariadb
from config.settings import settings

def get_db_connection():
    try:
        conn = mariadb.connect(
            host=settings.DB_HOST,
            port=settings.DB_PORT,
            user=settings.DB_USER,
            password=settings.DB_USER_PASSWORD,
            database=settings.DB_NAME
        )
        return conn
    except mariadb.Error as err:
        print(f"❌ Error al conectar a la base de datos: {err}")
        raise

