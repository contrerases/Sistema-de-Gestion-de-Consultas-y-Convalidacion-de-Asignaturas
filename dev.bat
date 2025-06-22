@echo off
cls

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

REM Procesar comandos según el parámetro recibido
if "%1"=="down" (
    echo ========================================
    echo DETENIENDO Y REMOVIENDO CONTENEDORES
    echo ========================================
    docker-compose --env-file .env.dev -f docker-compose.dev.yml down
    echo.
    echo Contenedores detenidos y removidos exitosamente!
    
) else if "%1"=="build" (
    echo ========================================
    echo CONSTRUYENDO IMÁGENES
    echo ========================================
    docker-compose --env-file .env.dev -f docker-compose.dev.yml build
    echo.
    echo Imágenes construidas exitosamente!
    
) else if "%1"=="up" (
    if "%2"=="web" (
        echo ========================================
        echo LEVANTANDO SERVICIO WEB CON LOGS
        echo ========================================
        docker-compose --env-file .env.dev -f docker-compose.dev.yml up -d
        echo.
        echo Servicio web iniciado!
        echo Frontend: http://localhost:5173
        echo.
        docker-compose --env-file .env.dev -f docker-compose.dev.yml logs -f web
        
    ) else if "%2"=="api" (
        echo ========================================
        echo LEVANTANDO SERVICIO API CON LOGS
        echo ========================================
        docker-compose --env-file .env.dev -f docker-compose.dev.yml up -d
        echo.
        echo Servicio API iniciado!
        echo Backend: http://localhost:8000
        echo.
        docker-compose --env-file .env.dev -f docker-compose.dev.yml logs -f api
        
    ) else if "%2"=="db" (
        echo ========================================
        echo LEVANTANDO SERVICIO DATABASE CON LOGS
        echo ========================================
        docker-compose --env-file .env.dev -f docker-compose.dev.yml up -d
        echo.
        echo Servicio Database iniciado!
        echo Database: localhost:3306
        echo.
        docker-compose --env-file .env.dev -f docker-compose.dev.yml logs -f db
        
    ) else (
        echo ========================================
        echo LEVANTANDO TODOS LOS SERVICIOS CON LOGS
        echo ========================================
        docker-compose --env-file .env.dev -f docker-compose.dev.yml up -d
        echo.
        echo Entorno de desarrollo iniciado!
        echo Frontend: http://localhost:5173
        echo Backend: http://localhost:8000
        echo Database: localhost:3306
        echo.
        docker-compose --env-file .env.dev -f docker-compose.dev.yml logs -f
    )
    
) else (
    echo ========================================
    echo SISTEMA DE GESTIÓN DE CONSULTAS
    echo ========================================
    echo.
    echo Uso: dev.bat [comando] [servicio]
    echo.
    echo Comandos disponibles:
    echo   down                    - Detiene y remueve todos los contenedores
    echo   build                   - Construye las imágenes Docker
    echo   up [web^|api^|db]       - Levanta servicios con logs
    echo.
    echo Ejemplos:
    echo   dev.bat down            - Detiene y remueve contenedores
    echo   dev.bat build           - Construye imágenes
    echo   dev.bat up              - Levanta todos los servicios con logs
    echo   dev.bat up web          - Levanta solo el frontend con logs
    echo   dev.bat up api          - Levanta solo el backend con logs
    echo   dev.bat up db           - Levanta solo la base de datos con logs
    echo.
)

pause 