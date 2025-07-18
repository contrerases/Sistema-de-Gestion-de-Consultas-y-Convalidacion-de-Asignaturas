--------------------------------------------------------------------------------------------------------
---------------------------------- VISTAS DE LA BASE DE DATOS ------------------------------------------
--------------------------------------------------------------------------------------------------------

-- =====================================================================================
-- Vista: vw_students_basic
-- Descripción: Información básica de estudiantes para listados y búsquedas
-- =====================================================================================
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
LEFT JOIN AUTH_USERS ON AUTH_USERS.id = USERS.id;

-- =====================================================================================
-- Vista: vw_admins_basic
-- Descripción: Información básica de administradores para gestión y reportes
-- =====================================================================================
CREATE OR REPLACE VIEW vw_admins AS
SELECT
    ADMINISTRATORS.id AS id_admin,
    USERS.common_name AS name_admin,
    USERS.campus AS campus_admin,
    AUTH_USERS.email AS email_admin
FROM ADMINISTRATORS
JOIN USERS ON ADMINISTRATORS.id = USERS.id
JOIN AUTH_USERS ON AUTH_USERS.id = USERS.id;


-- =====================================================================================
-- Vista: vw_subjects_full
-- Descripción: Asignaturas con datos de departamento
-- =====================================================================================
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

-- =====================================================================================
-- Vista: vw_curriculum_courses_full
-- Descripción: Cursos del currículum con datos de tipo
-- =====================================================================================

CREATE OR REPLACE VIEW vw_curriculum_courses AS
SELECT
    CURRICULUM_COURSES.id AS id_curriculum_course,
    CURRICULUM_COURSES.name AS curriculum_course,
    CURRICULUM_COURSES_TYPES.id AS id_curriculum_course_type,
    CURRICULUM_COURSES_TYPES.name AS curriculum_course_type
FROM CURRICULUM_COURSES
JOIN CURRICULUM_COURSES_TYPES ON CURRICULUM_COURSES.id_curriculum_course_type = CURRICULUM_COURSES_TYPES.id;

-- =====================================================================================
-- Vista: vw_workshops_full
-- Descripción: Talleres con estado, fechas, profesor y cantidad de inscritos
-- =====================================================================================
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
    WORKSHOP_STATES.id AS id_workshop_state,
    WORKSHOP_STATES.name AS workshop_state
FROM WORKSHOPS
JOIN WORKSHOP_STATES ON WORKSHOPS.id_workshop_state = WORKSHOP_STATES.id;




-- =====================================================================================
-- Vista: vw_requests_full
-- Descripción: Solicitudes con datos de estudiante, estado y revisor
-- =====================================================================================
CREATE OR REPLACE VIEW vw_requests_full AS
SELECT
    REQUESTS.id AS id_request,
    REQUESTS.sent_at,
    REQUESTS.reviewed_at,
    REQUESTS.review_comments,
    vw_students.id_student,
    vw_students.name_student,
    vw_students.rol_student,
    vw_students.rut_student,
    vw_students.campus_student,
    vw_admins.id_admin AS id_admin_reviewer,
    vw_admins.name_admin,
    vw_admins.campus_admin
FROM REQUESTS
JOIN vw_students ON REQUESTS.id_student = vw_students.id_student
LEFT JOIN vw_admins ON REQUESTS.id_reviewed_by = vw_admins.id_admin;

-- =====================================================================================
-- Vista: vw_request_label
-- Descripción: Etiqueta simple para solicitudes (id y nombre de estudiante)
-- =====================================================================================
CREATE OR REPLACE VIEW vw_request_label AS
SELECT
    REQUESTS.id AS id_request,
    vw_students.name_student AS student_name,
    vw_students.rut_student AS student_rut,
    vw_students.rol_student AS student_rol,
    vw_students.campus_student AS student_campus,
    vw_admins.name_admin AS admin_name,
    REQUESTS.sent_at,
    REQUESTS.reviewed_at,
FROM REQUESTS
JOIN vw_students ON REQUESTS.id_student = vw_students.id_student
LEFT JOIN vw_admins ON REQUESTS.id_reviewed_by = vw_admins.id_admin;


-- =====================================================================================
-- Vista: vw_convalidations_full
-- Descripción: Convalidaciones con tipo, estado, curso, estudiante y solicitud
-- =====================================================================================
CREATE OR REPLACE VIEW vw_convalidations_full AS
SELECT
    CONVALIDATIONS.id AS id_convalidation,
    CONVALIDATIONS.id_request,
    CONVALIDATION_TYPES.id AS id_convalidation_type,
    CONVALIDATION_TYPES.name AS convalidation_type,
    CONVALIDATION_STATES.id AS id_convalidation_state,
    CONVALIDATION_STATES.name AS convalidation_state,
    CURRICULUM_COURSES.id AS id_curriculum_course,
    CURRICULUM_COURSES.name AS curriculum_course,
    CONVALIDATIONS.review_comments
