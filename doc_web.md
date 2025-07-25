# Estructura Profesional Frontend SGSCT (Vue 3 + TypeScript + Tailwind + Pinia + Vue-Router)

---

## 1. Estructura de Directorios Sugerida

```plaintext
client/
│
├── src/
│   ├── app/                  # Configuración global (setup, providers, guards, etc)
│   │   ├── main.ts           # Entry point
│   │   ├── router/           # Vue Router (agrupado por roles y módulos)
│   │   ├── store/            # Pinia stores (1 por dominio)
│   │   ├── config/           # Constantes, endpoints, helpers globales
│   │   └── types/            # Tipos globales y enums
│   │
│   ├── modules/              # Módulos funcionales (1 carpeta por dominio)
│   │   ├── auth/             # Autenticación y perfil
│   │   ├── students/         # Gestión de estudiantes
│   │   ├── admins/           # Gestión de administradores
│   │   ├── departments/      # Catálogo de departamentos
│   │   ├── subjects/         # Catálogo de asignaturas
│   │   ├── curriculum/       # Cursos curriculares
│   │   ├── convalidations/   # Solicitudes y gestión de convalidaciones
│   │   ├── workshops/        # Talleres e inscripciones
│   │   ├── notifications/    # Notificaciones
│   │   ├── dashboard/        # Estadísticas y paneles
│   │   ├── help/             # Ayuda y documentación
│   │   └── shared/           # Componentes y tipos reutilizables
│   │
│   ├── layouts/              # Layouts globales (Admin, Estudiante, Público)
│   ├── assets/               # Imágenes, estilos, fuentes
│   └── shared/               # Componentes UI, dialogs, feedback, utilidades
│
├── public/                   # Archivos estáticos
├── tests/                    # Pruebas unitarias y e2e
└── ...
```

---

## 2. Archivos por Carpeta y Significado

