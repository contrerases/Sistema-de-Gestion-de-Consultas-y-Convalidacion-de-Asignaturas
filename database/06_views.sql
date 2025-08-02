-- =============================================================================
-- VISTAS SQL OPTIMIZADAS PARA LA APLICACIÓN WEB
-- =============================================================================

-- =============================================================================
-- 1. VISTAS DE USUARIOS (OPTIMIZADAS)
-- =============================================================================

-- Vista de estudiantes con datos esenciales
CREATE OR REPLACE VIEW vw_students_essential AS
SELECT
    STUDENTS.id AS id_student,
    USERS.full_name AS name_student,
    STUDENTS.rol_student,
    STUDENTS.rut_student,
    USERS.campus AS campus_student,
    AUTH_USERS.email AS email_student,
    USERS.created_at,
    USERS.updated_at
FROM STUDENTS
JOIN USERS ON STUDENTS.id = USERS.id
JOIN AUTH_USERS ON AUTH_USERS.id = USERS.id;

-- Vista de estudiantes para preview (datos mínimos)
CREATE OR REPLACE VIEW vw_students_preview AS
SELECT
    STUDENTS.id AS id_student,
    USERS.full_name AS name_student,
    STUDENTS.rut_student,
    USERS.campus AS campus_student
FROM STUDENTS
JOIN USERS ON STUDENTS.id = USERS.id;

-- Vista de administradores con datos esenciales
CREATE OR REPLACE VIEW vw_admins_essential AS
SELECT
    ADMINISTRATORS.id AS id_admin,
    USERS.full_name AS name_admin,
    USERS.campus AS campus_admin,
    AUTH_USERS.email AS email_admin,
    USERS.created_at,
    USERS.updated_at
FROM ADMINISTRATORS
JOIN USERS ON ADMINISTRATORS.id = USERS.id
JOIN AUTH_USERS ON AUTH_USERS.id = USERS.id;

-- Vista de administradores para preview (datos mínimos)
CREATE OR REPLACE VIEW vw_admins_preview AS
SELECT
    ADMINISTRATORS.id AS id_admin,
    USERS.full_name AS name_admin,
    USERS.campus AS campus_admin
FROM ADMINISTRATORS
JOIN USERS ON ADMINISTRATORS.id = USERS.id;

-- =============================================================================
-- 2. VISTAS DE TALLERES (OPTIMIZADAS)
-- =============================================================================

-- Vista de talleres con información completa y cálculos
CREATE OR REPLACE VIEW vw_workshops_complete AS
SELECT 
    WORKSHOPS.id AS id_workshop,
    WORKSHOPS.name AS workshop_name,
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
    PROFESSORS.name AS professor_name,
    PROFESSORS.email AS professor_email,
    WORKSHOP_STATES.id AS id_workshop_state,
    WORKSHOP_STATES.name AS workshop_state,
    WORKSHOP_STATES.description AS state_description,
    -- Cálculos dinámicos
    (WORKSHOPS.limit_inscriptions - WORKSHOPS.inscriptions_number) AS available_slots,
    CASE 
        WHEN NOW() BETWEEN WORKSHOPS.inscription_start_date AND WORKSHOPS.inscription_end_date THEN TRUE
        ELSE FALSE
    END AS is_inscription_open,
    CASE 
        WHEN NOW() BETWEEN WORKSHOPS.course_start_date AND WORKSHOPS.course_end_date THEN TRUE
        ELSE FALSE
    END AS is_course_active,
    CASE 
        WHEN WORKSHOPS.inscriptions_number >= WORKSHOPS.limit_inscriptions THEN TRUE
        ELSE FALSE
    END AS is_full
FROM WORKSHOPS
JOIN PROFESSORS ON WORKSHOPS.id_professor = PROFESSORS.id
JOIN WORKSHOP_STATES ON WORKSHOPS.id_workshop_state = WORKSHOP_STATES.id;

