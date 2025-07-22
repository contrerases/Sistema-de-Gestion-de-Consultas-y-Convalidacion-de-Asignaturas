-- =============================================================================
-- VISTAS
-- =============================================================================

-- =============================================================================
-- 1. USERS
-- =============================================================================

CREATE OR REPLACE VIEW vw_students AS
SELECT
    STUDENTS.id AS id_student,
    USERS.common_name AS name_student,
    STUDENTS.rol_student,
    STUDENTS.rut_student,
    USERS.campus AS campus_student,
    AUTH_USERS.email AS email_student
FROM STUDENTS
JOIN USERS ON STUDENTS.id = USERS.id
JOIN AUTH_USERS ON AUTH_USERS.id = USERS.id;

CREATE OR REPLACE VIEW vw_admins AS
SELECT
    ADMINISTRATORS.id AS id_admin,
    USERS.common_name AS name_admin,
    USERS.campus AS campus_admin,
    AUTH_USERS.email AS email_admin,
    AUTH_USERS.password_hash AS password_hash
FROM ADMINISTRATORS
JOIN USERS ON ADMINISTRATORS.id = USERS.id
JOIN AUTH_USERS ON AUTH_USERS.id = USERS.id;

-- =============================================================================
-- 2. GENERALES
-- =============================================================================

CREATE OR REPLACE VIEW vw_subjects AS
SELECT
    SUBJECTS.id AS id_subject,
    SUBJECTS.acronym AS acronym,
    SUBJECTS.name AS subject,
    SUBJECTS.credits,
    DEPARTMENTS.id AS id_department,
    DEPARTMENTS.name AS department
FROM SUBJECTS
JOIN DEPARTMENTS ON SUBJECTS.id_department = DEPARTMENTS.id;

CREATE OR REPLACE VIEW vw_curriculum_courses AS
SELECT
    CURRICULUM_COURSES.id AS id_curriculum_course,
    CURRICULUM_COURSES.name AS curriculum_course,
    CURRICULUM_COURSES_TYPES.id AS id_curriculum_course_type,
    CURRICULUM_COURSES_TYPES.name AS curriculum_course_type
FROM CURRICULUM_COURSES
JOIN CURRICULUM_COURSES_TYPES ON CURRICULUM_COURSES.id_curriculum_course_type = CURRICULUM_COURSES_TYPES.id;

CREATE OR REPLACE VIEW vw_workshops AS
SELECT
    WORKSHOPS.id AS id_workshop,
    WORKSHOPS.name AS workshop,
    WORKSHOPS.semester AS semester,
    WORKSHOPS.year AS year,
    WORKSHOPS.professor AS professor,
    WORKSHOPS.description AS description,
    WORKSHOPS.inscription_start_date AS inscription_start_date,
    WORKSHOPS.inscription_end_date AS inscription_end_date,
    WORKSHOPS.course_start_date AS course_start_date,
    WORKSHOPS.course_end_date AS course_end_date,
    WORKSHOPS.available AS available,
    WORKSHOPS.limit_inscriptions AS limit_inscriptions,
    WORKSHOP_STATES.id AS id_workshop_state,
    WORKSHOP_STATES.name AS workshop_state
FROM WORKSHOPS
JOIN WORKSHOP_STATES ON WORKSHOPS.id_workshop_state = WORKSHOP_STATES.id;

-- =============================================================================
-- 2. CONVALIDACIONES
-- =============================================================================

CREATE OR REPLACE VIEW vw_request AS
SELECT
    REQUESTS.id AS id_request,
    REQUESTS.sent_at,
    REQUESTS.reviewed_at,
    vw_students.id_student,
    vw_students.name_student AS student_name,
    vw_students.rut_student AS student_rut,
    vw_students.rol_student AS student_rol,
    vw_students.campus_student AS student_campus,
    vw_admins.id_admin AS id_reviewed_by,
    vw_admins.name_admin AS reviewed_by
FROM REQUESTS
JOIN vw_students ON REQUESTS.id_student = vw_students.id_student
LEFT JOIN vw_admins ON REQUESTS.id_reviewed_by = vw_admins.id_admin;

CREATE OR REPLACE VIEW vw_convalidations AS
SELECT
    vw_request.*,
    CONVALIDATIONS.id AS id_convalidation,
    CONVALIDATIONS.review_comments,
    CONVALIDATION_TYPES.id AS id_convalidation_type,
    CONVALIDATION_TYPES.name AS convalidation_type,
    CONVALIDATION_STATES.id AS id_convalidation_state,
    CONVALIDATION_STATES.name AS convalidation_state,
    CURRICULUM_COURSES.id AS id_curriculum_course,
    CURRICULUM_COURSES.name AS curriculum_course