### app/
- **main.ts**: Punto de entrada de la aplicación Vue.
- **router/**: Configuración de rutas y guards.
  - **index.ts**: Rutas principales.
  - **admin.routes.ts**: Rutas de administrador.
  - **student.routes.ts**: Rutas de estudiante.
  - **guards.ts**: Guards de navegación.
- **store/**: Pinia stores por dominio (ej: auth_store.ts, subject_store.ts, workshop_store.ts, etc).
- **config/**: Configuración global, endpoints, constantes.
- **types/**: Tipos y enums globales.

### modules/
Cada subcarpeta representa un dominio funcional. Dentro de cada una:

#### auth/
- **components/**
  - **LoginForm.vue**: Formulario de login.
  - **ChangePasswordForm.vue**: Cambio de contraseña.
  - **ResetPasswordForm.vue**: Recuperación de contraseña.
  - **ProfileView.vue**: Vista de perfil de usuario.
- **services/**
  - **auth_service.ts**: Lógica de autenticación y llamadas a la API.
- **types/**
  - **auth_user_out.ts**: Interface de usuario autenticado.
  - **login_in.ts**: Interface para login.
  - **change_password_in.ts**: Interface para cambio de contraseña.
  - **reset_password_in.ts**: Interface para recuperación de contraseña.

#### students/
- **components/**
  - **StudentList.vue**: Lista de todos los estudiantes (GET /students/).
  - **StudentDetail.vue**: Detalle de estudiante (GET /students/{id}).
  - **StudentForm.vue**: Formulario de creación/edición.
  - **StudentProfile.vue**: Vista de perfil de estudiante.
- **services/**
  - **student_service.ts**: Lógica de API para estudiantes.
- **types/**
  - **student_out.ts**: Interface de estudiante (output).
  - **student_in.ts**: Interface de estudiante (input).

#### admins/
- **components/**
  - **AdminList.vue**: Lista de todos los administradores (GET /admins/).
  - **AdminDetail.vue**: Detalle de administrador (GET /admins/{id}).
  - **AdminForm.vue**: Formulario de creación/edición.
- **services/**
  - **admin_service.ts**: Lógica de API para administradores.
- **types/**
  - **admin_out.ts**: Interface de administrador (output).
  - **admin_in.ts**: Interface de administrador (input).

#### departments/
- **components/**
  - **DepartmentList.vue**: Lista de todos los departamentos (GET /departments/).
  - **DepartmentDetail.vue**: Detalle de departamento (GET /departments/{id}).
  - **DepartmentForm.vue**: Formulario de creación/edición.
- **services/**
  - **department_service.ts**: Lógica de API para departamentos.
- **types/**
  - **department_out.ts**: Interface de departamento (output).
  - **department_in.ts**: Interface de departamento (input).

#### subjects/
- **components/**
  - **SubjectList.vue**: Lista de todas las asignaturas (GET /subjects/).
  - **SubjectDetail.vue**: Detalle de asignatura (GET /subjects/{id}).
  - **SubjectForm.vue**: Formulario de creación/edición.
- **services/**
  - **subject_service.ts**: Lógica de API para asignaturas.
- **types/**
  - **subject_out.ts**: Interface de asignatura (output).
  - **subject_in.ts**: Interface de asignatura (input).

#### curriculum/
- **components/**
  - **CurriculumCourseList.vue**: Lista de todos los cursos curriculares (GET /curriculum-courses/).
  - **CurriculumCourseDetail.vue**: Detalle de curso curricular (GET /curriculum-courses/{id}).
  - **CurriculumCourseForm.vue**: Formulario de creación/edición.
- **services/**
  - **curriculum_course_service.ts**: Lógica de API para cursos curriculares.
- **types/**
  - **curriculum_course_out.ts**: Interface de curso curricular (output).
  - **curriculum_course_in.ts**: Interface de curso curricular (input).

#### convalidations/
- **components/**
  - **ConvalidationList.vue**: Lista de convalidaciones (GET /convalidations/ y filtros avanzados).
  - **ConvalidationHistory.vue**: Historial de convalidaciones por estudiante (GET /convalidations/by-student).
  - **ConvalidationPendingList.vue**: Lista de convalidaciones pendientes (GET /convalidations/pending).
  - **ConvalidationDetail.vue**: Detalle de convalidación.
  - **NewConvalidationForm.vue**: Formulario para nueva convalidación.
  - **ConvalidationReview.vue**: Revisión de convalidaciones.
- **services/**
  - **convalidation_service.ts**: Lógica de API para convalidaciones.
- **types/**
  - **convalidation_out.ts**, **convalidation_in.ts**, **convalidation_on.ts**, **convalidation_subject_out.ts**, **convalidation_workshop_out.ts**, **convalidation_external_activity_out.ts**, **review_convalidation_in.ts**, **convalidation_search_in.ts**

#### workshops/
- **components/**
  - **WorkshopList.vue**: Lista de talleres (GET /workshops/).
  - **WorkshopDetail.vue**: Detalle de taller (GET /workshops/{id}).
  - **WorkshopInscriptionList.vue**: Lista de inscripciones a talleres (POST /workshop-inscriptions/filter).
  - **WorkshopGradesList.vue**: Lista de calificaciones de talleres (POST /workshop-grades/filter).
  - **WorkshopInscriptionForm.vue**: Formulario de inscripción.
  - **WorkshopGrades.vue**: Calificaciones de taller.
- **services/**
  - **workshop_service.ts**: Lógica de API para talleres.
- **types/**
  - **workshop_out.ts**, **workshop_in.ts**, **workshop_search_in.ts**, **workshop_grade_out.ts**, **workshop_grade_in.ts**, **workshop_inscription_out.ts**, **workshop_inscription_in.ts**

#### notifications/
- **components/**
  - **NotificationList.vue**: Lista de notificaciones (POST /notifications/filter).
- **services/**
  - **notification_service.ts**: Lógica de API para notificaciones.
- **types/**
  - **notification_out.ts**, **notification_in.ts**

#### dashboard/
- **components/**
  - **StatsOverview.vue**: Vista general de estadísticas (GET /statistics/).
  - **ConvalidationStats.vue**: Estadísticas de convalidaciones.
  - **WorkshopStats.vue**: Estadísticas de talleres.
- **services/**
  - **dashboard_service.ts**: Lógica de API para dashboard.
- **types/**
  - **stats.ts**: Tipos para estadísticas generales, por convalidación, taller, etc.

#### help/
- **components/**
  - **HelpGuide.vue**: Guías de ayuda.
  - **DownloadDocs.vue**: Descarga de documentos de ayuda.
- **services/**
  - **help_service.ts**: Lógica para ayuda/documentación.

#### shared/
- **components/**
  - **ConfirmDialog.vue**: Diálogo de confirmación reutilizable.
  - **AlertDialog.vue**: Diálogo de alerta reutilizable.
  - **SuccessDialog.vue**: Diálogo de éxito reutilizable.
- **types/**
  - **enums.ts**: Enums compartidos.
  - **helpers.ts**: Funciones utilitarias.
  - **index.ts**: Tipos utilitarios globales.

### layouts/
- **AdminLayout.vue**: Layout para vistas de administrador.
- **StudentLayout.vue**: Layout para vistas de estudiante.
- **PublicLayout.vue**: Layout para vistas públicas (si aplica).

### assets/
- **img/**: Imágenes.
- **index.css**: Estilos globales (Tailwind).

### shared/
- **components/**: Componentes UI reutilizables (botones, inputs, tablas, etc).
- **composables/**: Composables Vue 3 reutilizables (useApi, useForm, etc).
- **utils/**: Utilidades y helpers globales.

### tests/
- **unit/**: Pruebas unitarias por módulo.
- **e2e/**: Pruebas end-to-end.

---

## 3. Componentes List y Endpoints GET

Para cada entidad que tenga un endpoint GET de listado, se debe crear un componente `List` que consuma dicho endpoint y muestre los datos en tabla o lista. Ejemplos:

- **StudentList.vue**: Lista todos los estudiantes (`GET /students/`).
- **AdminList.vue**: Lista todos los administradores (`GET /admins/`).
- **DepartmentList.vue**: Lista todos los departamentos (`GET /departments/`).
- **SubjectList.vue**: Lista todas las asignaturas (`GET /subjects/`).
- **CurriculumCourseList.vue**: Lista todos los cursos curriculares (`GET /curriculum-courses/`).
- **ConvalidationList.vue**: Lista todas las convalidaciones (`GET /convalidations/` y filtros avanzados).
- **WorkshopList.vue**: Lista todos los talleres (`GET /workshops/`).
- **WorkshopInscriptionList.vue**: Lista todas las inscripciones a talleres (`POST /workshop-inscriptions/filter`).
- **WorkshopGradesList.vue**: Lista todas las calificaciones de talleres (`POST /workshop-grades/filter`).
- **NotificationList.vue**: Lista todas las notificaciones (`POST /notifications/filter`).

Cada uno de estos componentes debe estar alineado con el endpoint correspondiente y mostrar los datos de manera paginada, filtrable y reutilizable.

---

## 4. Reglas y Buenas Prácticas
- **1 archivo de tipo por cada schema de la API** (1:1, nombres y campos idénticos)
- **Componentes y servicios modulares y reutilizables**
- **No usar `any` en ningún tipo**
- **Agrupar componentes por dominio y subdominio**
- **Centralizar enums y helpers en `shared/types/` y `app/types/`**
- **Usar layouts para separar vistas de admin, estudiante y público**
- **Pinia store por dominio**
- **Servicios de API por dominio**
- **Rutas agrupadas por rol y dominio**

---

## 5. Ejemplo de Tipado 1:1 (API ↔ Web)

**Backend:** `server/schemas/subject/subject_out.py`
```python
class SubjectOut(BaseModel):
    id_subject: int
    acronym: str
    subject: str
    credits: int
    id_department: int
    department: str
```

**Frontend:** `modules/subjects/types/subject_out.ts`
```typescript
export interface SubjectOut {
  id_subject: number;
  acronym: string;
  subject: string;
  credits: number;
  id_department: number;
  department: string;
}
```

---

## 6. Testing y E2E
- `tests/unit/` para unitarios por módulo
- `tests/e2e/` para pruebas de integración y flujo completo

---

## 7. Extras
- **Documentar cada módulo y tipo**
- **Aprovechar los stores y servicios para máxima reutilización**
- **Mantener la estructura alineada con la del backend para facilitar el mantenimiento** 