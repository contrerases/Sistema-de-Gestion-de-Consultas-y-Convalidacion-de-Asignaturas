import mariadb

def get_db_connection():
    conn = mariadb.connect(
        user="root",
        password="1234",
        host="localhost",
        port=3312,
        database="SGC"
    )
    return conn