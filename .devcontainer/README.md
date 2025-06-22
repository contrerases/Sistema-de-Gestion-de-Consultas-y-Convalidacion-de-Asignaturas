# 🐳 Contenedor de Desarrollo - Sistema de Gestión

Este directorio contiene la configuración del contenedor de desarrollo para el Sistema de Gestión de Consultas y Convalidación de Asignaturas.

## 🚀 Cómo usar

### Prerrequisitos
- [Docker Desktop](https://www.docker.com/products/docker-desktop/) instalado y ejecutándose
- [VS Code](https://code.visualstudio.com/) con la extensión [Dev Containers](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers)

### ⚠️ Configuración Inicial Importante

**Antes de usar el devcontainer, necesitas crear el archivo `.env.dev`:**

1. **Copia el archivo de ejemplo:**
   ```bash
   cp env.dev.example .env.dev
   ```

2. **Edita el archivo `.env.dev`** y ajusta las variables según tus necesidades:
   ```env
   # Frontend Configuration
   FRONTEND_PORT=5173
   VITE_API_BASE_URL=http://localhost:8000

   # Backend Configuration
   BACKEND_PORT=8000
   ALLOWED_ORIGINS=http://localhost:5173

   # Database Configuration
   DB_HOST=db
   DB_PORT=3306
   DB_NAME=sgc_database
   DB_USER=sgc_user
   DB_USER_PASSWORD=sgc_password_2024
   DB_ROOT_PASSWORD=root_password_2024
   ```

### Pasos para iniciar

1. **Abrir el proyecto en VS Code**
   ```bash
   code .
   ```

2. **Abrir en contenedor de desarrollo**
   - Presiona `Ctrl+Shift+P` (Windows/Linux) o `Cmd+Shift+P` (Mac)
   - Busca y selecciona: `Dev Containers: Reopen in Container`
   - VS Code usará tu `docker-compose.dev.yml` existente y abrirá el proyecto dentro del contenedor

3. **Esperar a que se complete la configuración**
   - El contenedor se construirá automáticamente usando tu configuración existente
   - Se configurarán las extensiones de VS Code
   - Se creará un archivo `DEV_HELP.md` con información útil

## 🏗️ Estructura del Contenedor

```
.devcontainer/
├── devcontainer.json      # Configuración principal del contenedor
├── post-create.sh         # Script de post-creación
├── launch.json           # Configuración de debugging
├── tasks.json            # Tareas de VS Code
└── README.md             # Este archivo
```

## 🔧 Servicios Incluidos

El devcontainer utiliza tu configuración existente en `docker-compose.dev.yml`:

### Frontend (Vue.js)
- **Puerto**: 5173
- **URL**: http://localhost:5173
- **Tecnologías**: Vue 3, TypeScript, Vite, Tailwind CSS

### Backend (FastAPI)
- **Puerto**: 8000
- **URL**: http://localhost:8000
- **Documentación API**: http://localhost:8000/docs
- **Tecnologías**: Python 3.9, FastAPI, MariaDB

### Base de Datos (MariaDB)
- **Puerto**: 3306
- **Tecnologías**: MariaDB 10.11

## 🛠️ Extensiones Incluidas

### Frontend
- Vue Language Features (Volar)
- TypeScript Vue Plugin
- Tailwind CSS IntelliSense
- Auto Rename Tag

### Backend
- Python
- Black Formatter
- Flake8

### Herramientas Generales
- Docker
- GitLens
- Prettier
- Error Lens
- Material Icon Theme

## 📝 Comandos Útiles

### Desde el terminal del contenedor

#### Frontend
```bash
cd /workspace/client
npm run dev          # Iniciar servidor de desarrollo
npm run build        # Construir para producción
npm run test:unit    # Ejecutar tests unitarios
npm run test:e2e     # Ejecutar tests end-to-end
```

#### Backend
```bash
cd /workspace/server
uvicorn main:app --reload --host 0.0.0.0 --port 8000
```

#### Base de Datos
```bash
# Conectar a MariaDB
mysql -h localhost -P 3306 -u root -p
```

### Usando las tareas de VS Code
- `Ctrl+Shift+P` → `Tasks: Run Task`
- Selecciona la tarea que necesites:
  - Start Frontend Dev Server
  - Start Backend Dev Server
  - Install Frontend Dependencies
  - Install Backend Dependencies
  - Build Frontend
  - Run Frontend Tests
  - Connect to Database

## 🔄 Variables de Entorno

El devcontainer usa tu archivo `.env.dev` existente. Asegúrate de que contenga las variables necesarias:

```env
# Frontend
FRONTEND_PORT=5173
VITE_API_BASE_URL=http://localhost:8000

# Backend
BACKEND_PORT=8000
ALLOWED_ORIGINS=http://localhost:5173

# Database
DB_HOST=db
DB_PORT=3306
DB_NAME=sgc_database
DB_USER=sgc_user
DB_USER_PASSWORD=sgc_password_2024
DB_ROOT_PASSWORD=root_password_2024
```

## 🐛 Solución de Problemas

### Error: "Command failed: docker compose -f ... config"
**Causa**: Falta el archivo `.env.dev`
**Solución**: 
1. Copia `env.dev.example` a `.env.dev`
2. Edita las variables según tus necesidades
3. Intenta abrir el devcontainer nuevamente

### El contenedor no se inicia
1. Verifica que Docker Desktop esté ejecutándose
2. Asegúrate de tener el archivo `.env.dev` configurado
3. Revisa los logs: `docker-compose -f docker-compose.dev.yml logs`

### Los puertos no están disponibles
1. Verifica que los puertos 5173, 8000 y 3306 no estén en uso
2. Puedes cambiar los puertos en el archivo `.env.dev`

### Problemas con el docker-compose existente
1. El devcontainer usa tu `docker-compose.dev.yml` existente
2. Si tienes problemas, verifica que tu configuración funcione: `docker-compose -f docker-compose.dev.yml up`
3. Reconstruye el contenedor: `Dev Containers: Rebuild Container`

## 🎯 Ventajas de usar tu configuración existente

- ✅ **Consistencia**: Usa la misma configuración que ya tienes funcionando
- ✅ **Simplicidad**: No necesitas mantener configuraciones duplicadas
- ✅ **Familiaridad**: Trabajas con la configuración que ya conoces
- ✅ **Mantenimiento**: Solo necesitas mantener una configuración

## 📚 Recursos Adicionales

- [Documentación de Dev Containers](https://containers.dev/)
- [Vue.js Documentation](https://vuejs.org/)
- [FastAPI Documentation](https://fastapi.tiangolo.com/)
- [MariaDB Documentation](https://mariadb.org/documentation/)

## 🤝 Contribución

Si encuentras algún problema o tienes sugerencias para mejorar el contenedor de desarrollo, por favor:

1. Revisa los issues existentes
2. Crea un nuevo issue con detalles del problema
3. Proporciona logs y pasos para reproducir el problema 