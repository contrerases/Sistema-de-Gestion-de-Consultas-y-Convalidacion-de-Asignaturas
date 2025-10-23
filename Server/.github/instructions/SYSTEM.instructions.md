---
applyTo: '**'
---
# Análisis técnico detallado del proyecto SGSCT

## 1. Estructura de Carpetas y Archivos

- **Raíz `/app`**
  - `Dockerfile.dev`, `Dockerfile.prod`: Configuración para entornos de desarrollo y producción usando Docker.
  - `.env`, `.env.example`, `.env.prod`: Variables de entorno para configuración sensible (DB, JWT, rutas de archivos, etc.).
  - `requirements.txt`, `requirements.dev.txt`: Dependencias de Python, separando las de producción y desarrollo.
  - `main.py`: Punto de entrada de la aplicación FastAPI.
  - `endpoints.md`: Documentación de los endpoints expuestos por la API.
  - `files/`: Carpeta para almacenamiento de archivos subidos (talleres, convalidaciones, proyectos personales, etc.).

- **`src/`**
  - **`api/`**: Routers de la API, agrupados por versión (`v1/`), cada uno importando routers de módulos funcionales.
  - **`app/`**: Configuración global, settings, inicialización de la app.
  - **`core/`**: Funciones centrales como configuración de archivos, constantes, utilidades.
  - **`database/`**: Conexión a la base de datos, modelos ORM, registro de modelos, base para SQLAlchemy.
  - **`middleware/`**: Middlewares personalizados (CORS, seguridad, logging, rate limit, manejo de errores).
  - **`modules/`**: Módulos funcionales, cada uno con su propia lógica, modelos, routers y servicios:
    - `users/`: Gestión de usuarios.
    - `auth/`: Autenticación y autorización (JWT, hashing).
    - `workshops/`: Gestión de talleres.
    - `convalidations/`: Solicitudes y gestión de convalidaciones.
    - Otros módulos según necesidades del sistema.
  - **`monitoring/`**: Endpoints y utilidades para monitoreo, logging y health checks.

- **`tests/`**
  - Pruebas unitarias y de integración, organizadas por módulo, con fixtures y mocks.

---

## 2. Configuración y Seguridad

- **Variables de entorno**: Centralizadas en archivos `.env`, gestionadas por la clase `Settings` (Pydantic), permiten configurar DB, JWT, CORS, rutas de archivos, límites de tamaño, etc.
- **Docker**: Dos Dockerfiles para desarrollo y producción, instalan dependencias del sistema y Python, configuran workers y estructura de archivos.
- **Seguridad**:
  - JWT para autenticación.
  - Hashing de contraseñas.
  - Middlewares para headers de seguridad HTTP.
  - Rate limiting por IP configurable.
  - CORS dinámico según configuración.

---

## 3. Base de Datos

- **ORM**: SQLAlchemy, conexión a MariaDB.
- **Modelos**: Centralizados y registrados para evitar imports circulares.
- **Migración**: Creación automática de tablas si no existen.
- **Relaciones**: Uso de claves foráneas y relaciones ORM para integridad referencial.

---

## 4. Middlewares

- **CORS**: Permite orígenes configurables.
- **Seguridad**: Headers para prevenir XSS, clickjacking, etc.
- **Rate Limiting**: Control de requests por IP.
- **Logging**: Registro de requests/responses con correlación por request ID.
- **Error Handling**: Captura y estandarización de errores.

---

## 5. Gestión de Archivos

- **Directorio `files/`**: Estructura para almacenamiento de archivos por tipo (talleres, convalidaciones, proyectos personales).
- **Configuración dinámica**: Creación de carpetas y verificación al iniciar la app.
- **Extensiones y límites**: Configurables desde settings.

---

## 6. API y Documentación

- **Router principal**: Agrupa routers de cada módulo funcional.
- **Documentación automática**: OpenAPI y ReDoc disponibles en rutas configuradas.
- **Endpoints de salud**: Verifican estado general y conexión a la base de datos.

---

## 7. Pruebas

- **tests/**: Pruebas unitarias y de integración, con fixtures y mocks para cada módulo.
- **Cobertura**: Se espera cobertura de modelos, routers, servicios y middlewares.

---

## 8. Despliegue y Escalabilidad

- **Docker**: Preparado para Railway y otros entornos Docker.
- **Workers**: Configuración para múltiples workers en producción.
- **Configuración modular**: Permite agregar nuevos módulos y funcionalidades fácilmente.

---

## 9. Buenas Prácticas

- **Modularidad**: Separación clara por responsabilidad.
- **Tipado**: Uso de Pydantic y SQLAlchemy para tipado y validación.
- **Seguridad**: JWT, hashing, headers, rate limiting.
- **Configuración**: Centralizada y flexible.
- **Pruebas**: Estructura clara y cobertura esperada.

---

### Resumen Específico

El proyecto está diseñado para ser robusto, seguro y escalable. La estructura modular facilita la mantenibilidad y la extensión. La configuración centralizada y el uso de Docker permiten despliegues consistentes. Los middlewares y la gestión de archivos aseguran seguridad y eficiencia. La base de datos está bien integrada y los modelos siguen buenas prácticas de diseño ORM. La documentación y las pruebas aseguran calidad y facilidad de uso para desarrolladores y usuarios finales.