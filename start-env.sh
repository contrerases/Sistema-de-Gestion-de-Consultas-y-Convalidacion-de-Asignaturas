#!/bin/bash

# ========================================
# SISTEMA DE GESTIÓN DE CONSULTAS
# SCRIPT UNIFICADO DE AMBIENTES (BASH)
# ========================================
#
# DESCRIPCIÓN:
# Este script unifica la gestión de todos los ambientes del proyecto:
# - Desarrollo (dev): Para desarrollo local con hot-reload
# - Producción (prod): Para despliegue en servidor
# - Testing (test): Para pruebas automatizadas
#
# REQUISITOS:
# - Docker Desktop instalado y ejecutándose
# - Docker Compose instalado
# - Archivos .env.dev, .env.prod, .env.test en la raíz del proyecto
#
# ESTRUCTURA DE ARCHIVOS REQUERIDA:
# ├── .env.dev          (variables de desarrollo)
# ├── .env.prod         (variables de producción)
# ├── .env.test         (variables de testing)
# ├── docker-compose.dev.yml
# ├── docker-compose.prod.yml
# ├── client/           (frontend Vue.js)
# ├── server/           (backend Python)
# └── database/         (scripts SQL)
#
# PUERTOS POR AMBIENTE:
# - Desarrollo:  Frontend:5173, Backend:8000, DB:3306
# - Producción:  Frontend:80,   Backend:8000, DB:3306
# - Testing:     Frontend:5174, Backend:8001, DB:3307
#
# AUTOR: Sistema de Gestión de Consultas
# FECHA: 2024
# ========================================

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Función para imprimir mensajes con colores
print_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Verificar que se proporcione el ambiente
if [ -z "$1" ]; then
    print_error "Debes especificar el ambiente"
    echo
    echo "Uso: ./start-env.sh [ambiente] [comando] [servicio]"
    echo
    echo "Ambientes: dev, prod, test"
    echo "Comandos: up, down, build"
    echo "Servicios: web, api, db (solo para logs en dev/test)"
    echo
    exit 1
fi

# Verificar que Docker esté instalado
if ! command -v docker &> /dev/null; then
    print_error "Docker no está instalado o no está en el PATH"
    echo "Instala Docker Desktop desde: https://www.docker.com/products/docker-desktop/"
    exit 1
fi

# Verificar que Docker Desktop esté ejecutándose
if ! docker info &> /dev/null; then
    print_error "Docker Desktop no está ejecutándose"
    echo "Por favor, abre Docker Desktop y espera a que se inicie completamente"
    echo "El ícono de Docker debe estar verde en la bandeja del sistema"
    exit 1
fi

# Configurar variables según el ambiente
case "$1" in
    "dev")
        ENV_FILE=".env.dev"
        COMPOSE_FILE="docker-compose.dev.yml"
        ENV_NAME="DESARROLLO"
        FRONTEND_PORT="5173"
        BACKEND_PORT="8000"
        DB_PORT="3306"
        SHOW_LOGS=true
        ;;
    "prod")
        ENV_FILE=".env.prod"
        COMPOSE_FILE="docker-compose.prod.yml"
        ENV_NAME="PRODUCCIÓN"
        FRONTEND_PORT="80"
        BACKEND_PORT="8000"
        DB_PORT="3306"
        SHOW_LOGS=false
        ;;
    "test")
        ENV_FILE=".env.test"
        COMPOSE_FILE="docker-compose.dev.yml"
        ENV_NAME="TESTING"
        FRONTEND_PORT="5174"
        BACKEND_PORT="8001"
        DB_PORT="3307"
        SHOW_LOGS=true
        ;;
    *)
        print_error "Ambiente no válido. Usa: dev, prod o test"
        exit 1
        ;;
esac

# Verificar que existe el archivo de entorno
if [ ! -f "$ENV_FILE" ]; then
    print_error "No se encontró $ENV_FILE"
    exit 1
fi

# Verificar que existe el archivo docker-compose
if [ ! -f "$COMPOSE_FILE" ]; then
    print_error "No se encontró $COMPOSE_FILE"
    exit 1
fi

echo "========================================"
print_info "AMBIENTE: $ENV_NAME"
echo "========================================"
print_info "Configuración: $ENV_FILE"
print_info "Docker Compose: $COMPOSE_FILE"
echo

# Procesar comandos
case "$2" in
    "down")
        print_info "DETENIENDO CONTENEDORES..."
        if docker compose --env-file "$ENV_FILE" -f "$COMPOSE_FILE" down; then
            print_success "Contenedores detenidos!"
        else
            print_error "No se pudieron detener los contenedores"
            exit 1
        fi
        ;;
    "build")
        print_info "CONSTRUYENDO IMÁGENES..."
        if docker compose --env-file "$ENV_FILE" -f "$COMPOSE_FILE" build; then
            print_success "Imágenes construidas!"
        else
            print_error "No se pudieron construir las imágenes"
            exit 1
        fi
        ;;
    "up")
        print_info "LEVANTANDO TODOS LOS SERVICIOS..."
        if docker compose --env-file "$ENV_FILE" -f "$COMPOSE_FILE" up -d; then
            echo
            print_success "Entorno iniciado!"
            print_info "Frontend: http://localhost:$FRONTEND_PORT"
            print_info "Backend: http://localhost:$BACKEND_PORT"
            print_info "Database: localhost:$DB_PORT"
            echo
            
            # Mostrar logs solo si está habilitado y se especificó un servicio
            if [ "$SHOW_LOGS" = true ]; then
                case "$3" in
                    "web")
                        print_info "Mostrando logs del frontend..."
                        docker compose --env-file "$ENV_FILE" -f "$COMPOSE_FILE" logs -f web
                        ;;
                    "api")
                        print_info "Mostrando logs del backend..."
                        docker compose --env-file "$ENV_FILE" -f "$COMPOSE_FILE" logs -f api
                        ;;
                    "db")
                        print_info "Mostrando logs de la base de datos..."
                        docker compose --env-file "$ENV_FILE" -f "$COMPOSE_FILE" logs -f db
                        ;;
                    *)
                        if [ -n "$3" ]; then
                            print_info "Mostrando logs de todos los servicios..."
                            docker compose --env-file "$ENV_FILE" -f "$COMPOSE_FILE" logs -f
                        fi
                        ;;
                esac
            fi
        else
            print_error "No se pudieron levantar los servicios"
            print_info "Verifica que los puertos no estén en uso y que Docker esté ejecutándose"
            exit 1
        fi
        ;;
    *)
        echo "Uso: ./start-env.sh $1 [comando] [servicio]"
        echo
        echo "Comandos: up, down, build"
        echo "Servicios: web, api, db (solo para logs en dev/test)"
        echo
        ;;
esac 