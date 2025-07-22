# Estructura Profesional de la API (FastAPI + Pydantic + JWT)

Este documento describe la estructura recomendada y **completa** para una API de tamaño mediano/grande, alineada con las mejores prácticas y la lógica de negocio de tu sistema.

---

## Árbol de Directorios Completo

```
server/
│
├── main.py
│
├── config/
│   └── settings.py
│
├── api/
│   └── v1/
│       ├── __init__.py
│       └── endpoints/
│           ├── __init__.py
│           ├── admin.py
│           ├── auth.py
│           ├── convalidation.py
│           ├── state/
│           │   ├── convalidation_state.py
│           │   └── workshop_state.py
│           ├── type/
│           │   ├── curriculum_courses_type.py
│           │   └── convalidation_type.py
│           ├── curriculum_course.py
│           ├── department.py
│           ├── notification.py
│           ├── statistics.py
│           ├── student.py
│           ├── subject.py
│           ├── workshop.py
│           ├── workshop_grade.py
│           ├── workshop_inscription.py
│           ├── stats.py
│           └── __init__.py
│
├── schemas/
│   ├── __init__.py
│   ├── admin/
│   │   ├── __init__.py
│   │   ├── admin_in.py
│   │   ├── admin_out.py
│   ├── auth/
│   │   ├── __init__.py
│   │   ├── login_in.py
│   │   ├── login_out.py
│   │   ├── change_password_in.py
│   │   ├── reset_password_in.py
│   │   └── auth_user_out.py
│   ├── convalidation/
│   │   ├── __init__.py
│   │   ├── convalidation_in.py
│   │   ├── convalidation_out.py
│   │   ├── convalidation_on.py
│   │   ├── convalidation_subject_out.py
│   │   ├── convalidation_workshop_out.py
│   │   ├── convalidation_external_activity_out.py
│   │   ├── review_convalidation_in.py
│   │   └── convalidation_search_in.py
│   ├── curriculum_course/
│   │   ├── __init__.py
│   │   ├── curriculum_course_in.py
│   │   └── curriculum_course_out.py
│   ├── department/
│   │   ├── __init__.py
│   │   ├── department_in.py
│   │   └── department_out.py
│   ├── notification/
│   │   ├── __init__.py
│   │   ├── notification_in.py
│   │   └── notification_out.py
│   ├── state/
│   │   ├── __init__.py
│   │   ├── convalidation_state_in_out.py
│   │   └── workshop_state_in_out.py
│   ├── type/
│   │   ├── __init__.py
│   │   ├── curriculum_courses_type_in_out.py
│   │   └── convalidation_type_in_out.py
│   ├── student/
│   │   ├── __init__.py
│   │   ├── student_in.py
│   │   └── student_out.py
│   ├── subject/
│   │   ├── __init__.py
│   │   ├── subject_in.py
│   │   ├── subject_out.py
│   │   ├── subject_on.py
│   │   └── subject_response.py
│   ├── workshop/
│   │   ├── __init__.py
│   │   ├── workshop_in.py
│   │   ├── workshop_out.py
│   │   └── workshop_search_in.py
│   ├── workshop_grade/
│   │   ├── __init__.py
│   │   ├── workshop_grade_in.py
│   │   └── workshop_grade_out.py
│   ├── workshop_inscription/
│   │   ├── __init__.py
│   │   ├── workshop_inscription_in.py
│   │   └── workshop_inscription_out.py
│   └── stats/
│       ├── __init__.py
│       └── stats.py
│
├── crud/
│   ├── __init__.py
│   ├── admin.py
│   ├── auth.py
│   ├── convalidation.py
│   ├── state/
│   │   ├── convalidation_state.py
│   │   └── workshop_state.py
│   ├── type/
│   │   ├── curriculum_courses_type.py
│   │   └── convalidation_type.py
│   ├── curriculum_course.py
│   ├── stats.py
│   ├── department.py
│   ├── notification.py
│   ├── student.py
│   ├── subject.py
│   ├── workshop.py
│   ├── workshop_grade.py
│   ├── workshop_inscription.py
│   └── stats.py
│
├── services/
│   ├── __init__.py
│   ├── admin_service.py
│   ├── auth_service.py
│   ├── convalidation_service.py
│   ├── state/
│   │   ├── convalidation_state_service.py
│   │   └── workshop_state_service.py
│   ├── type/
│   │   ├── curriculum_courses_type_service.py
│   │   └── convalidation_type_service.py
│   ├── curriculum_course_service.py
│   ├── stats_service.py
│   ├── department_service.py
│   ├── notification_service.py
│   ├── student_service.py
│   ├── subject_service.py
│   ├── workshop_service.py
│   ├── workshop_grade_service.py
│   └── workshop_inscription_service.py
│
├── database/
│   ├── __init__.py
│   └── connection.py
│
├── core/
│   ├── __init__.py
│   ├── security.py
│   ├── middlewares.py
│   └── utils.py
│
├── utils/
│   ├── __init__.py
│   ├── constants.py
│   ├── formatters.py
│   └── helpers.py
│
└── tests/
    ├── __init__.py
    ├── convalidation/
    │   ├── test_convalidation_endpoints.py
    │   └── test_convalidation_crud.py
    ├── state/
    │   ├── test_convalidation_state_endpoints.py
    │   └── test_workshop_state_endpoints.py
    ├── type/
    │   ├── test_curriculum_courses_type_endpoints.py
    │   └── test_convalidation_type_endpoints.py
    ├── department/
    │   └── test_department_endpoints.py
    ├── student/
    │   └── test_student_endpoints.py
    ├── subject/
    │   └── test_subject_endpoints.py
    ├── workshop/
    │   └── test_workshop_endpoints.py
    ├── auth/
    │   └── test_auth_endpoints.py
    ├── admin/
    │   └── test_admin_endpoints.py
    ├── notification/
    │   └── test_notification_endpoints.py
    ├── statistics/
    │   └── test_statistics_endpoints.py
    ├── crud/
    │   └── test_crud_utils.py
    └── services/
        └── test_services_utils.py
```