-- Vista de talleres para preview (datos mínimos)
CREATE OR REPLACE VIEW vw_workshops_preview AS
SELECT 
    WORKSHOPS.id AS id_workshop,
    WORKSHOPS.name AS workshop_name,
    WORKSHOPS.semester,
    WORKSHOPS.year,
    WORKSHOPS.inscriptions_number,
    WORKSHOPS.limit_inscriptions,
    PROFESSORS.name AS professor_name,
    WORKSHOP_STATES.name AS workshop_state,
    -- Cálculos básicos
    (WORKSHOPS.limit_inscriptions - WORKSHOPS.inscriptions_number) AS available_slots,
    CASE 
        WHEN NOW() BETWEEN WORKSHOPS.inscription_start_date AND WORKSHOPS.inscription_end_date THEN TRUE
        ELSE FALSE
    END AS is_inscription_open
FROM WORKSHOPS
JOIN PROFESSORS ON WORKSHOPS.id_professor = PROFESSORS.id
JOIN WORKSHOP_STATES ON WORKSHOPS.id_workshop_state = WORKSHOP_STATES.id;

-- =============================================================================
-- 3. VISTAS DE INSCRIPCIONES (OPTIMIZADAS)
-- =============================================================================

-- Vista de inscripciones con información completa
CREATE OR REPLACE VIEW vw_workshop_inscriptions_complete AS
SELECT
    WORKSHOPS_INSCRIPTIONS.id AS id_inscription,
    WORKSHOPS_INSCRIPTIONS.id_student,
    WORKSHOPS_INSCRIPTIONS.id_workshop,
    WORKSHOPS_INSCRIPTIONS.is_convalidated,
    WORKSHOPS_INSCRIPTIONS.id_curriculum_course,
    -- Datos del estudiante
    STUDENTS.rol_student,
    STUDENTS.rut_student,
    USERS.full_name AS student_name,
    USERS.campus AS student_campus,
    AUTH_USERS.email AS student_email,
    -- Datos del taller
    WORKSHOPS.name AS workshop_name,
    WORKSHOPS.semester,
    WORKSHOPS.year,
    WORKSHOPS.inscription_start_date,
    WORKSHOPS.inscription_end_date,
    WORKSHOPS.course_start_date,
    WORKSHOPS.course_end_date,
    WORKSHOP_STATES.name AS workshop_state,
    -- Datos del curso curricular
    CURRICULUM_COURSES.name AS curriculum_course_name,
    CURRICULUM_COURSES_TYPES.name AS curriculum_course_type
FROM WORKSHOPS_INSCRIPTIONS
JOIN STUDENTS ON WORKSHOPS_INSCRIPTIONS.id_student = STUDENTS.id
JOIN USERS ON STUDENTS.id = USERS.id
JOIN AUTH_USERS ON AUTH_USERS.id = USERS.id
JOIN WORKSHOPS ON WORKSHOPS_INSCRIPTIONS.id_workshop = WORKSHOPS.id
JOIN WORKSHOP_STATES ON WORKSHOPS.id_workshop_state = WORKSHOP_STATES.id
LEFT JOIN CURRICULUM_COURSES ON WORKSHOPS_INSCRIPTIONS.id_curriculum_course = CURRICULUM_COURSES.id
LEFT JOIN CURRICULUM_COURSES_TYPES ON CURRICULUM_COURSES.id_curriculum_course_type = CURRICULUM_COURSES_TYPES.id;

-- Vista de inscripciones para preview (datos mínimos)
CREATE OR REPLACE VIEW vw_workshop_inscriptions_preview AS
SELECT
    WORKSHOPS_INSCRIPTIONS.id AS id_inscription,
    WORKSHOPS_INSCRIPTIONS.id_student,
    WORKSHOPS_INSCRIPTIONS.id_workshop,
    WORKSHOPS_INSCRIPTIONS.is_convalidated,
    -- Datos básicos del estudiante
    STUDENTS.rut_student,
    USERS.full_name AS student_name,
    -- Datos básicos del taller
    WORKSHOPS.name AS workshop_name,
    WORKSHOPS.semester,
    WORKSHOPS.year,
    WORKSHOP_STATES.name AS workshop_state
