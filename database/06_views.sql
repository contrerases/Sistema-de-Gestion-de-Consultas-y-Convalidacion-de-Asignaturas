-- =============================================================================
-- VISTAS SQL OPTIMIZADAS PARA LA APLICACIÓN WEB
-- =============================================================================

-- =============================================================================
-- 1. VISTAS DE CATÁLOGOS
-- =============================================================================

-- Tipos de convalidaciones
CREATE OR REPLACE VIEW vw_convalidation_types AS
SELECT
    CONVALIDATION_TYPES.id AS id_convalidation_type,
    CONVALIDATION_TYPES.name AS convalidation_type
FROM CONVALIDATION_TYPES
ORDER BY CONVALIDATION_TYPES.name;

-- Estados de convalidaciones
CREATE OR REPLACE VIEW vw_convalidation_states AS
SELECT
    CONVALIDATION_STATES.id AS id_convalidation_state,
    CONVALIDATION_STATES.name AS convalidation_state,
    CONVALIDATION_STATES.description AS 
FROM CONVALIDATION_STATES
ORDER BY CONVALIDATION_STATES.name;

-- Estados de talleres
CREATE OR REPLACE VIEW vw_workshop_states AS
SELECT
    WORKSHOP_STATES.id AS id_workshop_state,
    WORKSHOP_STATES.name AS workshop_state, 
    WORKSHOP_STATES.description
FROM WORKSHOP_STATES
ORDER BY WORKSHOP_STATES.name;

-- Tipos de cursos curriculares
CREATE OR REPLACE VIEW vw_curriculum_course_types AS
SELECT
    CURRICULUM_COURSES_TYPES.id AS id_curriculum_course_type,
    CURRICULUM_COURSES_TYPES.name AS curriculum_course
FROM CURRICULUM_COURSES_TYPES
ORDER BY CURRICULUM_COURSES_TYPES.name;

-- =============================================================================
-- 2. VISTAS DE TABLAS MAESTRAS
-- =============================================================================

-- Departamentos
CREATE OR REPLACE VIEW vw_departments AS
SELECT
    DEPARTMENTS.id AS id_department,
    DEPARTMENTS.name AS department
FROM DEPARTMENTS
ORDER BY DEPARTMENTS.name;

-- Asignaturas
CREATE OR REPLACE VIEW vw_subjects AS
SELECT
    SUBJECTS.id AS id_subject,
    SUBJECTS.acronym,
    SUBJECTS.name AS subject,
    SUBJECTS.credits,
    DEPARTMENTS.name AS department
FROM SUBJECTS
JOIN DEPARTMENTS ON SUBJECTS.id_department = DEPARTMENTS.id
ORDER BY SUBJECTS.name;

-- Cursos curriculares
CREATE OR REPLACE VIEW vw_curriculum_courses AS
SELECT
    CURRICULUM_COURSES.id AS id_curriculum_course,
    CURRICULUM_COURSES.name AS curriculum_course,
    CURRICULUM_COURSES_TYPES.name AS curriculum_course_type
FROM CURRICULUM_COURSES
JOIN CURRICULUM_COURSES_TYPES ON CURRICULUM_COURSES.id_curriculum_course_type = CURRICULUM_COURSES_TYPES.id
ORDER BY CURRICULUM_COURSES.name;

-- =============================================================================
-- 3. VISTAS DE TALLERES
-- =============================================================================

-- Vista de talleres con información completa y cálculos
CREATE OR REPLACE VIEW vw_workshops AS
SELECT 
    WORKSHOPS.id AS id_workshop,
    WORKSHOPS.name AS workshop,
    WORKSHOPS.semester,
    WORKSHOPS.year,
    WORKSHOPS.description,
    WORKSHOPS.inscription_start_date,
    WORKSHOPS.inscription_end_date,
    WORKSHOPS.course_start_date,
    WORKSHOPS.course_end_date,
    WORKSHOPS.inscriptions_number,
    WORKSHOPS.limit_inscriptions,
    WORKSHOPS.syllabus_data,
    PROFESSORS.id AS id_professor,
    PROFESSORS.name AS professor,
    PROFESSORS.email AS professor_email,
    WORKSHOP_STATES.id AS id_workshop_state,
    WORKSHOP_STATES.name AS workshop_state,
    WORKSHOP_STATES.description AS state_description,
    -- Cálculos dinámicos
    (WORKSHOPS.limit_inscriptions - WORKSHOPS.inscriptions_number) AS available_slots,
