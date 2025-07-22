# Funcionalidades SGSCT




## 🎓 ESTUDIANTE

1. Autenticación y Perfil
   - Iniciar sesión (La sesión se mantiene activa por 60 minutos) (No se guarda sesión en la base de datos, al cerrar sesión se elimina el token de la sesión)
   - Cerrar sesión
   - Cambiar contraseña
   - Recuperar contraseña


2. Solicitudes de Convalidación
   - Crear nueva solicitud de convalidación

   - Agregar convalidaciones por tipo: asignaturas, talleres inscritos, cursos certificados (PDF certificado), proyectos personales (ficha proyecto personal), otros. (Adjuntar file correspondiente)
   - Ver historial de convalidaciones enviadas (Busqueda avanzada) (Descargar file correspondiente)
   - Ver detalle de convalidaciones enviadas
   - Ver estado de solciitudes enviadas no revisadas (Poder eliminar convalidaciones no revisadas) 
   - Ver revisiones de convalidaciones y comentarios del revisor 

3. Talleres
   - Ver talleres disponibles para inscripción
   - Ver detalles del taller: descripción, profesor, fechas, horarios, syllabus (Descargar syllabus) 
   - Inscribirse a talleres disponibles
   - Cancelar inscripción (antes del inicio)
   - Ver talleres inscritos actuales
   - Ver historial de talleres cursados y su calificación (filtrar por estado de taller)

4. Progreso Académico 
   - Ver resumen de cursos curriculares completados
   - Ver graficamente su proreso con diagrama de barras

5. Notificaciones
   - Recibir notificaciones sobre cambios en solicitudes, inscripciones, talleres, calificaciones
   - Marcar notificaciones como leídas

6. Ayuda
   - Ver guías sobre el proceso de convalidación (Explicacion a detalle)
   - Ver guías sobre el proceso de inscripción a talleres (Explicacion a detalle)
   - Descargar documentos de ayuda (FICHA PROYECTO PERSONAL)

---

## 👨‍💼 ADMINISTRADOR

1. Autenticación
   - Iniciar sesión
   - Cerrar sesión
   - Cambiar contraseña
   - Recuperar contraseña


2. Gestión de Solicitudes
   - Ver solicitudes pendientes de revisión
   - Ver historial completo de solicitudes (Busqueda avanzada) 
   - Revisar solicitudes (Comentar y cambiar estado)

  

3. Gestión de Talleres
   - Crear, editar, eliminar talleres ( Con su archivo syllabus)
   - Cambiar estado de taller 
   - Ver lista de estudiantes inscritos (Exportar lista de estudiantes (Excel))
   - Subir calificaciones (individual/masiva) (Exportar calificaciones (Excel))
   - Exportar informe de talleres para enviar a DE (Exportar informe (Excel)  [NOMBRE, RUT, NOTA, LIBRE A CONVALIDAR])
   
4. Gestión de Usuarios
   - Crear, editar, eliminar estudiantes individualmente
   - Crear, editar, eliminar administradores individualmente
   - Crear cuentas masivas (Excel) (pass generada automaticamente)
  
 

5. Gestión de Catálogos y Tablas Maestras
   - CRUD de departamentos (Carga masiva de departamentos (Excel))
   - CRUD de asignaturas (Carga masiva de asignaturas (Excel))
   - CRUD de cursos curriculares (Carga masiva de cursos curriculares (Excel))
   - READ  tipos de convalidación
   - READ tipos  de cursos curriculares
   - READ de estados de taller
   - READ de estados de convalidación
   

6. Estadisticas
   - Ver dashboard automático con estadisticas importantes

7. Perfil de estudiante.
 - Ver perfil alumno (Historial de convalidaciones, talleres, notas, avance academico)

8. Notificaciones:
   - Ver notificaciones no leídas (Poder marcar como leídas)