FROM WORKSHOPS_INSCRIPTIONS
JOIN STUDENTS ON WORKSHOPS_INSCRIPTIONS.id_student = STUDENTS.id
JOIN USERS ON STUDENTS.id = USERS.id
JOIN WORKSHOPS ON WORKSHOPS_INSCRIPTIONS.id_workshop = WORKSHOPS.id
JOIN WORKSHOP_STATES ON WORKSHOPS.id_workshop_state = WORKSHOP_STATES.id;

-- =============================================================================
-- 4. VISTAS DE CALIFICACIONES (OPTIMIZADAS)
-- =============================================================================

-- Vista de calificaciones con información completa
CREATE OR REPLACE VIEW vw_workshop_grades_complete AS
SELECT
    WORKSHOPS_GRADES.id AS id_grade,
    WORKSHOPS_GRADES.id_student,
    WORKSHOPS_GRADES.id_workshop,
    WORKSHOPS_GRADES.grade,
    -- Datos del estudiante
    STUDENTS.rol_student,
    STUDENTS.rut_student,
    USERS.full_name AS student_name,
    USERS.campus AS student_campus,
    AUTH_USERS.email AS student_email,
    -- Datos del taller
    WORKSHOPS.name AS workshop_name,
    WORKSHOPS.semester,
    WORKSHOPS.year,
    PROFESSORS.name AS professor_name,
    PROFESSORS.email AS professor_email,
    WORKSHOP_STATES.name AS workshop_state
FROM WORKSHOPS_GRADES
JOIN STUDENTS ON WORKSHOPS_GRADES.id_student = STUDENTS.id
JOIN USERS ON STUDENTS.id = USERS.id
JOIN AUTH_USERS ON AUTH_USERS.id = USERS.id
JOIN WORKSHOPS ON WORKSHOPS_GRADES.id_workshop = WORKSHOPS.id
JOIN PROFESSORS ON WORKSHOPS.id_professor = PROFESSORS.id
JOIN WORKSHOP_STATES ON WORKSHOPS.id_workshop_state = WORKSHOP_STATES.id;

-- Vista de calificaciones para preview (datos mínimos)
CREATE OR REPLACE VIEW vw_workshop_grades_preview AS
SELECT
    WORKSHOPS_GRADES.id AS id_grade,
    WORKSHOPS_GRADES.id_student,
    WORKSHOPS_GRADES.id_workshop,
    WORKSHOPS_GRADES.grade,
    -- Datos básicos del estudiante
    STUDENTS.rut_student,
    USERS.full_name AS student_name,
    -- Datos básicos del taller
    WORKSHOPS.name AS workshop_name,
    WORKSHOPS.semester,
    WORKSHOPS.year
FROM WORKSHOPS_GRADES
JOIN STUDENTS ON WORKSHOPS_GRADES.id_student = STUDENTS.id
JOIN USERS ON STUDENTS.id = USERS.id
JOIN WORKSHOPS ON WORKSHOPS_GRADES.id_workshop = WORKSHOPS.id;

-- =============================================================================
-- 5. VISTAS DE CONVALIDACIONES (OPTIMIZADAS)
-- =============================================================================

-- Vista de solicitudes con información básica
CREATE OR REPLACE VIEW vw_requests_complete AS
SELECT
    REQUESTS.id AS id_request,
    REQUESTS.sent_at,
    REQUESTS.reviewed_at,
    REQUESTS.id_student,
    REQUESTS.id_reviewed_by,
    -- Datos del estudiante
    STUDENTS.rol_student,
    STUDENTS.rut_student,
    USERS.full_name AS student_name,
    USERS.campus AS student_campus,
    AUTH_USERS.email AS student_email,
    -- Datos del revisor
    ADMINISTRATORS.id AS reviewer_id,
    USERS_REVIEWER.full_name AS reviewer_name,
    USERS_REVIEWER.campus AS reviewer_campus,
    AUTH_USERS_REVIEWER.email AS reviewer_email
