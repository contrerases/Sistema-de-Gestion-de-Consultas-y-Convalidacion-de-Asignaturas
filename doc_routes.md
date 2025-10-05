# Plan de Rutas y Vistas SGSCT (Documentación)

Este documento describe y explica el sistema de rutas de la aplicación, basado en los archivos de rutas actuales para estudiantes y administradores. El diseño es modular, escalable y aprovecha rutas anidadas y layouts dedicados para cada tipo de usuario.

---

## 1. Rutas para Estudiante (`/student`)

**Layout:** StudentLayout

- `/student/about` → AboutView
  - Página informativa sobre el sistema o el usuario.
- `/student/profile` → ProfileView
  - Perfil del estudiante, edición de datos personales, cambio de contraseña.
- `/student/convalidations` → ConvalidationView (usa ConvalidationListLayout)
  - Redirige por defecto a las convalidaciones pendientes.
  - Rutas hijas:
    - `/student/convalidations/new` → ConvalidationForm
      - Formulario para crear una nueva solicitud de convalidación.
    - `/student/convalidations/pending` → ConvalidationPendingList
      - Lista de convalidaciones pendientes.
    - `/student/convalidations/approved` → ConvalidationApprovedList
      - Lista de convalidaciones aprobadas.
    - `/student/convalidations/rejected` → ConvalidationRejectedList
      - Lista de convalidaciones rechazadas.
    - `/student/convalidations/:id` → ConvalidationDetail
      - Detalle de una convalidación específica.
- `/student/workshops` → WorkshopListLayout
  - Redirige por defecto a los talleres disponibles para inscripción.
  - Rutas hijas:
    - `/student/workshops/to-inscription` → WorkshopToInscriptionList
      - Lista de talleres disponibles para inscripción.
    - `/student/workshops/:id` → WorkshopDetail
      - Detalle de un taller específico.
    - `/student/workshops/:id/inscription` → WorkshopInscriptionForm
      - Formulario de inscripción a taller (incluye aceptación de carta de compromiso y selección de curso libre para convalidar).
    - `/student/workshops/grades` → WorkshopGrades
      - Historial de calificaciones de talleres.
    - `/student/workshops/in-progress` → WorkshopInProgressList
      - Talleres actualmente en curso.
    - `/student/workshops/history` → WorkshopHistoryList
      - Historial de talleres cursados.
- `/student/notifications` → NotificationList
  - Lista de notificaciones del estudiante.

**Notas:**
- Se usan rutas anidadas para agrupar funcionalidades relacionadas (convalidaciones, talleres).
- Cada sección principal tiene su propio layout o componente de lista.
- Las rutas hijas permiten vistas especializadas y navegación fluida dentro de cada módulo.

---

## 2. Rutas para Administrador (`/admin`)

**Layout:** AdminLayout

- `/admin/dashboard` → DashboardView
  - Dashboard principal con estadísticas y resumen del sistema.
- `/admin/profile` → ProfileView
  - Perfil del administrador, edición de datos personales, cambio de contraseña.
- `/admin/convalidations` → ConvalidationListView
  - Redirige por defecto a las convalidaciones pendientes.
  - Rutas hijas:
    - `/admin/convalidations/pending` → ConvalidationPendingList
      - Lista de solicitudes pendientes de revisión.
    - `/admin/convalidations/:id` → ConvalidationDetail
      - Detalle y revisión de una solicitud específica.
- `/admin/workshops` → WorkshopListView
  - Redirige por defecto a los talleres disponibles para inscripción.
  - Rutas hijas:
    - `/admin/workshops/to-inscription` → WorkshopToInscriptionList
      - Lista de talleres disponibles para inscripción.
    - `/admin/workshops/:id` → WorkshopDetail
      - Detalle de un taller específico.
    - `/admin/workshops/:id/inscriptions` → WorkshopInscriptionList
      - Lista de inscritos a un taller.
    - `/admin/workshops/:id/grades` → WorkshopGrades
      - Calificaciones de un taller.
- `/admin/users/students` → StudentListView
  - Redirige por defecto a la lista de estudiantes.
  - Rutas hijas:
    - `/admin/users/students/new` → StudentFormView
      - Formulario para crear un nuevo estudiante.
    - `/admin/users/students/:id` → StudentDetailView
      - Detalle y edición de un estudiante.
- `/admin/users/admins` → AdminListView
  - Redirige por defecto a la lista de administradores.
  - Rutas hijas:
    - `/admin/users/admins/new` → AdminFormView
      - Formulario para crear un nuevo administrador.
    - `/admin/users/admins/:id` → AdminDetailView
      - Detalle y edición de un administrador.
- `/admin/management` → ManagementLayout
  - Redirige por defecto a la gestión de departamentos.
  - Rutas hijas:
    - `/admin/management/departments` → DepartmentListView
      - Lista de departamentos.
      - Hijas:
        - `/admin/management/departments/new` → DepartmentFormView
        - `/admin/management/departments/:id` → DepartmentDetail
    - `/admin/management/subjects` → SubjectListView
      - Lista de asignaturas.
      - Hijas:
        - `/admin/management/subjects/new` → SubjectForm
        - `/admin/management/subjects/:id` → SubjectDetail
    - `/admin/management/curriculum-course-slots` → CurriculumCourseSlotListView
      - Lista de casillas curriculares.
      - Hijas:
        - `/admin/management/curriculum-course-slots/new` → CurriculumCourseSlotForm
        - `/admin/management/curriculum-course-slots/:id` → CurriculumCourseSlotDetail
- `/admin/students/:id/profile` → StudentProfileView
  - Perfil detallado de un estudiante.
- `/admin/notifications` → NotificationListView
  - Lista de notificaciones del administrador.
  - Hijas:
    - `/admin/notifications/:id` → NotificationDetail
      - Detalle de una notificación específica.

**Notas:**
- El uso de rutas anidadas permite agrupar y organizar la gestión de entidades complejas (usuarios, catálogos, talleres).
- Los redirects aseguran que al entrar a una sección se muestre la vista más relevante por defecto.
- Cada módulo tiene su propio layout o componente de lista para facilitar la navegación y el mantenimiento.

---

## 3. Buenas Prácticas y Ventajas

- **Escalabilidad:** El sistema de rutas es fácilmente ampliable para nuevas funcionalidades.
- **Modularidad:** Cada dominio funcional (convalidaciones, talleres, usuarios, catálogos) está claramente separado.
- **UX:** Navegación fluida y jerárquica, con rutas hijas y redirects para mejorar la experiencia de usuario.
- **Mantenibilidad:** La estructura facilita la localización y edición de rutas y vistas.

---

**Este plan de rutas es la base para la navegación y la estructura de vistas de toda la aplicación SGSCT.** 