@echo off
cls

REM ========================================
REM SISTEMA DE GESTIÓN DE CONSULTAS
REM SCRIPT UNIFICADO DE AMBIENTES
REM ========================================
REM
REM DESCRIPCIÓN:
REM Este script unifica la gestión de todos los ambientes del proyecto:
REM - Desarrollo (dev): Para desarrollo local con hot-reload
REM - Producción (prod): Para despliegue en servidor
REM - Testing (test): Para pruebas automatizadas
REM
REM REQUISITOS:
REM - Docker Desktop instalado y ejecutándose
REM - Docker Compose instalado
REM - Archivos .env.dev, .env.prod, .env.test en la raíz del proyecto
REM
REM ESTRUCTURA DE ARCHIVOS REQUERIDA:
REM ├── .env.dev          (variables de desarrollo)
REM ├── .env.prod         (variables de producción)
REM ├── .env.test         (variables de testing)
REM ├── docker-compose.dev.yml
REM ├── docker-compose.prod.yml
REM ├── client/           (frontend Vue.js)
REM ├── server/           (backend Python)
REM └── database/         (scripts SQL)
REM
REM PUERTOS POR AMBIENTE:
REM - Desarrollo:  Frontend:5173, Backend:8000, DB:3306
REM - Producción:  Frontend:80,   Backend:8000, DB:3306
REM - Testing:     Frontend:5174, Backend:8001, DB:3307
REM
REM AUTOR: Sistema de Gestión de Consultas
REM FECHA: 2024
REM ========================================

REM Verificar que se proporcione el ambiente
if "%1"=="" (
    echo ERROR: Debes especificar el ambiente
    echo.
    echo Uso: env.bat [ambiente] [comando] [servicio]
    echo.
    echo Ambientes: dev, prod, test
    echo Comandos: up, down, build
    echo Servicios: web, api, db (solo para logs en dev/test)
    echo.
    pause
    exit /b 1
)

REM Configurar variables según el ambiente
if "%1"=="dev" (
    set ENV_FILE=.env.dev
    set COMPOSE_FILE=docker-compose.dev.yml
    set ENV_NAME=DESARROLLO
    set FRONTEND_PORT=5173
    set BACKEND_PORT=8000
    set DB_PORT=3306
    set SHOW_LOGS=true
) else if "%1"=="prod" (
    set ENV_FILE=.env.prod
    set COMPOSE_FILE=docker-compose.prod.yml
    set ENV_NAME=PRODUCCIÓN
    set FRONTEND_PORT=80
    set BACKEND_PORT=8000
    set DB_PORT=3306
    set SHOW_LOGS=false
) else if "%1"=="test" (
    set ENV_FILE=.env.test
    set COMPOSE_FILE=docker-compose.dev.yml
    set ENV_NAME=TESTING
    set FRONTEND_PORT=5174
    set BACKEND_PORT=8001
    set DB_PORT=3307
    set SHOW_LOGS=true
) else (
    echo ERROR: Ambiente no válido. Usa: dev, prod o test
    pause
    exit /b 1
)

REM Verificar que existe el archivo de entorno
if not exist "%ENV_FILE%" (
    echo ERROR: No se encontró %ENV_FILE%
    pause
    exit /b 1
)

echo ========================================
echo AMBIENTE: %ENV_NAME%
echo ========================================
echo Configuración: %ENV_FILE%
echo Docker Compose: %COMPOSE_FILE%
echo.

REM Procesar comandos
if "%2"=="down" (
    echo DETENIENDO CONTENEDORES...
    docker-compose --env-file %ENV_FILE% -f %COMPOSE_FILE% down
    echo Contenedores detenidos!
    
) else if "%2"=="build" (
    echo CONSTRUYENDO IMÁGENES...
    docker-compose --env-file %ENV_FILE% -f %COMPOSE_FILE% build
    echo Imágenes construidas!
    
) else if "%2"=="up" (
    echo LEVANTANDO TODOS LOS SERVICIOS...
    docker-compose --env-file %ENV_FILE% -f %COMPOSE_FILE% up -d
    echo.
    echo Entorno iniciado!
    echo Frontend: http://localhost:%FRONTEND_PORT%
    echo Backend: http://localhost:%BACKEND_PORT%
    echo Database: localhost:%DB_PORT%
    echo.
    
    REM Mostrar logs solo si está habilitado y se especificó un servicio
    if "%SHOW_LOGS%"=="true" (
        if "%3"=="web" (
            echo Mostrando logs del frontend...
            docker-compose --env-file %ENV_FILE% -f %COMPOSE_FILE% logs -f web
        ) else if "%3"=="api" (
            echo Mostrando logs del backend...
            docker-compose --env-file %ENV_FILE% -f %COMPOSE_FILE% logs -f api
        ) else if "%3"=="db" (
            echo Mostrando logs de la base de datos...
            docker-compose --env-file %ENV_FILE% -f %COMPOSE_FILE% logs -f db
        ) else if not "%3"=="" (
            echo Mostrando logs de todos los servicios...
            docker-compose --env-file %ENV_FILE% -f %COMPOSE_FILE% logs -f
        )
    )
    
) else (
    echo Uso: env.bat %1 [comando] [servicio]
    echo.
    echo Comandos: up, down, build
    echo Servicios: web, api, db (solo para logs en dev/test)
    echo.
)

pause 