# API REST SGSCT - Rutas Completas

## 🔐 AUTENTICACIÓN

```http
POST   /api/auth/login
POST   /api/auth/logout
POST   /api/auth/change-password
POST   /api/auth/reset-password
GET    /api/auth/me
```

## 👨‍🎓 ESTUDIANTES

### Gestión de Estudiantes (Admin)
```http
GET    /api/students                    # Listar todos los estudiantes
GET    /api/students/{id}               # Obtener estudiante por ID
GET    /api/students/search/rut/{rut}   # Buscar por RUT
GET    /api/students/search/rol/{rol}   # Buscar por ROL
GET    /api/students/search/name        # Buscar por nombre (query param: name)
POST   /api/students                    # Crear estudiante
PUT    /api/students/{id}               # Actualizar estudiante
DELETE /api/students/{id}               # Eliminar estudiante
POST   /api/students/bulk               # Crear estudiantes masivamente (Excel)
```

### Perfil del Estudiante
```http
GET    /api/students/profile            # Perfil del estudiante logueado
PUT    /api/students/profile            # Actualizar perfil
GET    /api/students/progress           # Progreso académico
```

## 👨‍💼 ADMINISTRADORES

```http
GET    /api/administrators              # Listar administradores
GET    /api/administrators/{id}         # Obtener administrador por ID
POST   /api/administrators              # Crear administrador
PUT    /api/administrators/{id}         # Actualizar administrador
DELETE /api/administrators/{id}         # Eliminar administrador
```

## 🏛️ DEPARTAMENTOS

```http
GET    /api/departments                 # Listar departamentos
GET    /api/departments/{id}            # Obtener departamento por ID
POST   /api/departments                 # Crear departamento
PUT    /api/departments/{id}            # Actualizar departamento
DELETE /api/departments/{id}            # Eliminar departamento
POST   /api/departments/bulk            # Crear departamentos masivamente
```

## 📚 ASIGNATURAS

```http
GET    /api/subjects                    # Listar asignaturas
GET    /api/subjects/{id}               # Obtener asignatura por ID
GET    /api/subjects/department/{id}    # Asignaturas por departamento
POST   /api/subjects                    # Crear asignatura
PUT    /api/subjects/{id}               # Actualizar asignatura
DELETE /api/subjects/{id}               # Eliminar asignatura
POST   /api/subjects/bulk               # Crear asignaturas masivamente
```

## 🎯 CASILLAS CURRICULARES (CURRICULUM COURSE SLOTS)

```http
GET    /api/curriculum-course-slots          # Listar casillas curriculares
GET    /api/curriculum-course-slots/{id}     # Obtener casilla por ID
GET    /api/curriculum-course-slots/types/{type} # Casillas por tipo
GET    /api/curriculum-course-slots/available/{studentId} # Casillas no convalidadas por estudiante
POST   /api/curriculum-course-slots          # Crear casilla curricular
PUT    /api/curriculum-course-slots/{id}     # Actualizar casilla curricular
DELETE /api/curriculum-course-slots/{id}     # Eliminar casilla curricular
POST   /api/curriculum-course-slots/bulk     # Crear casillas masivamente
```

## 🎨 TALLERES

### Gestión de Talleres
```http
GET    /api/workshops                   # Listar talleres
GET    /api/workshops/{id}              # Obtener taller por ID
GET    /api/workshops/state/{state}     # Talleres por estado
GET    /api/workshops/available         # Talleres disponibles para inscripción
GET    /api/workshops/search            # Buscar talleres (query params)
POST   /api/workshops                   # Crear taller
PUT    /api/workshops/{id}              # Actualizar taller
DELETE /api/workshops/{id}              # Eliminar taller
PATCH  /api/workshops/{id}/state        # Cambiar estado del taller
```

### Inscripciones a Talleres
```http
GET    /api/workshops/{id}/inscriptions        # Inscripciones de un taller
GET    /api/workshops/inscriptions             # Todas las inscripciones
GET    /api/workshops/inscriptions/student/{id} # Inscripciones de un estudiante
POST   /api/workshops/{id}/inscriptions        # Inscribirse a taller
DELETE /api/workshops/inscriptions/{id}        # Cancelar inscripción
GET    /api/workshops/inscriptions/export/{workshopId} # Exportar lista (Excel)
```

