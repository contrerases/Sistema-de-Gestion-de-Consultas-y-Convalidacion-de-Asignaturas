# Memoria de Título – Sistema de Gestión de Convalidaciones de Asignaturas y Talleres

## 🧠 Contexto General

Actualmente, el proceso de convalidación de asignaturas en la universidad se realiza de manera manual, mediante formularios físicos, correos electrónicos o planillas Excel. Esto genera:

- Ineficiencia administrativa.
- Errores humanos.
- Pérdida de documentación.
- Retrasos en las respuestas.
- Falta de trazabilidad y transparencia.

## ❗ Problema

No existe un sistema informático centralizado que automatice y estandarice el proceso de convalidaciones, dificultando la gestión para estudiantes, jefes de carrera y personal administrativo.

## 🎯 Objetivo General

Desarrollar un sistema web para gestionar convalidaciones de asignaturas y talleres, permitiendo que los distintos actores puedan participar del proceso de forma digital, eficiente, ordenada y trazable.

---

## 🛠️ Tecnologías Utilizadas

- **Frontend:** Vue 3 + TypeScript + Tailwind CSS
- **Backend:** FastAPI (Python)
- **Base de Datos:** MySQL (interacción mediante procedimientos almacenados)
- **Autenticación:** Keycloak con protocolo OIDC
- **Despliegue:** cPanel (opcional)

---

## 🔧 Funcionalidades del Sistema

### 👤 Autenticación

- Login vía Keycloak con roles definidos:
  - Estudiante
  - Administrador
  - Jefe de carrera

---

### 📄 Módulo de Solicitudes de Convalidación

- Creación de solicitudes de convalidación por estudiantes.
- Posibilidad de incluir varios cursos en una misma solicitud.
- Estado de la solicitud: En revisión, Aprobada, Rechazada, Observada, Cerrada.
- Carga de documentación de respaldo.
- Visualización del estado de avance.

#### Tipos de asignaturas curriculares a convalidar:
- Libre
- Electivo
- Electivo INF

#### Tipos de asignaturas a cursar:
- Asignatura INF
- Asignatura Externa
- Curso Certificado
- Taller de INF
- Proyecto Personal

---

### ✅ Revisión y Gestión de Convalidaciones

- Visualización y filtro de solicitudes por parte de jefes de carrera o administradores.
- Revisión detallada de cada convalidación.
- Aprobación, rechazo u observaciones.
- Justificación de cada decisión.
- Asignación del tipo de asignatura a cursar.

---

### 🎓 Módulo de Talleres INF

- Gestión de talleres:
  - Crear, editar, habilitar/inactivar.
- Inscripción a talleres por parte de estudiantes.
- Asignación de notas por parte del administrador.
- Exportación de notas a Excel.
- Revisión y convalidación automática de talleres como asignaturas curriculares.

---

### 🏛️ Gestión Académica General

- Administración de departamentos.
- Gestión de asignaturas del plan curricular.
- Asignación de tipos de asignaturas a cursos.

---

### 📊 Reportes

- Exportación de solicitudes y convalidaciones a Excel.
- Reportes por período académico.
- Exportación de inscripciones y calificaciones de talleres.

---

## 🧪 Validación del Sistema

La validación se realizará a través de **pruebas de usabilidad** con:

- 6 estudiantes de distintos años de carrera.
- 1 jefe de carrera.

Cada usuario realizará tareas específicas relacionadas con su rol, permitiendo medir la efectividad y facilidad de uso del sistema.

---

## 📦 Resultado Esperado

Un sistema web funcional que:
- Centraliza el proceso de convalidaciones.
- Reduce tiempos de gestión.
- Aumenta la trazabilidad y transparencia.
- Mejora la experiencia del usuario.