FROM REQUESTS
JOIN STUDENTS ON REQUESTS.id_student = STUDENTS.id
JOIN USERS ON STUDENTS.id = USERS.id
JOIN AUTH_USERS ON AUTH_USERS.id = USERS.id
LEFT JOIN ADMINISTRATORS ON REQUESTS.id_reviewed_by = ADMINISTRATORS.id
LEFT JOIN USERS USERS_REVIEWER ON ADMINISTRATORS.id = USERS_REVIEWER.id
LEFT JOIN AUTH_USERS AUTH_USERS_REVIEWER ON AUTH_USERS_REVIEWER.id = USERS_REVIEWER.id;

-- Vista de solicitudes para preview (datos mínimos)
CREATE OR REPLACE VIEW vw_requests_preview AS
SELECT
    REQUESTS.id AS id_request,
    REQUESTS.sent_at,
    REQUESTS.id_student,
    -- Datos básicos del estudiante
    STUDENTS.rut_student,
    USERS.full_name AS student_name,
    -- Estado de revisión
    CASE WHEN REQUESTS.reviewed_at IS NOT NULL THEN 'REVIEWED' ELSE 'PENDING' END AS review_status
FROM REQUESTS
JOIN STUDENTS ON REQUESTS.id_student = STUDENTS.id
JOIN USERS ON STUDENTS.id = USERS.id;

-- Vista de convalidaciones con información completa
CREATE OR REPLACE VIEW vw_convalidations_complete AS
SELECT
    CONVALIDATIONS.id AS id_convalidation,
    CONVALIDATIONS.review_comments,
    CONVALIDATIONS.id_request,
    CONVALIDATIONS.id_convalidation_type,
    CONVALIDATIONS.id_convalidation_state,
    CONVALIDATIONS.id_curriculum_course,
    -- Datos de la solicitud
    REQUESTS.sent_at,
    REQUESTS.reviewed_at,
    REQUESTS.id_student,
    REQUESTS.id_reviewed_by,
    -- Datos del estudiante
    STUDENTS.rol_student,
    STUDENTS.rut_student,
    USERS.full_name AS student_name,
    USERS.campus AS student_campus,
    AUTH_USERS.email AS student_email,
    -- Datos del revisor
    ADMINISTRATORS.id AS reviewer_id,
    USERS_REVIEWER.full_name AS reviewer_name,
    USERS_REVIEWER.campus AS reviewer_campus,
    AUTH_USERS_REVIEWER.email AS reviewer_email,
    -- Datos de tipos y estados
    CONVALIDATION_TYPES.name AS convalidation_type,
    CONVALIDATION_STATES.name AS convalidation_state,
    CURRICULUM_COURSES.name AS curriculum_course,
    CURRICULUM_COURSES_TYPES.name AS curriculum_course_type
FROM CONVALIDATIONS
JOIN REQUESTS ON CONVALIDATIONS.id_request = REQUESTS.id
JOIN STUDENTS ON REQUESTS.id_student = STUDENTS.id
JOIN USERS ON STUDENTS.id = USERS.id
JOIN AUTH_USERS ON AUTH_USERS.id = USERS.id
LEFT JOIN ADMINISTRATORS ON REQUESTS.id_reviewed_by = ADMINISTRATORS.id
LEFT JOIN USERS USERS_REVIEWER ON ADMINISTRATORS.id = USERS_REVIEWER.id
LEFT JOIN AUTH_USERS AUTH_USERS_REVIEWER ON AUTH_USERS_REVIEWER.id = USERS_REVIEWER.id
JOIN CONVALIDATION_TYPES ON CONVALIDATIONS.id_convalidation_type = CONVALIDATION_TYPES.id
JOIN CONVALIDATION_STATES ON CONVALIDATIONS.id_convalidation_state = CONVALIDATION_STATES.id
JOIN CURRICULUM_COURSES ON CONVALIDATIONS.id_curriculum_course = CURRICULUM_COURSES.id
JOIN CURRICULUM_COURSES_TYPES ON CURRICULUM_COURSES.id_curriculum_course_type = CURRICULUM_COURSES_TYPES.id;

