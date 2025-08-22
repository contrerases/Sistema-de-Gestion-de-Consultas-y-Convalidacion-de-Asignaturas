-- =============================================================================
-- VISTAS SQL OPTIMIZADAS PARA LA APLICACIÓN WEB
-- =============================================================================


    CREATE OR REPLACE VIEW vw_students AS 
    SELECT
        USERS.id AS id_student,
        USERS.full_name AS student,
        USERS.campus AS student_campus,
        USERS.rol_student,
        USERS.rut_student,
        AUTH_USERS.email AS student_email
    FROM USERS
    JOIN AUTH_USERS ON USERS.id = AUTH_USERS.id
    WHERE USERS.user_type = 'STUDENT';

    CREATE OR REPLACE VIEW vw_administrators AS
    SELECT
        USERS.id AS id_administrator,
        USERS.full_name AS administrator,
        USERS.campus AS administrator_campus,
        AUTH_USERS.email AS administrator_email
    FROM USERS
    JOIN AUTH_USERS ON USERS.id = AUTH_USERS.id
    WHERE USERS.user_type = 'ADMINISTRATOR';
    
-- =============================================================================
-- 2. VISTAS DE TABLAS MAESTRAS
-- =============================================================================

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
    WORKSHOPS.slug,
    PROFESSORS.id AS id_professor,
    PROFESSORS.name AS professor,
    PROFESSORS.email AS professor_email,
    WORKSHOP_STATES.id AS id_workshop_state,
    WORKSHOP_STATES.name AS workshop_state,
    WORKSHOP_STATES.description AS state_description,
    -- Cálculos dinámicos
    (WORKSHOPS.limit_inscriptions - WORKSHOPS.inscriptions_number) AS available_slots
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
    vw_students.rol_student,
    vw_students.rut_student,
    vw_students.student,
    vw_students.student_campus,
    vw_students.student_email,
    -- Datos del revisor (si existe)
    vw_administrators.id_administrator,
    vw_administrators.administrator,
    vw_administrators.administrator_campus,
    vw_administrators.administrator_email
FROM REQUESTS
JOIN vw_students ON REQUESTS.id_student = vw_students.id_student
LEFT JOIN vw_administrators ON REQUESTS.id_reviewed_by = vw_administrators.id_administrator;



CREATE OR REPLACE VIEW vw_convalidations AS
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
    vw_curriculum_courses.curriculum_course,
    vw_curriculum_courses.curriculum_course_type,
    -- Datos de la solicitud
    REQUESTS.sent_at,
    REQUESTS.reviewed_at,
    -- Datos del estudiante
    vw_students.rol_student,
    vw_students.rut_student,
    vw_students.student,
    vw_students.student_campus,
    vw_students.student_email,
    -- Datos del revisor
    vw_administrators.id_administrator,
    vw_administrators.administrator,
    vw_administrators.administrator_campus,
    vw_administrators.administrator_email
FROM CONVALIDATIONS
JOIN CONVALIDATION_TYPES ON CONVALIDATIONS.id_convalidation_type = CONVALIDATION_TYPES.id
JOIN CONVALIDATION_STATES ON CONVALIDATIONS.id_convalidation_state = CONVALIDATION_STATES.id
JOIN vw_curriculum_courses ON CONVALIDATIONS.id_curriculum_course = vw_curriculum_courses.id_curriculum_course
JOIN REQUESTS ON CONVALIDATIONS.id_request = REQUESTS.id
JOIN vw_students ON REQUESTS.id_student = vw_students.id_student
LEFT JOIN vw_administrators ON REQUESTS.id_reviewed_by = vw_administrators.id_administrator;


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


CREATE OR REPLACE VIEW vw_convalidation_external_activities AS
SELECT
    CONVALIDATIONS_EXTERNAL_ACTIVITIES.id_convalidation,
    CONVALIDATIONS_EXTERNAL_ACTIVITIES.activity_name AS activity,
    CONVALIDATIONS_EXTERNAL_ACTIVITIES.description,
    CONVALIDATIONS_EXTERNAL_ACTIVITIES.file_name,
    CONVALIDATIONS_EXTERNAL_ACTIVITIES.file_data
