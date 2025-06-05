#!/bin/bash
set -e

# Función para esperar a que MariaDB esté lista
wait_for_mysql() {
    echo "Esperando a que MariaDB esté lista..."
    until mysqladmin ping -h localhost -u root -p"$MYSQL_ROOT_PASSWORD" --silent; do
        sleep 2
    done
    echo "MariaDB está lista!"
}

# Función para ejecutar scripts SQL en un directorio
execute_sql_scripts() {
    local dir="$1"
    if [ -d "$dir" ]; then
        echo "Ejecutando scripts SQL en $dir..."
        for sql_file in "$dir"/*.sql; do
            if [ -f "$sql_file" ]; then
                echo "Ejecutando: $sql_file"
                mysql -u root -p"$MYSQL_ROOT_PASSWORD" "$MYSQL_DATABASE" < "$sql_file" || exit 1
            fi
        done
    fi
}

# Esperar a que MariaDB esté lista
wait_for_mysql

# Crear la base de datos si no existe
echo "Creando base de datos $MYSQL_DATABASE si no existe..."
mysql -u root -p"$MYSQL_ROOT_PASSWORD" -e "CREATE DATABASE IF NOT EXISTS \`$MYSQL_DATABASE\` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"

# Crear usuario y otorgar permisos
echo "Configurando usuario $MYSQL_USER..."
mysql -u root -p"$MYSQL_ROOT_PASSWORD" -e "CREATE USER IF NOT EXISTS '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD';"
mysql -u root -p"$MYSQL_ROOT_PASSWORD" -e "GRANT ALL PRIVILEGES ON \`$MYSQL_DATABASE\`.* TO '$MYSQL_USER'@'%';"
mysql -u root -p"$MYSQL_ROOT_PASSWORD" -e "FLUSH PRIVILEGES;"

# Desactivar verificaciones de claves foráneas temporalmente
echo "Desactivando verificaciones de claves foráneas..."
mysql -u root -p"$MYSQL_ROOT_PASSWORD" "$MYSQL_DATABASE" -e "SET FOREIGN_KEY_CHECKS=0;"

# Ejecutar scripts de estructura
execute_sql_scripts "/docker-entrypoint-initdb.d/1_structure"

# Ejecutar scripts de población
execute_sql_scripts "/docker-entrypoint-initdb.d/2_population"

# Ejecutar procedimientos almacenados
execute_sql_scripts "/docker-entrypoint-initdb.d/3_procedures"

# Reactivar verificaciones de claves foráneas
echo "Reactivando verificaciones de claves foráneas..."
mysql -u root -p"$MYSQL_ROOT_PASSWORD" "$MYSQL_DATABASE" -e "SET FOREIGN_KEY_CHECKS=1;"

echo "¡Base de datos inicializada correctamente!"
