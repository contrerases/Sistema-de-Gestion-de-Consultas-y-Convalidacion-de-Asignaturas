@echo off
echo ========================================
echo SELECTOR DE ENTORNO
echo ========================================

if "%1"=="dev" (
    echo Iniciando entorno de DESARROLLO...
    docker-compose --env-file .env.dev -f docker-compose.dev.yml up -d
    echo.
    echo Entorno de desarrollo iniciado!
    echo Frontend: http://localhost:5173
    echo Backend: http://localhost:8000
) else if "%1"=="prod" (
    echo Iniciando entorno de PRODUCCIÓN...
    docker-compose --env-file .env.prod -f docker-compose.prod.yml up -d
    echo.
    echo Entorno de producción iniciado!
    echo Frontend: http://localhost:80
    echo Backend: http://localhost:8000
) else if "%1"=="test" (
    echo Iniciando entorno de TESTING...
    docker-compose --env-file .env.test -f docker-compose.dev.yml up -d
    echo.
    echo Entorno de testing iniciado!
    echo Frontend: http://localhost:5174
    echo Backend: http://localhost:8001
) else (
    echo Uso: start-env.bat [dev^|prod^|test]
    echo.
    echo Ejemplos:
    echo   start-env.bat dev   - Inicia entorno de desarrollo
    echo   start-env.bat prod  - Inicia entorno de producción
    echo   start-env.bat test  - Inicia entorno de testing
    echo.
    echo Archivos de entorno disponibles:
    echo   .env.dev      - Configuración de desarrollo
    echo   .env.prod     - Configuración de producción
    echo   .env.test     - Configuración de testing
    echo.
    echo Archivos Docker Compose:
    echo   docker-compose.dev.yml  - Para desarrollo (con hot reload)
    echo   docker-compose.prod.yml - Para producción (optimizado)
)

echo.
pause 