FROM CONVALIDATIONS
JOIN CONVALIDATION_TYPES ON CONVALIDATIONS.id_convalidation_type = CONVALIDATION_TYPES.id
JOIN CONVALIDATION_STATES ON CONVALIDATIONS.id_convalidation_state = CONVALIDATION_STATES.id
JOIN CURRICULUM_COURSES ON CONVALIDATIONS.id_curriculum_course = CURRICULUM_COURSES.id;

-- =====================================================================================
-- Vista: vw_convalidations_label
-- Descripción: Etiqueta simple para convalidaciones (id y nombre de estudiante)
-- =====================================================================================

CREATE OR REPLACE VIEW vw_convalidations_label AS
SELECT
    CONVALIDATIONS.review_comments,
    CONVALIDATIONS.id AS id_convalidation,
    CONVALIDATION_TYPES.name AS convalidation_type,
    CONVALIDATION_STATES.name AS convalidation_state,
    CURRICULUM_COURSES.name AS curriculum_course,
FROM CONVALIDATIONS
JOIN CONVALIDATION_TYPES ON CONVALIDATIONS.id_convalidation_type = CONVALIDATION_TYPES.id
JOIN CONVALIDATION_STATES ON CONVALIDATIONS.id_convalidation_state = CONVALIDATION_STATES.id
JOIN CURRICULUM_COURSES ON CONVALIDATIONS.id_curriculum_course = CURRICULUM_COURSES.id;


-- =====================================================================================
-- Vista: vw_convalidation_subjects
-- Descripción: Asignaturas de convalidaciones
-- =====================================================================================
CREATE OR REPLACE VIEW vw_convalidation_subjects_full AS
SELECT
    vw_convalidations_full.id_convalidation,
    vw_convalidations_full.id_request,
    vw_convalidations_full.id_convalidation_type,
    vw_convalidations_full.convalidation_type,
    vw_convalidations_full.id_convalidation_state,
    vw_convalidations_full.convalidation_state,
    vw_convalidations_full.id_curriculum_course,
    vw_convalidations_full.curriculum_course,
    SUBJECTS.id AS id_subject,
    SUBJECTS.name AS subject,
    DEPARTMENTS.name AS department,
    vw_convalidations_full.review_comments
FROM CONVALIDATIONS_SUBJECTS
JOIN vw_convalidations_full ON CONVALIDATIONS_SUBJECTS.id_convalidation = vw_convalidations_full.id_convalidation
JOIN SUBJECTS ON CONVALIDATIONS_SUBJECTS.id_subject = SUBJECTS.id
JOIN DEPARTMENTS ON SUBJECTS.id_department = DEPARTMENTS.id;

-- =====================================================================================
-- Vista: vw_convalidation_subjects_label
-- Descripción: Etiqueta simple para asignaturas de convalidaciones
-- =====================================================================================

CREATE OR REPLACE VIEW vw_convalidation_subjects_label AS
SELECT
    vw_convalidations_label.review_comments,
    vw_convalidations_label.convalidation_type,
    vw_convalidations_label.convalidation_state,
    vw_convalidations_label.curriculum_course,
    SUBJECTS.name AS subject,
    DEPARTMENTS.name AS department
FROM CONVALIDATIONS_SUBJECTS
JOIN vw_convalidations_label ON CONVALIDATIONS_SUBJECTS.id_convalidation = vw_convalidations_label.id_convalidation
JOIN SUBJECTS ON CONVALIDATIONS_SUBJECTS.id_subject = SUBJECTS.id
JOIN DEPARTMENTS ON SUBJECTS.id_department = DEPARTMENTS.id;

-- =====================================================================================
-- Vista: vw_convalidation_workshops_full
-- Descripción: Talleres de convalidaciones
-- =====================================================================================

CREATE OR REPLACE VIEW vw_convalidation_workshops_full AS
SELECT
    vw_convalidations_full.id_convalidation,
    vw_convalidations_full.id_request,
    vw_convalidations_full.id_convalidation_type,
    vw_convalidations_full.convalidation_type,
    vw_convalidations_full.id_convalidation_state,
    vw_convalidations_full.convalidation_state,
    vw_convalidations_full.id_curriculum_course,
    vw_convalidations_full.curriculum_course,
    WORKSHOPS.id AS id_workshop,
    WORKSHOPS.name AS workshop,
    WORKSHOPS.semester,
    WORKSHOPS.year,
    vw_convalidations_full.review_comments