FROM WORKSHOPS
JOIN PROFESSORS ON WORKSHOPS.id_professor = PROFESSORS.id
JOIN WORKSHOP_STATES ON WORKSHOPS.id_workshop_state = WORKSHOP_STATES.id;

-- Vista de talleres para preview (datos mínimos)
CREATE OR REPLACE VIEW vw_workshops_preview AS
SELECT 
    WORKSHOPS.id AS id_workshop,
    WORKSHOPS.name AS workshop,
    WORKSHOPS.semester,
    WORKSHOPS.year,
    WORKSHOPS.inscriptions_number,
    WORKSHOPS.limit_inscriptions,
    PROFESSORS.name AS professor,
    WORKSHOP_STATES.name AS workshop_state,
    -- Cálculos básicos
    (WORKSHOPS.limit_inscriptions - WORKSHOPS.inscriptions_number) AS available_slots,
FROM WORKSHOPS
JOIN PROFESSORS ON WORKSHOPS.id_professor = PROFESSORS.id
JOIN WORKSHOP_STATES ON WORKSHOPS.id_workshop_state = WORKSHOP_STATES.id;

-- =============================================================================
-- 4. VISTAS DE TABLAS DE NEGOCIO
-- =============================================================================

-- Solicitudes con información completa
CREATE OR REPLACE VIEW vw_requests AS
SELECT
    REQUESTS.id AS id_request,
    REQUESTS.id_student,
    REQUESTS.sent_at,
    REQUESTS.id_reviewed_by,
    REQUESTS.reviewed_at,
    -- Datos del estudiante
    STUDENTS.rol_student,
    STUDENTS.rut_student,
    USERS.full_name AS student,
    USERS.campus AS student_campus,
    AUTH_USERS.email AS student_email,
    -- Datos del revisor (si existe)
    ADMINISTRATORS.id AS id_administrator,
    USERS_REVIEWER.full_name AS administrator,
    USERS_REVIEWER.campus AS administrator_campus,
    AUTH_USERS_REVIEWER.email AS administrator_email
FROM REQUESTS
JOIN STUDENTS ON REQUESTS.id_student = STUDENTS.id
JOIN USERS ON STUDENTS.id = USERS.id
JOIN AUTH_USERS ON USERS.id = AUTH_USERS.id
LEFT JOIN ADMINISTRATORS ON REQUESTS.id_reviewed_by = ADMINISTRATORS.id
LEFT JOIN USERS AS USERS_REVIEWER ON ADMINISTRATORS.id = USERS_REVIEWER.id
LEFT JOIN AUTH_USERS AS AUTH_USERS_REVIEWER ON USERS_REVIEWER.id = AUTH_USERS_REVIEWER.id;

-- Solicitudes para preview (datos mínimos)
CREATE OR REPLACE VIEW vw_requests_preview AS
SELECT
    REQUESTS.id AS id_request,
    REQUESTS.sent_at,
    REQUESTS.reviewed_at,
    STUDENTS.rol_student,
    STUDENTS.rut_student,
    USERS.full_name AS student_name,
    USERS.campus AS student_campus
FROM REQUESTS
JOIN STUDENTS ON REQUESTS.id_student = STUDENTS.id
JOIN USERS ON STUDENTS.id = USERS.id;

