# Configuración de la Base de Datos

Este directorio contiene los scripts necesarios para inicializar y poblar la base de datos MariaDB/MySQL del sistema SGSCAT.

## Estructura de Directorios

- `docker-entrypoint-initdb.d/`: Contiene los scripts que se ejecutarán automáticamente al iniciar el contenedor de la base de datos.
  - `00_init_database.sh`: Script principal de inicialización.
  - `1_structure/`: Scripts de creación de la estructura de la base de datos (tablas).
  - `2_population/`: Scripts para poblar las tablas con datos iniciales.
  - `3_procedures/`: Procedimientos almacenados de la base de datos.

## Variables de Entorno

El archivo `.env` en la raíz del proyecto debe contener las siguientes variables:

```
# Configuración de la base de datos
MYSQL_ROOT_PASSWORD=root_password
MYSQL_DATABASE=sgc
MYSQL_USER=sgc_user
MYSQL_PASSWORD=password_segura
```

## Iniciar los Contenedores

Para iniciar los contenedores (incluyendo la base de datos), ejecuta:

```bash
docker-compose up -d
```

## Detener los Contenedores

Para detener los contenedores sin eliminar los volúmenes (datos):

```bash
docker-compose down
```

## Eliminar Volúmenes

Si necesitas eliminar completamente los volúmenes (incluyendo los datos de la base de datos):

```bash
docker-compose down -v
```

## Acceso a la Base de Datos

- **Host**: localhost
- **Puerto**: 3306
- **Usuario root**: root
- **Contraseña root**: (especificada en MYSQL_ROOT_PASSWORD)
- **Base de datos**: (especificada en MYSQL_DATABASE)
- **Usuario de la aplicación**: (especificado en MYSQL_USER)
- **Contraseña de la aplicación**: (especificada en MYSQL_PASSWORD)

## Solución de Problemas

### La base de datos no se inicializa correctamente

1. Verifica los logs del contenedor de la base de datos:
   ```bash
   docker-compose logs db
   ```

2. Verifica que los archivos SQL tengan la codificación correcta (UTF-8 sin BOM).

3. Asegúrate de que los permisos de los archivos sean correctos.

### Error al conectar desde la aplicación

1. Verifica que las credenciales en el archivo `.env` coincidan con las configuradas en `docker-compose.yml`.
2. Asegúrate de que la red de Docker esté configurada correctamente.
3. Verifica que el contenedor de la base de datos esté en ejecución:
   ```bash
   docker-compose ps
   ```