### Calificaciones de Talleres
```http
GET    /api/workshops/{id}/grades              # Calificaciones de un taller
GET    /api/workshops/grades/student/{id}      # Calificaciones de un estudiante
POST   /api/workshops/{id}/grades              # Subir calificación individual
POST   /api/workshops/{id}/grades/bulk         # Subir calificaciones masivas
GET    /api/workshops/{id}/grades/export       # Exportar calificaciones (Excel)
```

## 📝 CONVALIDACIONES

### Solicitudes de Convalidación
```http
GET    /api/convalidations                     # Listar convalidaciones
GET    /api/convalidations/{id}                # Obtener convalidación por ID
GET    /api/convalidations/student/{id}        # Convalidaciones de un estudiante
GET    /api/convalidations/pending             # Convalidaciones pendientes
GET    /api/convalidations/search              # Búsqueda avanzada (query params)
POST   /api/convalidations                     # Crear convalidación
DELETE /api/convalidations/{id}                # Eliminar convalidación (solo no revisadas)
```

### Revisión de Convalidaciones (Admin)
```http
PATCH  /api/convalidations/{id}/review         # Revisar convalidación
GET    /api/convalidations/reviewed-by/{id}    # Convalidaciones revisadas por admin
```

### Archivos de Convalidaciones
```http
GET    /api/convalidations/{id}/file           # Descargar archivo adjunto
POST   /api/convalidations/{id}/file           # Subir archivo
```

## 📋 SOLICITUDES

```http
GET    /api/requests                           # Listar solicitudes
GET    /api/requests/{id}                      # Obtener solicitud por ID
GET    /api/requests/student/{id}              # Solicitudes de un estudiante
GET    /api/requests/{id}/convalidations       # Convalidaciones de una solicitud
```

## 👨‍🏫 PROFESORES

```http
GET    /api/professors                         # Listar profesores
GET    /api/professors/active                  # Profesores activos
POST   /api/professors                         # Crear profesor
PUT    /api/professors/{id}                    # Actualizar profesor
```

## 🔑 TOKENS DE TALLERES

```http
GET    /api/workshop-tokens                    # Tokens activos
GET    /api/workshop-tokens/expired            # Tokens expirados
POST   /api/workshop-tokens                    # Crear token
POST   /api/workshop-tokens/{token}/use        # Usar token
```

## 📊 ESTADÍSTICAS Y REPORTES

### Dashboard
```http
GET    /api/stats/general                      # Estadísticas generales
GET    /api/stats/dashboard                    # Dashboard completo
GET    /api/stats/convalidations               # Stats de convalidaciones
GET    /api/stats/workshops                    # Stats de talleres
GET    /api/stats/students                     # Stats de estudiantes
GET    /api/stats/activity                     # Actividad reciente
```

### Reportes y Exportaciones
```http
GET    /api/reports/workshops/{id}/de          # Informe para DE (Excel)
GET    /api/reports/students/export            # Exportar estudiantes (Excel)
GET    /api/reports/convalidations/export      # Exportar convalidaciones (Excel)
```

## 📖 CATÁLOGOS

```http
GET    /api/catalogs/convalidation-types       # Tipos de convalidación
GET    /api/catalogs/convalidation-states      # Estados de convalidación
GET    /api/catalogs/workshop-states           # Estados de talleres
GET    /api/catalogs/curriculum-course-types   # Tipos de cursos curriculares
```

---

## 🔧 PARÁMETROS DE QUERY COMUNES

### Paginación
- `page`: Número de página (default: 1)
- `limit`: Elementos por página (default: 10)
- `sort`: Campo de ordenamiento
- `order`: Dirección (asc/desc)

### Filtros
- `search`: Búsqueda de texto libre
- `state`: Filtrar por estado
- `campus`: Filtrar por campus
- `year`: Filtrar por año
- `semester`: Filtrar por semestre
- `dateFrom`: Fecha desde
- `dateTo`: Fecha hasta

### Respuestas
Todas las respuestas siguen el formato:
```json
{
  "success": true,
  "data": {},
  "message": "string",
  "errors": [],
  "pagination": {
    "page": 1,
    "limit": 10,
    "total": 100,
    "pages": 10
  }
}
```

---

## 🛡️ AUTORIZACIÓN

### Roles
- **STUDENT**: Acceso a sus propios datos y funcionalidades de estudiante
- **ADMINISTRATOR**: Acceso completo al sistema

### Middleware de Autenticación
- Todas las rutas requieren token JWT válido excepto login y reset-password
- Validación de roles según la funcionalidad
- Verificación de permisos para acceso a datos de otros usuarios