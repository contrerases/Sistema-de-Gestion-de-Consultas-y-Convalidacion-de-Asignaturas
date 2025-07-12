# Propuesta de Solución: Aplicación Web para Gestión de Convalidaciones y Talleres

## 1. Visión General de la Solución

### 1.1 Propósito de la Aplicación

La aplicación web propuesta busca resolver las problemáticas identificadas en la gestión de convalidaciones y talleres del Departamento de Informática UTFSM, proporcionando una plataforma integral que centralice, automatice y optimice todos los procesos actualmente manuales.

### 1.2 Objetivos de la Solución

1. **Centralizar la información** de convalidaciones y talleres en una única plataforma
2. **Automatizar procesos** manuales para reducir tiempos de respuesta
3. **Proporcionar trazabilidad** completa de solicitudes y trámites
4. **Mejorar la experiencia** de estudiantes y administradores
5. **Generar datos estructurados** para toma de decisiones

## 2. Arquitectura de la Aplicación

### 2.1 Arquitectura General

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Frontend      │    │   Backend       │    │   Base de       │
│   (Vue.js)      │◄──►│   (FastAPI)     │◄──►│   Datos         │
│                 │    │                 │    │   (MariaDB)     │
└─────────────────┘    └─────────────────┘    └─────────────────┘
```

### 2.2 Componentes Principales

1. **Interfaz de Usuario (Frontend)**
   - Aplicación web responsiva
   - Diferentes vistas según rol de usuario
   - Interfaz intuitiva y moderna

2. **Servicios de Backend**
   - API REST para comunicación
   - Lógica de negocio centralizada
   - Gestión de autenticación y autorización

3. **Base de Datos**
   - Almacenamiento estructurado
   - Relaciones entre entidades
   - Integridad de datos

## 3. Funcionalidades por Módulo

### 3.1 Módulo de Convalidaciones

#### 3.1.1 Para Estudiantes

**Gestión de Solicitudes:**
- Formulario digital para crear solicitudes de convalidación
- Selección de tipo de convalidación (Electivo DI, Asignatura Externa, Proyecto Personal, Taller DI, Curso Certificado)
- Carga de documentos de respaldo (PDF, imágenes)
- Selección de asignatura curricular a convalidar
- Envío automático de solicitud

**Seguimiento de Solicitudes:**
- Dashboard personal con estado de todas las solicitudes
- Historial completo de solicitudes enviadas
- Notificaciones automáticas de cambios de estado
- Detalles de cada solicitud con comentarios del administrador
- Filtros y búsqueda de solicitudes

**Información y Ayuda:**
- Guía de tipos de convalidación disponibles
- Requisitos específicos por tipo de convalidación
- FAQ y documentación de ayuda
- Calculadora de créditos SCT

#### 3.1.2 Para Administradores (Jefe de Carrera)

**Gestión de Solicitudes:**
- Panel de control con todas las solicitudes pendientes
- Vista detallada de cada solicitud con documentos adjuntos
- Cambio de estado de solicitudes (Enviada, Rechazada, Aprobada por DI, En espera de DE, Aprobada por DE)
- Comentarios y observaciones por solicitud
- Aprobación/rechazo masivo de solicitudes

**Reportes y Estadísticas:**
- Dashboard con métricas de solicitudes
- Reportes por período, tipo de convalidación, estado
- Exportación de datos a Excel/PDF
- Análisis de tendencias y patrones
- Estadísticas de aprobación/rechazo

**Configuración:**
- Gestión de tipos de convalidación
- Configuración de requisitos por tipo
- Gestión de asignaturas curriculares
- Configuración de notificaciones

### 3.2 Módulo de Talleres

#### 3.2.1 Para Estudiantes

**Catálogo de Talleres:**
- Lista completa de talleres disponibles
- Filtros por semestre, año, profesor, área
- Información detallada de cada taller (descripción, horarios, cupos)
- Descarga de material de talleres
- Búsqueda y filtros avanzados

**Inscripción a Talleres:**
- Proceso de inscripción digital
- Verificación automática de cupos disponibles
- Confirmación automática de inscripción
- Cancelación de inscripción con restricciones
- Lista de espera automática

**Seguimiento de Talleres:**
- Dashboard con talleres inscritos
- Calificaciones y asistencias
- Material de clases y recursos
- Comunicaciones del profesor
- Estado de convalidación del taller

#### 3.2.2 Para Administradores

**Gestión de Talleres:**
- Creación y edición de talleres
- Configuración de cupos, fechas, horarios
- Asignación de profesores
- Gestión de estados (Inscripción, En curso, Finalizado)
- Carga de material y recursos

**Gestión de Inscripciones:**
- Vista de todas las inscripciones
- Aprobación/rechazo de inscripciones
- Gestión de lista de espera
- Asignación manual de cupos
- Reportes de asistencia

**Calificaciones:**
- Ingreso de calificaciones por taller
- Reportes de rendimiento
- Exportación de notas
- Comunicación con estudiantes

#### 3.2.3 Para Profesores

**Gestión de Talleres Asignados:**
- Vista de talleres a cargo
- Lista de estudiantes inscritos
- Ingreso de calificaciones
- Registro de asistencias
- Comunicación con estudiantes

**Material y Recursos:**
- Carga de material de clases
- Compartir recursos adicionales
- Anuncios y comunicaciones
- Calendario de actividades

### 3.3 Módulo de Comunicaciones

#### 3.3.1 Sistema de Notificaciones

**Notificaciones Automáticas:**
- Cambios de estado en solicitudes
- Nuevos talleres disponibles
- Recordatorios de fechas límite
- Confirmaciones de inscripciones
- Calificaciones publicadas

**Canales de Comunicación:**
- Notificaciones en la aplicación
- Correos electrónicos automáticos
- SMS para casos críticos
- Push notifications (futuro)

#### 3.3.2 Mensajería Interna

**Chat entre Actores:**
- Comunicación directa estudiante-administrador
- Chat grupal para talleres
- Historial de conversaciones
- Archivos adjuntos en mensajes

### 3.4 Módulo de Reportes y Analytics

#### 3.4.1 Dashboard Ejecutivo

**Métricas Principales:**
- Solicitudes de convalidación por período
- Tasa de aprobación/rechazo
- Talleres más populares
- Tiempo promedio de respuesta
- Satisfacción de usuarios

**Gráficos Interactivos:**
- Evolución temporal de solicitudes
- Distribución por tipo de convalidación
- Análisis de tendencias
- Comparativas entre períodos

#### 3.4.2 Reportes Específicos

**Para Administración:**
- Reporte de carga de trabajo
- Análisis de eficiencia de procesos
- Identificación de cuellos de botella
- Proyecciones y planificación

**Para Estudiantes:**
- Historial personal de solicitudes
- Progreso académico
- Estadísticas de participación en talleres
- Recomendaciones personalizadas

## 4. Roles y Permisos

### 4.1 Estudiante
- **Acceso:** Módulos de convalidaciones y talleres
- **Permisos:** Crear solicitudes, inscribirse en talleres, ver su información
- **Restricciones:** No puede modificar datos de otros usuarios

### 4.2 Jefe de Carrera
- **Acceso:** Todos los módulos con privilegios administrativos
- **Permisos:** Gestión completa de solicitudes, configuración del sistema
- **Funciones:** Aprobación/rechazo, reportes, configuración

### 4.3 Secretaría
- **Acceso:** Módulo de talleres y reportes básicos
- **Permisos:** Gestión de inscripciones, apoyo administrativo
- **Funciones:** Inscripciones manuales, atención a estudiantes

### 4.4 Profesor de Taller
- **Acceso:** Módulo de talleres asignados
- **Permisos:** Gestión de su taller, calificaciones, comunicación
- **Funciones:** Ingreso de notas, material, comunicación

### 4.5 Administrador del Sistema
- **Acceso:** Configuración completa del sistema
- **Permisos:** Gestión de usuarios, configuración, mantenimiento
- **Funciones:** Administración técnica, respaldos, actualizaciones

## 5. Flujos de Trabajo Principales

### 5.1 Flujo de Solicitud de Convalidación

```
1. Estudiante accede a la aplicación
2. Selecciona "Nueva Solicitud de Convalidación"
3. Completa formulario con datos requeridos
4. Adjunta documentos de respaldo
5. Envía solicitud
6. Sistema notifica al Jefe de Carrera
7. Jefe de Carrera revisa y cambia estado
8. Sistema notifica al estudiante
9. Si es aprobada, se registra en SIGA (proceso manual)
10. Sistema actualiza estado final
```

### 5.2 Flujo de Inscripción a Taller

```
1. Estudiante accede al catálogo de talleres
2. Selecciona taller de interés
3. Revisa información y requisitos
4. Confirma inscripción
5. Sistema verifica cupos disponibles
6. Si hay cupo, confirma inscripción
7. Si no hay cupo, agrega a lista de espera
8. Sistema notifica al estudiante
9. Profesor recibe lista de estudiantes
10. Taller comienza con seguimiento automático
```

## 6. Características Técnicas

### 6.1 Frontend (Vue.js)

**Componentes Principales:**
- Dashboard personalizado por rol
- Formularios dinámicos para solicitudes
- Tablas interactivas con filtros
- Sistema de notificaciones en tiempo real
- Carga de archivos con preview

**Características de UX:**
- Diseño responsivo para móviles
- Navegación intuitiva
- Feedback inmediato de acciones
- Estados de carga y error claros
- Accesibilidad (WCAG 2.1)

### 6.2 Backend (FastAPI)

**Servicios Principales:**
- API REST con documentación automática
- Autenticación JWT
- Validación de datos con Pydantic
- Manejo de archivos y documentos
- Generación de reportes

**Características Técnicas:**
- Alta performance con async/await
- Validación automática de datos
- Manejo de errores centralizado
- Logging y monitoreo
- Tests automatizados

### 6.3 Base de Datos (MariaDB)

**Estructura Principal:**
- Tablas normalizadas para usuarios, solicitudes, talleres
- Relaciones bien definidas
- Índices para consultas eficientes
- Triggers para auditoría
- Procedimientos almacenados para lógica compleja

### 6.4 Seguridad

**Medidas de Seguridad:**
- Autenticación JWT con refresh tokens
- Autorización basada en roles
- Validación de entrada en frontend y backend
- Sanitización de datos
- HTTPS obligatorio
- Auditoría de acciones críticas

## 7. Integraciones

### 7.1 Integración con Sistemas Existentes

**SIGA (Sistema de Gestión Académica):**
- Exportación de datos para registro manual
- Importación de información de estudiantes
- Sincronización de calificaciones

**Correo Institucional:**
- Envío de notificaciones automáticas
- Integración con directorio de usuarios
- Autenticación SSO

### 7.2 APIs Externas (Futuro)

**Plataformas de Cursos Online:**
- Verificación automática de certificados
- Integración con Coursera, Udemy, etc.
- Validación de credenciales

**Sistemas de Mensajería:**
- WhatsApp Business API
- Slack para notificaciones
- Microsoft Teams

## 8. Métricas de Éxito

### 8.1 Métricas de Eficiencia
- **Reducción del 70%** en tiempo de procesamiento de solicitudes
- **Reducción del 60%** en carga administrativa
- **Eliminación del 90%** de errores manuales
- **Tiempo de respuesta** promedio < 24 horas

### 8.2 Métricas de Satisfacción
- **Aumento del 80%** en satisfacción del estudiante
- **Reducción del 70%** en consultas repetitivas
- **Mejora del 85%** en accesibilidad a información
- **95% de usuarios** activos en el primer mes

### 8.3 Métricas Técnicas
- **Tiempo de respuesta** del sistema < 2 segundos
- **Disponibilidad** del sistema > 99.5%
- **Tasa de errores** < 1%
- **Cobertura de tests** > 90%

## 9. Plan de Implementación

### 9.1 Fase 1: Desarrollo Core (3 meses)
- Backend básico con autenticación
- Frontend con módulo de convalidaciones
- Base de datos y APIs principales
- Tests básicos

### 9.2 Fase 2: Módulo de Talleres (2 meses)
- Gestión completa de talleres
- Sistema de inscripciones
- Calificaciones y reportes
- Integración con convalidaciones

### 9.3 Fase 3: Comunicaciones y Analytics (1 mes)
- Sistema de notificaciones
- Dashboard y reportes
- Métricas y analytics
- Optimizaciones de performance

### 9.4 Fase 4: Despliegue y Capacitación (1 mes)
- Despliegue en producción
- Capacitación de usuarios
- Migración de datos
- Monitoreo y ajustes

## 10. Beneficios Esperados

### 10.1 Para Estudiantes
- **Procesos simplificados** y accesibles 24/7
- **Trazabilidad completa** de solicitudes
- **Información centralizada** y actualizada
- **Comunicación eficiente** con administración
- **Experiencia moderna** y profesional

### 10.2 Para Administración
- **Reducción significativa** de carga administrativa
- **Datos estructurados** para toma de decisiones
- **Procesos estandarizados** y eficientes
- **Reportes automáticos** y métricas
- **Mejor atención** a estudiantes

### 10.3 Para la Institución
- **Modernización** de procesos administrativos
- **Competitividad** frente a otras instituciones
- **Transparencia** y accountability
- **Escalabilidad** para futuras expansiones
- **Datos valiosos** para planificación estratégica

Esta propuesta de solución aborda directamente todas las problemáticas identificadas en el análisis, proporcionando una plataforma integral que transformará la gestión de convalidaciones y talleres en el Departamento de Informática UTFSM.
