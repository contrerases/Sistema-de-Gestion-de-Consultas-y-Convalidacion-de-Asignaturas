#!/bin/bash
set -e

# Esperar a que MariaDB esté listo
echo "Esperando a que MariaDB esté listo..."
until mysql -h db -u root -p${MYSQL_ROOT_PASSWORD} -e "SELECT 1"; do
  echo "MariaDB no está listo - esperando..."
  sleep 2
done

echo "MariaDB está listo, inicializando la base de datos..."

# Crear la base de datos si no existe
mysql -h db -u root -p${MYSQL_ROOT_PASSWORD} -e "CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};"

# Crear las tablas
echo "Creando estructura de tablas..."
mysql -h db -u root -p${MYSQL_ROOT_PASSWORD} ${MYSQL_DATABASE} < /app/database/structure.sql

# Insertar datos iniciales
echo "Insertando datos iniciales..."
mysql -h db -u root -p${MYSQL_ROOT_PASSWORD} ${MYSQL_DATABASE} < /app/database/poblation.sql

# Importar todos los procedimientos almacenados
echo "Creando procedimientos almacenados..."
for sql_file in /app/database/procedures/*.sql; do
  echo "Importando procedimiento: ${sql_file}"
  mysql -h db -u root -p${MYSQL_ROOT_PASSWORD} ${MYSQL_DATABASE} < ${sql_file}
done

echo "Inicialización de la base de datos completada."