-- Convalidaciones con información completa
CREATE OR REPLACE VIEW vw_convalidations     AS
SELECT
    CONVALIDATIONS.id AS id_convalidation,
    CONVALIDATIONS.id_request,
    CONVALIDATIONS.id_convalidation_type,
    CONVALIDATIONS.id_convalidation_state,
    CONVALIDATIONS.id_curriculum_course,
    CONVALIDATIONS.review_comments,
    -- Datos del tipo de convalidación
    CONVALIDATION_TYPES.name AS convalidation_type,
    -- Datos del estado de convalidación
    CONVALIDATION_STATES.name AS convalidation_state,
    -- Datos del curso curricular
    CURRICULUM_COURSES.name AS curriculum_course,
    CURRICULUM_COURSES_TYPES.name AS curriculum_course_type,
    -- Datos de la solicitud
    REQUESTS.sent_at,
    REQUESTS.reviewed_at,
    -- Datos del estudiante
    STUDENTS.rol_student,
    STUDENTS.rut_student,
    USERS.full_name AS student,
    USERS.campus AS student_campus,
    AUTH_USERS.email AS student_email,
    -- Datos del revisor
    ADMINISTRATORS.id AS id_administrator,
    USERS_REVIEWER.full_name AS administrator,
    USERS_REVIEWER.campus AS administrator_campus,
    AUTH_USERS_REVIEWER.email AS administrator_email
FROM CONVALIDATIONS
JOIN CONVALIDATION_TYPES ON CONVALIDATIONS.id_convalidation_type = CONVALIDATION_TYPES.id
JOIN CONVALIDATION_STATES ON CONVALIDATIONS.id_convalidation_state = CONVALIDATION_STATES.id
JOIN CURRICULUM_COURSES ON CONVALIDATIONS.id_curriculum_course = CURRICULUM_COURSES.id
JOIN CURRICULUM_COURSES_TYPES ON CURRICULUM_COURSES.id_curriculum_course_type = CURRICULUM_COURSES_TYPES.id
JOIN REQUESTS ON CONVALIDATIONS.id_request = REQUESTS.id
JOIN STUDENTS ON REQUESTS.id_student = STUDENTS.id
JOIN USERS ON STUDENTS.id = USERS.id
JOIN AUTH_USERS ON USERS.id = AUTH_USERS.id
LEFT JOIN ADMINISTRATORS ON REQUESTS.id_reviewed_by = ADMINISTRATORS.id
LEFT JOIN USERS AS USERS_REVIEWER ON ADMINISTRATORS.id = USERS_REVIEWER.id
LEFT JOIN AUTH_USERS AS AUTH_USERS_REVIEWER ON USERS_REVIEWER.id = AUTH_USERS_REVIEWER.id;

-- Convalidaciones para preview (datos mínimos)
CREATE OR REPLACE VIEW vw_convalidations_preview AS
SELECT
    CONVALIDATIONS.id AS id_convalidation,
    -- Datos básicos
    CONVALIDATION_TYPES.name AS convalidation_type,
    CONVALIDATION_STATES.name AS convalidation_state,
    CURRICULUM_COURSES.name AS curriculum_course,
    -- Datos del estudiante
    STUDENTS.rol_student,
    STUDENTS.rut_student,
    USERS.full_name AS student,
FROM CONVALIDATIONS
JOIN CONVALIDATION_TYPES ON CONVALIDATIONS.id_convalidation_type = CONVALIDATION_TYPES.id
JOIN CONVALIDATION_STATES ON CONVALIDATIONS.id_convalidation_state = CONVALIDATION_STATES.id
JOIN CURRICULUM_COURSES ON CONVALIDATIONS.id_curriculum_course = CURRICULUM_COURSES.id
JOIN STUDENTS ON REQUESTS.id_student = STUDENTS.id
JOIN USERS ON STUDENTS.id = USERS.id;

-- Convalidaciones de asignaturas
CREATE OR REPLACE VIEW vw_convalidation_subjects AS
SELECT
    CONVALIDATIONS_SUBJECTS.id_convalidation,
    CONVALIDATIONS_SUBJECTS.id_subject,
    SUBJECTS.acronym,
    SUBJECTS.name AS subject,
    SUBJECTS.credits,
    DEPARTMENTS.name AS department