-- Vista de convalidaciones para preview (datos mínimos)
CREATE OR REPLACE VIEW vw_convalidations_preview AS
SELECT
    CONVALIDATIONS.id AS id_convalidation,
    CONVALIDATIONS.id_request,
    CONVALIDATIONS.id_convalidation_state,
    -- Datos básicos del estudiante
    STUDENTS.rut_student,
    USERS.full_name AS student_name,
    -- Datos básicos de la convalidación
    CONVALIDATION_TYPES.name AS convalidation_type,
    CONVALIDATION_STATES.name AS convalidation_state,
    CURRICULUM_COURSES.name AS curriculum_course,
    -- Fecha de solicitud
    REQUESTS.sent_at
FROM CONVALIDATIONS
JOIN REQUESTS ON CONVALIDATIONS.id_request = REQUESTS.id
JOIN STUDENTS ON REQUESTS.id_student = STUDENTS.id
JOIN USERS ON STUDENTS.id = USERS.id
JOIN CONVALIDATION_TYPES ON CONVALIDATIONS.id_convalidation_type = CONVALIDATION_TYPES.id
JOIN CONVALIDATION_STATES ON CONVALIDATIONS.id_convalidation_state = CONVALIDATION_STATES.id
JOIN CURRICULUM_COURSES ON CONVALIDATIONS.id_curriculum_course = CURRICULUM_COURSES.id;

-- =============================================================================
-- 6. VISTAS DE CONVALIDACIONES ESPECÍFICAS
-- =============================================================================

-- Vista de convalidaciones por asignaturas
CREATE OR REPLACE VIEW vw_convalidation_subjects AS
SELECT
    vw_convalidations_complete.*,
    CONVALIDATIONS_SUBJECTS.id_subject,
    SUBJECTS.name AS subject_name,
    SUBJECTS.acronym AS subject_acronym,
    SUBJECTS.credits AS subject_credits,
    DEPARTMENTS.name AS department_name
FROM vw_convalidations_complete
JOIN CONVALIDATIONS_SUBJECTS ON vw_convalidations_complete.id_convalidation = CONVALIDATIONS_SUBJECTS.id_convalidation
JOIN SUBJECTS ON CONVALIDATIONS_SUBJECTS.id_subject = SUBJECTS.id
JOIN DEPARTMENTS ON SUBJECTS.id_department = DEPARTMENTS.id;

-- Vista de convalidaciones por talleres
CREATE OR REPLACE VIEW vw_convalidation_workshops AS
SELECT
    vw_convalidations_complete.*,
    CONVALIDATIONS_WORKSHOPS.id_workshop,
    WORKSHOPS.name AS workshop_name,
    WORKSHOPS.semester,
    WORKSHOPS.year,
    PROFESSORS.name AS professor_name
FROM vw_convalidations_complete
JOIN CONVALIDATIONS_WORKSHOPS ON vw_convalidations_complete.id_convalidation = CONVALIDATIONS_WORKSHOPS.id_convalidation
JOIN WORKSHOPS ON CONVALIDATIONS_WORKSHOPS.id_workshop = WORKSHOPS.id
JOIN PROFESSORS ON WORKSHOPS.id_professor = PROFESSORS.id;

-- Vista de convalidaciones por actividades externas
CREATE OR REPLACE VIEW vw_convalidation_external_activities AS
SELECT
    vw_convalidations_complete.*,
    CONVALIDATIONS_EXTERNAL_ACTIVITIES.activity_name,
    CONVALIDATIONS_EXTERNAL_ACTIVITIES.description,
    CONVALIDATIONS_EXTERNAL_ACTIVITIES.file_name,
    CONVALIDATIONS_EXTERNAL_ACTIVITIES.file_data
FROM vw_convalidations_complete
JOIN CONVALIDATIONS_EXTERNAL_ACTIVITIES ON vw_convalidations_complete.id_convalidation = CONVALIDATIONS_EXTERNAL_ACTIVITIES.id_convalidation;