FROM CONVALIDATIONS
JOIN CONVALIDATION_TYPES ON CONVALIDATIONS.id_convalidation_type = CONVALIDATION_TYPES.id
JOIN CONVALIDATION_STATES ON CONVALIDATIONS.id_convalidation_state = CONVALIDATION_STATES.id
JOIN CURRICULUM_COURSES ON CONVALIDATIONS.id_curriculum_course = CURRICULUM_COURSES.id
JOIN vw_request ON CONVALIDATIONS.id_request = vw_request.id_request;

CREATE OR REPLACE VIEW vw_convalidation_subjects AS
SELECT
    vw_convalidations.*,
    CONVALIDATIONS_SUBJECTS.id_subject,
    SUBJECTS.name AS subject,
    DEPARTMENTS.name AS department
FROM CONVALIDATIONS_SUBJECTS
JOIN vw_convalidations ON CONVALIDATIONS_SUBJECTS.id_convalidation = vw_convalidations.id_convalidation
JOIN SUBJECTS ON CONVALIDATIONS_SUBJECTS.id_subject = SUBJECTS.id
JOIN DEPARTMENTS ON SUBJECTS.id_department = DEPARTMENTS.id;

CREATE OR REPLACE VIEW vw_convalidation_workshops AS
SELECT
    vw_convalidations.*,
    WORKSHOPS.id AS id_workshop,
    WORKSHOPS.name AS workshop,
    WORKSHOPS.semester,
    WORKSHOPS.year
FROM CONVALIDATIONS_WORKSHOPS
JOIN vw_convalidations ON CONVALIDATIONS_WORKSHOPS.id_convalidation = vw_convalidations.id_convalidation
JOIN WORKSHOPS ON CONVALIDATIONS_WORKSHOPS.id_workshop = WORKSHOPS.id;

CREATE OR REPLACE VIEW vw_convalidation_external_activities AS
SELECT
    vw_convalidations.*,
    CONVALIDATIONS_EXTERNAL_ACTIVITIES.activity_name,
    CONVALIDATIONS_EXTERNAL_ACTIVITIES.description,
    CONVALIDATIONS_EXTERNAL_ACTIVITIES.file_name,
    CONVALIDATIONS_EXTERNAL_ACTIVITIES.file_data
FROM CONVALIDATIONS_EXTERNAL_ACTIVITIES
JOIN vw_convalidations ON CONVALIDATIONS_EXTERNAL_ACTIVITIES.id_convalidation = vw_convalidations.id_convalidation;

-- =============================================================================
-- 3. TALLERES
-- =============================================================================

CREATE OR REPLACE VIEW vw_workshops_inscriptions AS
SELECT
    vw_students.id_student,
    vw_students.rut_student,
    WORKSHOPS_INSCRIPTIONS.id_workshop,
    WORKSHOPS.name AS workshop,
    WORKSHOPS.semester,
    WORKSHOPS.year,
    WORKSHOPS_INSCRIPTIONS.is_convalidated,
    WORKSHOPS_INSCRIPTIONS.id_curriculum_course,
    CURRICULUM_COURSES.name AS curriculum_course
FROM WORKSHOPS_INSCRIPTIONS
JOIN vw_students ON WORKSHOPS_INSCRIPTIONS.id_student = vw_students.id_student
JOIN WORKSHOPS ON WORKSHOPS_INSCRIPTIONS.id_workshop = WORKSHOPS.id
LEFT JOIN CURRICULUM_COURSES ON WORKSHOPS_INSCRIPTIONS.id_curriculum_course = CURRICULUM_COURSES.id;

CREATE OR REPLACE VIEW vw_workshops_grades AS
SELECT
    vw_students.id_student,
    vw_students.rut_student,
    WORKSHOPS_GRADES.id_workshop,
    WORKSHOPS.name AS workshop,
    WORKSHOPS.semester,
    WORKSHOPS.year,
    WORKSHOPS_GRADES.grade
FROM WORKSHOPS_GRADES
JOIN vw_students ON WORKSHOPS_GRADES.id_student = vw_students.id_student
JOIN WORKSHOPS ON WORKSHOPS_GRADES.id_workshop = WORKSHOPS.id;

-- =============================================================================
-- 4. USERS
-- =============================================================================

CREATE OR REPLACE VIEW vw_students AS
SELECT
    STUDENTS.id AS id_student,
    USERS.common_name AS name_student,
    STUDENTS.rol_student,
    STUDENTS.rut_student,
    USERS.campus AS campus_student,
    AUTH_USERS.email AS email_student
FROM STUDENTS
JOIN USERS ON STUDENTS.id = USERS.id
JOIN AUTH_USERS ON AUTH_USERS.id = USERS.id;

CREATE OR REPLACE VIEW vw_admins AS
SELECT
    ADMINISTRATORS.id AS id_admin,
    USERS.common_name AS name_admin,
    USERS.campus AS campus_admin,
    AUTH_USERS.email AS email_admin