FROM CONVALIDATIONS_WORKSHOPS
JOIN vw_convalidations_full ON CONVALIDATIONS_WORKSHOPS.id_convalidation = vw_convalidations_full.id_convalidation
JOIN WORKSHOPS ON CONVALIDATIONS_WORKSHOPS.id_workshop = WORKSHOPS.id;

-- =====================================================================================
-- Vista: vw_convalidation_workshops_label
-- Descripción: Etiqueta simple para talleres de convalidaciones
-- =====================================================================================

CREATE OR REPLACE VIEW vw_convalidation_workshops_label AS
SELECT
    vw_convalidations_label.review_comments,
    vw_convalidations_label.convalidation_type,
    vw_convalidations_label.convalidation_state,
    vw_convalidations_label.curriculum_course,
    WORKSHOPS.name AS workshop
FROM CONVALIDATIONS_WORKSHOPS
JOIN vw_convalidations_label ON CONVALIDATIONS_WORKSHOPS.id_convalidation = vw_convalidations_label.id_convalidation
JOIN WORKSHOPS ON CONVALIDATIONS_WORKSHOPS.id_workshop = WORKSHOPS.id;

-- =====================================================================================
-- Vista: vw_convalidation_certificated_courses_full
-- Descripción: Cursos certificados de convalidaciones
-- =====================================================================================

CREATE OR REPLACE VIEW vw_convalidation_certificated_courses_full AS
SELECT
    vw_convalidations_full.id_convalidation,
    vw_convalidations_full.id_request,
    vw_convalidations_full.id_convalidation_type,
    vw_convalidations_full.convalidation_type,
    vw_convalidations_full.id_convalidation_state,
    vw_convalidations_full.convalidation_state,
    vw_convalidations_full.id_curriculum_course,
    vw_convalidations_full.curriculum_course,
    CONVALIDATIONS_CERTIFICATED_COURSES.name AS certified_course,
    CONVALIDATIONS_CERTIFICATED_COURSES.file_name,
    CONVALIDATIONS_CERTIFICATED_COURSES.file_data,
    vw_convalidations_full.review_comments
FROM CONVALIDATIONS_CERTIFICATED_COURSES
JOIN vw_convalidations_full ON CONVALIDATIONS_CERTIFICATED_COURSES.id_convalidation = vw_convalidations_full.id_convalidation;

-- =====================================================================================
-- Vista: vw_convalidation_certificated_courses_label
-- Descripción: Etiqueta simple para cursos certificados de convalidaciones
-- =====================================================================================

CREATE OR REPLACE VIEW vw_convalidation_certificated_courses_label AS
SELECT
    vw_convalidations_label.review_comments,
    vw_convalidations_label.convalidation_type,
    vw_convalidations_label.convalidation_state,
    vw_convalidations_label.curriculum_course,
    CONVALIDATIONS_CERTIFICATED_COURSES.name AS certificated_course,
    CONVALIDATIONS_CERTIFICATED_COURSES.file_data,
    CONVALIDATIONS_CERTIFICATED_COURSES.file_name
FROM CONVALIDATIONS_CERTIFICATED_COURSES
JOIN vw_convalidations_label ON CONVALIDATIONS_CERTIFICATED_COURSES.id_convalidation = vw_convalidations_label.id_convalidation;

-- =====================================================================================
-- Vista: vw_convalidation_personal_projects_full
-- Descripción: Proyectos personales de convalidaciones
-- =====================================================================================

CREATE OR REPLACE VIEW vw_convalidation_personal_projects_full AS
SELECT
    vw_convalidations_full.id_convalidation,
    vw_convalidations_full.id_request,
    vw_convalidations_full.id_convalidation_type,
    vw_convalidations_full.convalidation_type,
    vw_convalidations_full.id_convalidation_state,
    vw_convalidations_full.convalidation_state,
    vw_convalidations_full.id_curriculum_course,
    vw_convalidations_full.curriculum_course,
    CONVALIDATIONS_PERSONAL_PROJECTS.name AS personal_project,
    CONVALIDATIONS_PERSONAL_PROJECTS.file_data,
    CONVALIDATIONS_PERSONAL_PROJECTS.file_name,
    vw_convalidations_full.review_comments
FROM CONVALIDATIONS_PERSONAL_PROJECTS
JOIN vw_convalidations_full ON CONVALIDATIONS_PERSONAL_PROJECTS.id_convalidation = vw_convalidations_full.id_convalidation;