-- =============================================================================
-- 7. VISTAS DE NOTIFICACIONES (OPTIMIZADAS)
-- =============================================================================

-- Vista de notificaciones con información completa
CREATE OR REPLACE VIEW vw_notifications_complete AS
SELECT
    NOTIFICATIONS.id AS id_notification,
    NOTIFICATIONS.id_user,
    NOTIFICATIONS.notification_type,
    NOTIFICATIONS.message,
    NOTIFICATIONS.is_read,
    NOTIFICATIONS.is_sent,
    NOTIFICATIONS.created_at,
    NOTIFICATIONS.read_at,
    NOTIFICATIONS.sent_at,
    -- Datos del usuario
    USERS.full_name AS user_name,
    USERS.campus AS user_campus,
    AUTH_USERS.email AS user_email,
    -- Determinar tipo de usuario
    CASE
        WHEN STUDENTS.id IS NOT NULL THEN 'STUDENT'
        WHEN ADMINISTRATORS.id IS NOT NULL THEN 'ADMINISTRATOR'
        ELSE 'USER'
    END AS user_type,
    -- Tiempo transcurrido
    TIMESTAMPDIFF(MINUTE, NOTIFICATIONS.created_at, NOW()) AS minutes_ago,
    TIMESTAMPDIFF(HOUR, NOTIFICATIONS.created_at, NOW()) AS hours_ago,
    TIMESTAMPDIFF(DAY, NOTIFICATIONS.created_at, NOW()) AS days_ago
FROM NOTIFICATIONS
JOIN USERS ON NOTIFICATIONS.id_user = USERS.id
JOIN AUTH_USERS ON AUTH_USERS.id = USERS.id
LEFT JOIN STUDENTS ON USERS.id = STUDENTS.id
LEFT JOIN ADMINISTRATORS ON USERS.id = ADMINISTRATORS.id;

-- Vista de notificaciones para preview (datos mínimos)
CREATE OR REPLACE VIEW vw_notifications_preview AS
SELECT
    NOTIFICATIONS.id AS id_notification,
    NOTIFICATIONS.id_user,
    NOTIFICATIONS.notification_type,
    NOTIFICATIONS.message,
    NOTIFICATIONS.is_read,
    NOTIFICATIONS.created_at,
    -- Tiempo transcurrido básico
    TIMESTAMPDIFF(MINUTE, NOTIFICATIONS.created_at, NOW()) AS minutes_ago
FROM NOTIFICATIONS;

-- =============================================================================
-- 8. VISTAS DE ESTADÍSTICAS (OPTIMIZADAS)
-- =============================================================================

-- Vista de estadísticas generales
CREATE OR REPLACE VIEW vw_stats_general AS
SELECT
    -- Conteos generales
    (SELECT COUNT(*) FROM STUDENTS) AS total_students,
    (SELECT COUNT(*) FROM ADMINISTRATORS) AS total_admins,
    (SELECT COUNT(*) FROM WORKSHOPS) AS total_workshops,
    (SELECT COUNT(*) FROM REQUESTS) AS total_requests,
    (SELECT COUNT(*) FROM CONVALIDATIONS) AS total_convalidations,
    (SELECT COUNT(*) FROM WORKSHOPS_INSCRIPTIONS) AS total_inscriptions,
    (SELECT COUNT(*) FROM WORKSHOPS_GRADES) AS total_grades,
    -- Conteos por estado
    (SELECT COUNT(*) FROM WORKSHOPS WHERE id_workshop_state = 1) AS workshops_inscription,
    (SELECT COUNT(*) FROM WORKSHOPS WHERE id_workshop_state = 2) AS workshops_in_progress,
    (SELECT COUNT(*) FROM WORKSHOPS WHERE id_workshop_state = 3) AS workshops_finished,
    (SELECT COUNT(*) FROM CONVALIDATIONS WHERE id_convalidation_state = 1) AS convalidations_pending,
    (SELECT COUNT(*) FROM CONVALIDATIONS WHERE id_convalidation_state = 2) AS convalidations_approved,
    (SELECT COUNT(*) FROM CONVALIDATIONS WHERE id_convalidation_state = 3) AS convalidations_rejected;