FROM ADMINISTRATORS
JOIN USERS ON ADMINISTRATORS.id = USERS.id
JOIN AUTH_USERS ON AUTH_USERS.id = USERS.id;

-- =============================================================================
-- 5. AUTH
-- =============================================================================

CREATE OR REPLACE VIEW vw_auth_users AS
SELECT
    AUTH_USERS.id AS id_auth_user,
    AUTH_USERS.email,
    AUTH_USERS.password_hash,
    USERS.id AS id_user,
    USERS.first_names,
    USERS.last_names,
    USERS.common_name,
    USERS.full_name,
    USERS.campus,
    -- Determinar tipo de usuario
    CASE
        WHEN STUDENTS.id IS NOT NULL THEN 'STUDENT'
        WHEN ADMINISTRATORS.id IS NOT NULL THEN 'ADMINISTRATOR'
        ELSE 'USER'
    END AS user_type,
    -- Datos específicos de estudiante
    STUDENTS.id AS id_student,
    STUDENTS.rol_student,
    STUDENTS.rut_student,
    STUDENTS.campus_student,
    -- Datos específicos de administrador
    ADMINISTRATORS.id AS id_admin
FROM AUTH_USERS
JOIN USERS ON AUTH_USERS.id = USERS.id
LEFT JOIN STUDENTS ON USERS.id = STUDENTS.id
LEFT JOIN ADMINISTRATORS ON USERS.id = ADMINISTRATORS.id;

-- =============================================================================
-- 6. NOTIFICACIONES
-- =============================================================================

CREATE OR REPLACE VIEW vw_notifications_detailed AS
SELECT
    NOTIFICATIONS.id AS id_notification,
    NOTIFICATIONS.id_user as id_auth_user, 
    NOTIFICATIONS.notification_type,
    NOTIFICATIONS.message,
    NOTIFICATIONS.created_at,
    NOTIFICATIONS.read_at,
    NOTIFICATIONS.sent_at,
    -- Determinar tipo de usuario que recibe la notificación
    CASE
        WHEN STUDENTS.id IS NOT NULL THEN 'STUDENT'
        WHEN ADMINISTRATORS.id IS NOT NULL THEN 'ADMINISTRATOR'
        ELSE 'USER'
    END AS user_type,
    -- Calcular tiempo transcurrido
    TIMESTAMPDIFF(MINUTE, NOTIFICATIONS.created_at, NOW()) AS minutes_ago,
    TIMESTAMPDIFF(HOUR, NOTIFICATIONS.created_at, NOW()) AS hours_ago,
    TIMESTAMPDIFF(DAY, NOTIFICATIONS.created_at, NOW()) AS days_ago
FROM NOTIFICATIONS
JOIN USERS ON NOTIFICATIONS.id_user = USERS.id
LEFT JOIN STUDENTS ON USERS.id = STUDENTS.id
LEFT JOIN ADMINISTRATORS ON USERS.id = ADMINISTRATORS.id;



CREATE OR REPLACE VIEW vw_notifications_user_label AS
SELECT
    NOTIFICATIONS.id AS id_notification,
    USERS.id AS id_user,
    USERS.common_name AS user,
    NOTIFICATIONS.notification_type,
    NOTIFICATIONS.message,
    NOTIFICATIONS.is_read AS is_read,
    NOTIFICATIONS.is_sent AS is_sent,
    NOTIFICATIONS.created_at AS created_at,
    NOTIFICATIONS.read_at AS read_at,
    NOTIFICATIONS.sent_at AS sent_at
FROM NOTIFICATIONS
JOIN USERS ON NOTIFICATIONS.id_user = USERS.id
LEFT JOIN STUDENTS ON USERS.id = STUDENTS.id
LEFT JOIN ADMINISTRATORS ON USERS.id = ADMINISTRATORS.id;

-- =============================================================================
-- CURSOS CURRICULARES NO CONVALIDADOS POR ESTUDIANTE
-- =============================================================================
CREATE OR REPLACE VIEW vw_curriculum_courses_not_convalidated_by_student AS
SELECT
    CURRICULUM_COURSES.id AS id_curriculum_course,
    CURRICULUM_COURSES.name AS curriculum_course,
    CURRICULUM_COURSES.id_curriculum_course_type,
    CURRICULUM_COURSES_TYPES.name AS curriculum_course_type
FROM STUDENTS
CROSS JOIN CURRICULUM_COURSES
JOIN CURRICULUM_COURSES_TYPES
  ON CURRICULUM_COURSES.id_curriculum_course_type = CURRICULUM_COURSES_TYPES.id
WHERE CURRICULUM_COURSES.id NOT IN (
    SELECT vw_convalidations.id_curriculum_course
    FROM vw_convalidations
    WHERE vw_convalidations.id_student = STUDENTS.id
);


SELECT "Vistas creadas correctamente" AS mensaje;
