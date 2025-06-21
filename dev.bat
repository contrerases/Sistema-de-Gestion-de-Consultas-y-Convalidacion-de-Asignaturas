@echo off
cls
echo ========================================
echo INICIANDO ENTORNO DE DESARROLLO
echo ========================================

REM Verificar que existe el archivo de entorno
if not exist ".env.dev" (
    echo ERROR: No se encontró .env.dev
    echo.
    pause
    exit /b 1
)

echo Usando configuración: .env.dev
echo Usando Docker Compose: docker-compose.dev.yml
echo.

REM Iniciar servicios con el archivo de entorno específico y docker-compose de desarrollo
docker-compose --env-file .env.dev -f docker-compose.dev.yml up -d

echo.
echo Entorno de desarrollo iniciado!
echo Frontend: http://localhost:5173
echo Backend: http://localhost:8000
echo.

REM Mostrar logs según el parámetro recibido
if "%1"=="web" (
    docker-compose --env-file .env.dev -f docker-compose.dev.yml logs -f web
) else if "%1"=="api" (
    docker-compose --env-file .env.dev -f docker-compose.dev.yml logs -f api
) else if "%1"=="db" (
    docker-compose --env-file .env.dev -f docker-compose.dev.yml logs -f db
) else (
    docker-compose --env-file .env.dev -f docker-compose.dev.yml logs -f
)

pause 