-- Vista de estadísticas de talleres
CREATE OR REPLACE VIEW vw_stats_workshops AS
SELECT 
    WORKSHOPS.id AS id_workshop,
    WORKSHOPS.name AS workshop_name,
    WORKSHOPS.semester,
    WORKSHOPS.year,
    WORKSHOPS.inscriptions_number,
    WORKSHOPS.limit_inscriptions,
    (WORKSHOPS.limit_inscriptions - WORKSHOPS.inscriptions_number) AS available_slots,
    COUNT(WORKSHOPS_GRADES.id) AS total_grades,
    AVG(WORKSHOPS_GRADES.grade) AS average_grade,
    MIN(WORKSHOPS_GRADES.grade) AS min_grade,
    MAX(WORKSHOPS_GRADES.grade) AS max_grade,
    WORKSHOP_STATES.name AS workshop_state,
    PROFESSORS.name AS professor_name
FROM WORKSHOPS
LEFT JOIN WORKSHOPS_GRADES ON WORKSHOPS.id = WORKSHOPS_GRADES.id_workshop
JOIN WORKSHOP_STATES ON WORKSHOPS.id_workshop_state = WORKSHOP_STATES.id
JOIN PROFESSORS ON WORKSHOPS.id_professor = PROFESSORS.id
GROUP BY WORKSHOPS.id, WORKSHOPS.name, WORKSHOPS.semester, WORKSHOPS.year, WORKSHOPS.inscriptions_number, WORKSHOPS.limit_inscriptions, WORKSHOP_STATES.name, PROFESSORS.name;

-- Vista de estadísticas de convalidaciones
CREATE OR REPLACE VIEW vw_stats_convalidations AS
SELECT
    CONVALIDATION_STATES.name AS convalidation_state,
    CONVALIDATION_TYPES.name AS convalidation_type,
    COUNT(*) AS total_count,
    AVG(TIMESTAMPDIFF(DAY, REQUESTS.sent_at, REQUESTS.reviewed_at)) AS avg_resolution_days
FROM CONVALIDATIONS
JOIN REQUESTS ON CONVALIDATIONS.id_request = REQUESTS.id
JOIN CONVALIDATION_STATES ON CONVALIDATIONS.id_convalidation_state = CONVALIDATION_STATES.id
JOIN CONVALIDATION_TYPES ON CONVALIDATIONS.id_convalidation_type = CONVALIDATION_TYPES.id
WHERE REQUESTS.reviewed_at IS NOT NULL
GROUP BY CONVALIDATION_STATES.name, CONVALIDATION_TYPES.name;

-- =============================================================================
-- 9. VISTAS PARA NUEVAS FUNCIONALIDADES
-- =============================================================================

-- Vista de tokens activos para subida de notas
CREATE OR REPLACE VIEW vw_workshop_tokens_active AS
SELECT 
    WORKSHOPS_TOKENS.id,
    WORKSHOPS_TOKENS.id_workshop,
    WORKSHOPS_TOKENS.token,
    WORKSHOPS_TOKENS.id_professor,
    WORKSHOPS_TOKENS.expiration_at,
    WORKSHOPS_TOKENS.created_at,
    WORKSHOPS_TOKENS.used_at,
    WORKSHOPS_TOKENS.created_by,
    WORKSHOPS_TOKENS.is_used,
    WORKSHOPS.name AS workshop_name,
    PROFESSORS.name AS professor_name,
    PROFESSORS.email AS professor_email,
    USERS.full_name AS created_by_name
FROM WORKSHOPS_TOKENS
JOIN WORKSHOPS ON WORKSHOPS_TOKENS.id_workshop = WORKSHOPS.id
JOIN PROFESSORS ON WORKSHOPS_TOKENS.id_professor = PROFESSORS.id
JOIN ADMINISTRATORS ON WORKSHOPS_TOKENS.created_by = ADMINISTRATORS.id
JOIN USERS ON ADMINISTRATORS.id = USERS.id
WHERE WORKSHOPS_TOKENS.expiration_at > NOW() 
  AND WORKSHOPS_TOKENS.is_used = FALSE;

