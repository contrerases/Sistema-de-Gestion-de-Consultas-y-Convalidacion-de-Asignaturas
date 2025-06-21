@echo off
echo ========================================
echo INICIANDO ENTORNO DE TESTING
echo ========================================

REM Verificar que existe el archivo de entorno
if not exist ".env.test" (
    echo ERROR: No se encontró .env.test
    echo.
    pause
    exit /b 1
)

echo Usando configuración: .env.test
echo.

REM Iniciar servicios con el archivo de entorno específico
docker-compose --env-file .env.test -f docker-compose.dev.yml up -d

echo.
echo Entorno de testing iniciado!
echo Frontend: http://localhost:5174
echo Backend: http://localhost:8001
echo.
pause 