FROM CONVALIDATIONS_SUBJECTS
JOIN SUBJECTS ON CONVALIDATIONS_SUBJECTS.id_subject = SUBJECTS.id
JOIN DEPARTMENTS ON SUBJECTS.id_department = DEPARTMENTS.id;

-- Convalidaciones de talleres
CREATE OR REPLACE VIEW vw_convalidation_workshops AS
SELECT
    CONVALIDATIONS_WORKSHOPS.id_convalidation,
    CONVALIDATIONS_WORKSHOPS.id_workshop,
    WORKSHOPS.name AS workshop,
    WORKSHOPS.semester,
    WORKSHOPS.year,
    PROFESSORS.name AS professor
FROM CONVALIDATIONS_WORKSHOPS
JOIN WORKSHOPS ON CONVALIDATIONS_WORKSHOPS.id_workshop = WORKSHOPS.id
JOIN PROFESSORS ON WORKSHOPS.id_professor = PROFESSORS.id;

-- Convalidaciones de actividades externas
CREATE OR REPLACE VIEW vw_convalidation_external_activities AS
SELECT
    CONVALIDATIONS_EXTERNAL_ACTIVITIES.id_convalidation,
    CONVALIDATIONS_EXTERNAL_ACTIVITIES.activity_name AS activity,
    CONVALIDATIONS_EXTERNAL_ACTIVITIES.description,
    CONVALIDATIONS_EXTERNAL_ACTIVITIES.file_name,
    CONVALIDATIONS_EXTERNAL_ACTIVITIES.file_data
FROM CONVALIDATIONS_EXTERNAL_ACTIVITIES;

-- Inscripciones con información completa
CREATE OR REPLACE VIEW vw_workshop_inscriptions AS
SELECT
    WORKSHOPS_INSCRIPTIONS.id AS id_inscription,
    WORKSHOPS_INSCRIPTIONS.id_student,
    WORKSHOPS_INSCRIPTIONS.id_workshop,
    WORKSHOPS_INSCRIPTIONS.is_convalidated,
    WORKSHOPS_INSCRIPTIONS.id_curriculum_course,
    -- Datos del estudiante
    STUDENTS.rol_student,
    STUDENTS.rut_student,
    USERS.full_name AS student,
    USERS.campus AS student_campus,
    AUTH_USERS.email AS student_email,
    -- Datos del taller
    WORKSHOPS.name AS workshop,
    WORKSHOPS.semester,
    WORKSHOPS.year,
    WORKSHOPS.inscription_start_date,
    WORKSHOPS.inscription_end_date,
    WORKSHOPS.course_start_date,
    WORKSHOPS.course_end_date,
    WORKSHOP_STATES.name AS workshop_state,
    -- Datos del curso curricular
    CURRICULUM_COURSES.name AS curriculum_course,
    CURRICULUM_COURSES_TYPES.name AS curriculum_course_type,
    -- Datos del profesor
    PROFESSORS.name AS professor,
    PROFESSORS.email AS professor_email
FROM WORKSHOPS_INSCRIPTIONS
JOIN STUDENTS ON WORKSHOPS_INSCRIPTIONS.id_student = STUDENTS.id
JOIN USERS ON STUDENTS.id = USERS.id
JOIN AUTH_USERS ON USERS.id = AUTH_USERS.id
JOIN WORKSHOPS ON WORKSHOPS_INSCRIPTIONS.id_workshop = WORKSHOPS.id
JOIN WORKSHOP_STATES ON WORKSHOPS.id_workshop_state = WORKSHOP_STATES.id
JOIN PROFESSORS ON WORKSHOPS.id_professor = PROFESSORS.id
LEFT JOIN CURRICULUM_COURSES ON WORKSHOPS_INSCRIPTIONS.id_curriculum_course = CURRICULUM_COURSES.id
LEFT JOIN CURRICULUM_COURSES_TYPES ON CURRICULUM_COURSES.id_curriculum_course_type = CURRICULUM_COURSES_TYPES.id;