---

## Descripción de Carpetas y Archivos

- **main.py**: Punto de entrada de la aplicación FastAPI.
- **config/**: Configuración global (variables de entorno, CORS, etc).
- **api/v1/endpoints/**: Rutas agrupadas por dominio. Un archivo por cada entidad principal. Los endpoints de state/ y type/ agrupan los de estado y tipo respectivamente.
- **schemas/**: Modelos Pydantic. Un subdirectorio por dominio, con archivos para cada tipo de esquema (IN, OUT, etc). Los schemas de state/ y type/ se llaman igual que el dominio seguido de _in_out.py, y son 1 a 1 con los campos de la base de datos. Todos los schemas de dashboard relacionados a estadísticas están en un solo archivo stats.py.
- **crud/**: Acceso a datos y lógica de persistencia, usando procedimientos y vistas de la base de datos. Incluye subcarpetas state/ y type/.
- **services/**: Lógica de negocio, validaciones y orquestación de flujos. Incluye subcarpetas state/ y type/.
- **database/**: Conexión y utilidades para la base de datos.
- **core/**: Seguridad, middlewares y utilidades globales.
- **utils/**: Constantes, helpers y utilidades compartidas.
- **tests/**: Pruebas unitarias y de integración, organizadas por dominio y con subcarpetas para state/ y type/.

---

### Notas
- Los nombres de archivos y módulos siguen la convención de los endpoints y procedimientos definidos en la base de datos.
- Cada dominio tiene su propio subdirectorio en `schemas/` y archivos en `crud/`, `services/` y `api/v1/endpoints/`.
- Solo `convalidation` y `workshop` tienen archivos `search_in.py` para búsquedas avanzadas.
- Los schemas de state/ y type/ son 1 a 1 con los campos de la base de datos y se llaman {dominio}_in_out.py.
- Todos los schemas de dashboard relacionados a estadísticas están en un solo archivo stats.py.
- El directorio `tests/` está preparado para pruebas unitarias y de integración por dominio.
- `core/` y `utils/` centralizan seguridad, middlewares y utilidades globales. 