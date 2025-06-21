@echo off
echo ========================================
echo INICIANDO ENTORNO DE PRODUCCIÓN
echo ========================================

REM Verificar que existe el archivo de entorno
if not exist ".env.prod" (
    echo ERROR: No se encontró .env.prod
    echo.
    pause
    exit /b 1
)

echo Usando configuración: .env.prod
echo Usando Docker Compose: docker-compose.prod.yml
echo.

REM Iniciar servicios con el archivo de entorno específico y docker-compose de producción
docker-compose --env-file .env.prod -f docker-compose.prod.yml up -d

echo.
echo Entorno de producción iniciado!
echo Frontend: http://localhost:80
echo Backend: http://localhost:8000
echo.
pause 