-- Inscripciones para preview (datos mínimos)
CREATE OR REPLACE VIEW vw_workshop_inscriptions_preview AS
SELECT
    WORKSHOPS_INSCRIPTIONS.id AS id_inscription,
    -- Datos básicos del estudiante
    STUDENTS.rol_student,
    STUDENTS.rut_student,
    USERS.full_name AS student,
    -- Datos básicos del taller
    WORKSHOPS.name AS workshop,
    WORKSHOPS.semester,
    WORKSHOPS.year,
    WORKSHOP_STATES.name AS workshop_state
FROM WORKSHOPS_INSCRIPTIONS
JOIN STUDENTS ON WORKSHOPS_INSCRIPTIONS.id_student = STUDENTS.id
JOIN USERS ON STUDENTS.id = USERS.id
JOIN WORKSHOPS ON WORKSHOPS_INSCRIPTIONS.id_workshop = WORKSHOPS.id
JOIN WORKSHOP_STATES ON WORKSHOPS.id_workshop_state = WORKSHOP_STATES.id;

-- Calificaciones con información completa
CREATE OR REPLACE VIEW vw_workshop_grades AS
SELECT
    WORKSHOPS_GRADES.id AS id_grade,
    WORKSHOPS_GRADES.id_student,
    WORKSHOPS_GRADES.id_workshop,
    WORKSHOPS_GRADES.grade,
    WORKSHOPS_GRADES.evaluated_at,
    -- Datos del estudiante
    STUDENTS.rol_student,
    STUDENTS.rut_student,
    USERS.full_name AS student,
    -- Datos del taller
    WORKSHOPS.name AS workshop,
    WORKSHOPS.semester,
    WORKSHOPS.year,
    WORKSHOP_STATES.name AS workshop_state,
    -- Datos del profesor
    PROFESSORS.name AS professor,
    PROFESSORS.email AS professor_email
FROM WORKSHOPS_GRADES
JOIN STUDENTS ON WORKSHOPS_GRADES.id_student = STUDENTS.id
JOIN USERS ON STUDENTS.id = USERS.id
JOIN AUTH_USERS ON USERS.id = AUTH_USERS.id
JOIN WORKSHOPS ON WORKSHOPS_GRADES.id_workshop = WORKSHOPS.id
JOIN WORKSHOP_STATES ON WORKSHOPS.id_workshop_state = WORKSHOP_STATES.id
JOIN PROFESSORS ON WORKSHOPS.id_professor = PROFESSORS.id;

-- Calificaciones para preview (datos mínimos)
CREATE OR REPLACE VIEW vw_workshop_grades_preview AS
SELECT
    WORKSHOPS_GRADES.id AS id_grade,
    WORKSHOPS_GRADES.grade,
    -- Datos básicos del estudiante
    STUDENTS.rol_student,
    STUDENTS.rut_student,
    USERS.full_name AS student_name,
    -- Datos básicos del taller
    WORKSHOPS.name AS workshop_name,
    WORKSHOPS.semester,
    WORKSHOPS.year,
    WORKSHOP_STATES.name AS workshop_state
FROM WORKSHOPS_GRADES
JOIN STUDENTS ON WORKSHOPS_GRADES.id_student = STUDENTS.id
JOIN USERS ON STUDENTS.id = USERS.id
JOIN WORKSHOPS ON WORKSHOPS_GRADES.id_workshop = WORKSHOPS.id
JOIN WORKSHOP_STATES ON WORKSHOPS.id_workshop_state = WORKSHOP_STATES.id;



-- =============================================================================
-- 6. VISTAS DE USUARIOS
-- =============================================================================