FROM CONVALIDATIONS_EXTERNAL_ACTIVITIES;


CREATE OR REPLACE VIEW vw_workshop_inscriptions AS
SELECT
    WORKSHOPS_INSCRIPTIONS.id AS id_inscription,
    WORKSHOPS_INSCRIPTIONS.id_student,
    WORKSHOPS_INSCRIPTIONS.id_workshop,
    WORKSHOPS_INSCRIPTIONS.is_convalidated,
    WORKSHOPS_INSCRIPTIONS.id_curriculum_course,
    WORKSHOPS_INSCRIPTIONS.inscription_at,
    -- Datos del estudiante
    vw_students.rol_student,
    vw_students.rut_student,
    vw_students.student,
    vw_students.student_campus,
    vw_students.student_email,
    -- Datos del taller
    vw_workshops.workshop,
    vw_workshops.semester,
    vw_workshops.year,
    vw_workshops.inscription_start_date,
    vw_workshops.inscription_end_date,
    vw_workshops.course_start_date,
    vw_workshops.course_end_date,
    vw_workshops.workshop_state,
    -- Datos del curso curricular
    vw_curriculum_courses.curriculum_course,
    vw_curriculum_courses.curriculum_course_type,
    -- Datos del profesor
    vw_workshops.professor,
    vw_workshops.professor_email
FROM WORKSHOPS_INSCRIPTIONS
JOIN vw_students ON WORKSHOPS_INSCRIPTIONS.id_student = vw_students.id_student
JOIN vw_workshops ON WORKSHOPS_INSCRIPTIONS.id_workshop = vw_workshops.id_workshop
LEFT JOIN vw_curriculum_courses ON WORKSHOPS_INSCRIPTIONS.id_curriculum_course = vw_curriculum_courses.id_curriculum_course;


CREATE OR REPLACE VIEW vw_workshop_grades AS
SELECT
    WORKSHOPS_GRADES.id AS id_grade,
    WORKSHOPS_GRADES.id_student,
    WORKSHOPS_GRADES.id_workshop,
    WORKSHOPS_GRADES.grade,
    WORKSHOPS_GRADES.evaluated_at,
    -- Datos del estudiante
    vw_students.rol_student,
    vw_students.rut_student,
    vw_students.student,
    -- Datos de la inscripcion
    vw_workshop_inscriptions.is_convalidated,
    vw_workshop_inscriptions.curriculum_course,
    -- Datos del taller
    vw_workshops.workshop,
    vw_workshops.semester,
    vw_workshops.year,
    vw_workshops.workshop_state,
    -- Datos del profesor
    vw_workshops.professor,
    vw_workshops.professor_email
FROM WORKSHOPS_GRADES
JOIN vw_students ON WORKSHOPS_GRADES.id_student = vw_students.id_student
JOIN vw_workshops ON WORKSHOPS_GRADES.id_workshop = vw_workshops.id_workshop
JOIN vw_workshop_inscriptions ON WORKSHOPS_GRADES.id_workshop = vw_workshop_inscriptions.id_workshop;


CREATE OR REPLACE VIEW vw_professors AS
SELECT
    PROFESSORS.id AS id_professor,
    PROFESSORS.name AS professor,
    PROFESSORS.email AS professor_email
FROM PROFESSORS;

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
    USERS.user_type
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
    vw_workshops.workshop,
    vw_workshops.semester,
    vw_workshops.year,
    -- Datos del profesor
    vw_workshops.professor,
    vw_workshops.professor_email 
FROM WORKSHOPS_TOKENS
JOIN vw_workshops ON WORKSHOPS_TOKENS.id_workshop = vw_workshops.id_workshop;




SELECT "Vistas creadas con éxito" AS mensaje;
