#!/bin/bash

echo "🔧 Configurando entorno de desarrollo..."

# Verificar que estamos en el directorio correcto
if [ ! -d "/workspace/client" ] || [ ! -d "/workspace/server" ]; then
    echo "❌ Error: No se encontraron los directorios client o server"
    exit 1
fi

# Verificar que los servicios estén funcionando
echo "🔍 Verificando servicios..."
echo "- Frontend (Vue.js): http://localhost:5173"
echo "- Backend (FastAPI): http://localhost:8000"
echo "- Base de datos (MariaDB): localhost:3306"

# Crear un archivo de ayuda
cat > /workspace/DEV_HELP.md << 'EOF'
# 🚀 Guía de Desarrollo

## Servicios Disponibles
- **Frontend**: http://localhost:5173 (Vue.js + Vite)
- **Backend**: http://localhost:8000 (FastAPI)
- **Base de datos**: localhost:3306 (MariaDB)

## Comandos Útiles

### Frontend (desde /workspace/client)
```bash
npm run dev          # Iniciar servidor de desarrollo
npm run build        # Construir para producción
npm run test:unit    # Ejecutar tests unitarios
npm run test:e2e     # Ejecutar tests end-to-end
```

### Backend (desde /workspace/server)
```bash
uvicorn main:app --reload --host 0.0.0.0 --port 8000
```

### Base de datos
```bash
# Conectar a MariaDB
mysql -h localhost -P 3306 -u root -p
```

## Estructura del Proyecto
```
/workspace/
├── client/          # Frontend Vue.js
├── server/          # Backend FastAPI
├── database/        # Scripts de base de datos
└── .devcontainer/   # Configuración del contenedor
```

## Variables de Entorno
Asegúrate de tener un archivo `.env.dev` en la raíz del proyecto con las variables necesarias.

## Docker Compose
El proyecto usa `docker-compose.dev.yml` para orquestar todos los servicios:
- `web`: Servicio del frontend (Vue.js)
- `api`: Servicio del backend (FastAPI)
- `db`: Servicio de base de datos (MariaDB)

## Comandos Docker útiles
```bash
# Ver logs de todos los servicios
docker-compose -f docker-compose.dev.yml logs

# Ver logs de un servicio específico
docker-compose -f docker-compose.dev.yml logs web
docker-compose -f docker-compose.dev.yml logs api
docker-compose -f docker-compose.dev.yml logs db

# Reiniciar un servicio
docker-compose -f docker-compose.dev.yml restart web
docker-compose -f docker-compose.dev.yml restart api

# Detener todos los servicios
docker-compose -f docker-compose.dev.yml down

# Reconstruir y reiniciar
docker-compose -f docker-compose.dev.yml up --build
```
EOF

echo "✅ Entorno de desarrollo configurado correctamente!"
echo "📖 Revisa DEV_HELP.md para más información"
echo ""
echo "🎯 Próximos pasos:"
echo "1. Abre http://localhost:5173 para el frontend"
echo "2. Abre http://localhost:8000/docs para la API"
echo "3. ¡Comienza a desarrollar!"
echo ""
echo "💡 Tip: Usa Ctrl+Shift+P y busca 'Tasks: Run Task' para ejecutar comandos comunes" 