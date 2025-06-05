@echo off
echo Asegurando permisos para el script de inicializacion...

:: En Windows, no podemos establecer permisos de ejecucion directamente, 
:: pero podemos asegurarnos de que el script se ejecute correctamente

:: Verificar si Docker esta en ejecucion
docker info >nul 2>&1
if %errorlevel% neq 0 (
    echo Error: Docker no esta en ejecucion. Por favor, inicia Docker Desktop e intentalo de nuevo.
    pause
    exit /b 1
)

echo Script de inicializacion listo para ejecutarse cuando se inicie el contenedor de la base de datos.
echo Asegurate de que el script 00_init_database.sh tenga permisos de ejecucion en el contenedor.

exit /b 0