-- Vista de profesores activos
CREATE OR REPLACE VIEW vw_professors_active AS
SELECT 
    id,
    name,
    email,
    is_active,
    created_at,
    updated_at
FROM PROFESSORS 
WHERE is_active = TRUE;

-- Vista de tokens expirados
CREATE OR REPLACE VIEW vw_workshop_tokens_expired AS
SELECT 
    WORKSHOPS_TOKENS.id,
    WORKSHOPS_TOKENS.id_workshop,
    WORKSHOPS_TOKENS.token,
    WORKSHOPS_TOKENS.id_professor,
    WORKSHOPS_TOKENS.expiration_at,
    WORKSHOPS_TOKENS.created_at,
    WORKSHOPS_TOKENS.used_at,
    WORKSHOPS_TOKENS.is_used,
    WORKSHOPS.name AS workshop_name,
    PROFESSORS.name AS professor_name,
    PROFESSORS.email AS professor_email,
    DATEDIFF(NOW(), WORKSHOPS_TOKENS.expiration_at) AS days_expired
FROM WORKSHOPS_TOKENS
JOIN WORKSHOPS ON WORKSHOPS_TOKENS.id_workshop = WORKSHOPS.id
JOIN PROFESSORS ON WORKSHOPS_TOKENS.id_professor = PROFESSORS.id
WHERE WORKSHOPS_TOKENS.expiration_at <= NOW();

-- =============================================================================
-- 10. VISTAS DE CATÁLOGOS (OPTIMIZADAS)
-- =============================================================================

-- Vista de departamentos
CREATE OR REPLACE VIEW vw_departments AS
SELECT
    id,
    name,
    created_at,
    updated_at
FROM DEPARTMENTS;

-- Vista de asignaturas con departamento
CREATE OR REPLACE VIEW vw_subjects AS
SELECT
    SUBJECTS.id,
    SUBJECTS.acronym,
    SUBJECTS.name,
    SUBJECTS.credits,
    SUBJECTS.id_department,
    DEPARTMENTS.name AS department_name,
    SUBJECTS.created_at,
    SUBJECTS.updated_at
FROM SUBJECTS
JOIN DEPARTMENTS ON SUBJECTS.id_department = DEPARTMENTS.id;

-- Vista de cursos curriculares
CREATE OR REPLACE VIEW vw_curriculum_courses AS
SELECT
    CURRICULUM_COURSES.id,
    CURRICULUM_COURSES.name,
    CURRICULUM_COURSES.id_curriculum_course_type,
    CURRICULUM_COURSES_TYPES.name AS curriculum_course_type,
    CURRICULUM_COURSES.created_at,
    CURRICULUM_COURSES.updated_at
FROM CURRICULUM_COURSES
JOIN CURRICULUM_COURSES_TYPES ON CURRICULUM_COURSES.id_curriculum_course_type = CURRICULUM_COURSES_TYPES.id;

-- Vista de tipos de convalidación
CREATE OR REPLACE VIEW vw_convalidation_types AS
SELECT
    id,
    name,
    created_at,
    updated_at
FROM CONVALIDATION_TYPES;

-- Vista de estados de convalidación
CREATE OR REPLACE VIEW vw_convalidation_states AS
SELECT
    id,
    name,
    created_at,
    updated_at
FROM CONVALIDATION_STATES;

-- Vista de estados de talleres
CREATE OR REPLACE VIEW vw_workshop_states AS
SELECT
    id,
    name,
    description,
    created_at,
    updated_at
FROM WORKSHOP_STATES;

-- Vista de tipos de cursos curriculares
CREATE OR REPLACE VIEW vw_curriculum_course_types AS
SELECT
    id,
    name,
    created_at,
    updated_at
FROM CURRICULUM_COURSES_TYPES;

SELECT "Vistas SQL optimizadas creadas correctamente" AS mensaje;