-- =====================================================================================
-- Vista: vw_convalidation_personal_projects_label
-- Descripción: Etiqueta simple para proyectos personales de convalidaciones
-- =====================================================================================

CREATE OR REPLACE VIEW vw_convalidation_personal_projects_label AS
SELECT
    vw_convalidations_label.review_comments,
    vw_convalidations_label.convalidation_type,
    vw_convalidations_label.convalidation_state,
    vw_convalidations_label.curriculum_course,
    CONVALIDATIONS_PERSONAL_PROJECTS.name AS personal_project,
    CONVALIDATIONS_PERSONAL_PROJECTS.file_data,
    CONVALIDATIONS_PERSONAL_PROJECTS.file_name
FROM CONVALIDATIONS_PERSONAL_PROJECTS
JOIN vw_convalidations_label ON CONVALIDATIONS_PERSONAL_PROJECTS.id_convalidation = vw_convalidations_label.id_convalidation;

-- =====================================================================================
-- Vista: vw_workshops_inscriptions
-- Descripción: Inscripciones a talleres con datos de estudiante y taller
-- =====================================================================================
CREATE OR REPLACE VIEW vw_workshops_inscriptions AS
SELECT
    vw_students.id_student,
    vw_students.name_student,
    vw_students.rut_student,
    vw_students.campus_student,
    vw_students.rol_student,
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
JOIN CURRICULUM_COURSES ON WORKSHOPS_INSCRIPTIONS.id_curriculum_course = CURRICULUM_COURSES.id;

-- =====================================================================================
-- Vista: vw_workshops_grades
-- Descripción: Calificaciones de talleres con datos de estudiante y taller
-- =====================================================================================
CREATE OR REPLACE VIEW vw_workshops_grades AS
SELECT
    vw_students.id_student,
    vw_students.name_student,
    vw_students.rut_student,
    vw_students.rol_student,
    vw_students.campus_student,
    WORKSHOPS_GRADES.id_workshop,
    WORKSHOPS.name AS workshop,
    WORKSHOPS.semester,
    WORKSHOPS.year,
    WORKSHOPS_GRADES.grade
FROM WORKSHOPS_GRADES
JOIN vw_students ON WORKSHOPS_GRADES.id_student = vw_students.id_student
JOIN WORKSHOPS ON WORKSHOPS_GRADES.id_workshop = WORKSHOPS.id;



-- =====================================================================================
-- Vista: vw_audit_log_label
-- Descripción: Log de auditoría con usuario, acción, tabla y campo
-- =====================================================================================

CREATE OR REPLACE VIEW vw_audit_log_label AS
SELECT
    USERS.id AS id_user,
    USERS.common_name AS user,
    AUDIT_LOG.id AS id_audit_log,
    AUDIT_LOG.id_record,
    AUDIT_ACTIONS.name AS action_name,
    AUDIT_TABLES.name AS table,
    AUDIT_FIELDS.name AS field,
    AUDIT_LOG.timestamp,
    AUDIT_LOG.old_value,
    AUDIT_LOG.new_value
FROM AUDIT_LOG
JOIN AUDIT_ACTIONS ON AUDIT_LOG.id_audit_action = AUDIT_ACTIONS.id
JOIN AUDIT_TABLES ON AUDIT_LOG.id_audit_table = AUDIT_TABLES.id
JOIN AUDIT_FIELDS ON AUDIT_LOG.id_audit_field = AUDIT_FIELDS.id
JOIN USERS ON AUDIT_LOG.id_user = USERS.id;


-- =====================================================================================
-- Vista: vw_notifications_user_label
-- Descripción: Notificaciones de usuario con tipo y estado de lectura
-- =====================================================================================
CREATE OR REPLACE VIEW vw_notifications_user_label AS
SELECT
    NOTIFICATIONS.id AS id_notification,
    USERS.id AS id_user,
    USERS.common_name AS user,
    NOTIFICATION_TYPES.id AS id_notification_type,
    NOTIFICATION_TYPES.name AS notification_type,
    NOTIFICATIONS.title,
    NOTIFICATIONS.message,
    NOTIFICATIONS.is_read AS is_read,
    NOTIFICATIONS.is_sent AS is_sent,
    NOTIFICATIONS.created_at AS created_at,
    NOTIFICATIONS.read_at AS read_at,
    NOTIFICATIONS.sent_at AS sent_at
FROM NOTIFICATIONS
JOIN USERS ON NOTIFICATIONS.id_user = USERS.id
JOIN NOTIFICATION_TYPES ON NOTIFICATIONS.id_notification_type = NOTIFICATION_TYPES.id;