-- Profesores activos
CREATE OR REPLACE VIEW vw_professors AS
SELECT
    PROFESSORS.id AS id_professor,
    PROFESSORS.name AS professor,
    PROFESSORS.email AS professor_email
FROM PROFESSORS;

-- Estudiantes con datos esenciales
CREATE OR REPLACE VIEW vw_students AS
SELECT
    STUDENTS.id AS id_student,
    USERS.full_name AS student,
    STUDENTS.rol_student,
    STUDENTS.rut_student,
    AUTH_USERS.email AS student_email,
    USERS.created_at,
    USERS.updated_at
FROM STUDENTS
JOIN USERS ON STUDENTS.id = USERS.id
JOIN AUTH_USERS ON AUTH_USERS.id = USERS.id;


-- Administradores con datos esenciales
CREATE OR REPLACE VIEW vw_admins AS
SELECT
    ADMINISTRATORS.id AS id_administrator,
    USERS.full_name AS administrator,
    AUTH_USERS.email AS administrator_email,
    USERS.created_at,
    USERS.updated_at
FROM ADMINISTRATORS
JOIN USERS ON ADMINISTRATORS.id = USERS.id
JOIN AUTH_USERS ON AUTH_USERS.id = USERS.id;



-- =============================================================================
-- 7. VISTAS DE NOTIFICACIONES
-- =============================================================================

-- Notificaciones con información completa
CREATE OR REPLACE VIEW vw_notifications AS
SELECT
    NOTIFICATIONS.id AS id_notification,
    NOTIFICATIONS.id_user,
    NOTIFICATIONS.notification_type,
    NOTIFICATIONS.message AS notification,
    NOTIFICATIONS.is_read,
    NOTIFICATIONS.is_sent,
    NOTIFICATIONS.created_at,
    NOTIFICATIONS.read_at,
    NOTIFICATIONS.sent_at,
    -- Datos del usuario
    USERS.full_name AS user,
    AUTH_USERS.email AS user_email,
    -- Determinar tipo de usuario
    CASE
        WHEN EXISTS (SELECT 1 FROM STUDENTS WHERE STUDENTS.id = NOTIFICATIONS.id_user) THEN 'STUDENT'
        WHEN EXISTS (SELECT 1 FROM ADMINISTRATORS WHERE ADMINISTRATORS.id = NOTIFICATIONS.id_user) THEN 'ADMINISTRATOR'
        ELSE 'UNKNOWN'
    END AS user_type
FROM NOTIFICATIONS
JOIN USERS ON NOTIFICATIONS.id_user = USERS.id
JOIN AUTH_USERS ON USERS.id = AUTH_USERS.id;



-- =============================================================================
-- 8. VISTAS DE TOKENS Y UTILIDADES
-- =============================================================================

-- Tokens de talleres activos
CREATE OR REPLACE VIEW vw_workshop_tokens AS
SELECT
    WORKSHOPS_TOKENS.id AS id_workshop_token,
    WORKSHOPS_TOKENS.id_workshop,
    WORKSHOPS_TOKENS.token,
    WORKSHOPS_TOKENS.id_professor,
    WORKSHOPS_TOKENS.expiration_at,
    WORKSHOPS_TOKENS.created_at,
    WORKSHOPS_TOKENS.used_at,
    WORKSHOPS_TOKENS.created_by AS id_created_by,
    WORKSHOPS_TOKENS.is_used,
    -- Datos del taller
    WORKSHOPS.name AS workshop,
    WORKSHOPS.semester,
    WORKSHOPS.year,
    -- Datos del profesor
    PROFESSORS.name AS professor,
    PROFESSORS.email AS professor_email
FROM WORKSHOPS_TOKENS
JOIN WORKSHOPS ON WORKSHOPS_TOKENS.id_workshop = WORKSHOPS.id
JOIN PROFESSORS ON WORKSHOPS_TOKENS.id_professor = PROFESSORS.id



-- =============================================================================
-- 9. VISTAS DE ESTADÍSTICAS
-- =============================================================================


