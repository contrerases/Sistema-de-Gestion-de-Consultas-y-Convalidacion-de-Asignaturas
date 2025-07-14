--------------------------------------------------------------------------------------------------------
---------------------------------- CLAVES FORÁNEAS DE LA BASE DE DATOS ----------------------------------
--------------------------------------------------------------------------------------------------------

-- =============================================================================
-- RESUMEN DE CLAVES FORÁNEAS
-- =============================================================================
-- Total de foreign keys: 21
-- CURRICULUM_COURSES: 1 | SUBJECTS: 1 | WORKSHOPS: 1 | REQUESTS: 2 | CONVALIDATIONS: 3
-- CONVALIDATIONS_SUBJECTS: 2 | CONVALIDATIONS_WORKSHOPS: 2 | CONVALIDATIONS_CERTIFIED_COURSES: 1
-- CONVALIDATIONS_PERSONAL_PROJECTS: 1 | WORKSHOPS_INSCRIPTIONS: 3 | WORKSHOPS_GRADES: 2
-- USER_SESSIONS: 1 | AUDIT_LOG: 4 | NOTIFICATIONS: 2

-- =============================================================================
-- CONFIGURACIÓN INICIAL
-- =============================================================================

SET FOREIGN_KEY_CHECKS = 0;

-- =============================================================================
-- CURRICULUM_COURSES
-- =============================================================================

-- Relación con tipos de cursos curriculares
ALTER TABLE CURRICULUM_COURSES
ADD CONSTRAINT fk_curriculum_course_type
FOREIGN KEY (id_type_curriculum_course)
REFERENCES TYPES_CURRICULUM_COURSES (id)
ON DELETE RESTRICT
ON UPDATE CASCADE;

-- =============================================================================
-- SUBJECTS
-- =============================================================================

-- Relación con departamentos
ALTER TABLE SUBJECTS
ADD CONSTRAINT fk_subject_department
FOREIGN KEY (id_department)
REFERENCES DEPARTMENTS (id)
ON DELETE RESTRICT
ON UPDATE CASCADE;

-- =============================================================================
-- WORKSHOPS
-- =============================================================================

-- Relación con estados de taller
ALTER TABLE WORKSHOPS
ADD CONSTRAINT fk_workshop_state
FOREIGN KEY (id_workshop_state)
REFERENCES WORKSHOP_STATES (id)
ON DELETE RESTRICT
ON UPDATE CASCADE;

-- =============================================================================
-- REQUESTS
-- =============================================================================

-- Relación con estudiantes
ALTER TABLE REQUESTS
ADD CONSTRAINT fk_request_student
FOREIGN KEY (id_student)
REFERENCES STUDENTS (id)
ON DELETE CASCADE
ON UPDATE CASCADE;

-- Relación con administradores (revisor)
ALTER TABLE REQUESTS
ADD CONSTRAINT fk_request_reviewed_by
FOREIGN KEY (id_reviewed_by)
REFERENCES ADMINISTRATORS (id)
ON DELETE SET NULL
ON UPDATE CASCADE;

-- =============================================================================
-- CONVALIDATIONS
-- =============================================================================

-- Relación con solicitudes
ALTER TABLE CONVALIDATIONS
ADD CONSTRAINT fk_convalidation_request
FOREIGN KEY (id_request)
REFERENCES REQUESTS (id)
ON DELETE CASCADE
ON UPDATE CASCADE;

-- Relación con tipos de convalidación
ALTER TABLE CONVALIDATIONS
ADD CONSTRAINT fk_convalidation_type
FOREIGN KEY (id_convalidation_type)
REFERENCES TYPES_CONVALIDATIONS (id)
ON DELETE RESTRICT
ON UPDATE CASCADE;

-- Relación con estados de convalidación
ALTER TABLE CONVALIDATIONS
ADD CONSTRAINT fk_convalidation_state
FOREIGN KEY (id_convalidation_state)
REFERENCES CONVALIDATION_STATES (id)
ON DELETE RESTRICT
ON UPDATE CASCADE;

-- Relación con cursos curriculares
ALTER TABLE CONVALIDATIONS
ADD CONSTRAINT fk_convalidation_curriculum
FOREIGN KEY (id_curriculum_course)
REFERENCES CURRICULUM_COURSES (id)
ON DELETE RESTRICT
ON UPDATE CASCADE;

-- =============================================================================
-- CONVALIDATIONS_SUBJECTS
-- =============================================================================

-- Relación con convalidaciones
ALTER TABLE CONVALIDATIONS_SUBJECTS
ADD CONSTRAINT fk_convalidation_subject_convalidation
FOREIGN KEY (id_convalidation)
REFERENCES CONVALIDATIONS(id)
ON DELETE CASCADE
ON UPDATE CASCADE;

-- Relación con asignaturas
ALTER TABLE CONVALIDATIONS_SUBJECTS
ADD CONSTRAINT fk_convalidation_subject
FOREIGN KEY (id_subject)
REFERENCES SUBJECTS(id)
ON DELETE RESTRICT
ON UPDATE CASCADE;

-- =============================================================================
-- CONVALIDATIONS_WORKSHOPS
-- =============================================================================

-- Relación con convalidaciones
ALTER TABLE CONVALIDATIONS_WORKSHOPS
ADD CONSTRAINT fk_convalidation_workshop_convalidation
FOREIGN KEY (id_convalidation)
REFERENCES CONVALIDATIONS(id)
ON DELETE CASCADE
ON UPDATE CASCADE;

-- Relación con talleres
ALTER TABLE CONVALIDATIONS_WORKSHOPS
ADD CONSTRAINT fk_convalidation_workshop
FOREIGN KEY (id_workshop)
REFERENCES WORKSHOPS(id)
ON DELETE RESTRICT
ON UPDATE CASCADE;

-- =============================================================================
-- CONVALIDATIONS_CERTIFIED_COURSES
-- =============================================================================

-- Relación con convalidaciones
ALTER TABLE CONVALIDATIONS_CERTIFIED_COURSES
ADD CONSTRAINT fk_convalidation_certified_course_convalidation
FOREIGN KEY (id_convalidation)
REFERENCES CONVALIDATIONS(id)
ON DELETE CASCADE
ON UPDATE CASCADE;

-- =============================================================================
-- CONVALIDATIONS_PERSONAL_PROJECTS
-- =============================================================================

-- Relación con convalidaciones
ALTER TABLE CONVALIDATIONS_PERSONAL_PROJECTS
ADD CONSTRAINT fk_convalidation_personal_project_convalidation
FOREIGN KEY (id_convalidation)
REFERENCES CONVALIDATIONS(id)
ON DELETE CASCADE
ON UPDATE CASCADE;

-- =============================================================================
-- WORKSHOPS_INSCRIPTIONS
-- =============================================================================

-- Relación con estudiantes
ALTER TABLE WORKSHOPS_INSCRIPTIONS
ADD CONSTRAINT fk_inscription_student
FOREIGN KEY (id_student)
REFERENCES STUDENTS (id)
ON DELETE CASCADE
ON UPDATE CASCADE;

-- Relación con talleres
ALTER TABLE WORKSHOPS_INSCRIPTIONS
ADD CONSTRAINT fk_inscription_workshop
FOREIGN KEY (id_workshop)
REFERENCES WORKSHOPS (id)
ON DELETE CASCADE
ON UPDATE CASCADE;

-- Relación con cursos curriculares (opcional)
ALTER TABLE WORKSHOPS_INSCRIPTIONS
ADD CONSTRAINT fk_inscription_curriculum
FOREIGN KEY (id_curriculum_course)
REFERENCES CURRICULUM_COURSES (id)
ON DELETE RESTRICT
ON UPDATE CASCADE;

-- =============================================================================
-- WORKSHOPS_GRADES
-- =============================================================================

-- Relación con estudiantes
ALTER TABLE WORKSHOPS_GRADES
ADD CONSTRAINT fk_grade_student
FOREIGN KEY (id_student)
REFERENCES STUDENTS (id)
ON DELETE CASCADE
ON UPDATE CASCADE;

-- Relación con talleres
ALTER TABLE WORKSHOPS_GRADES
ADD CONSTRAINT fk_grade_workshop
FOREIGN KEY (id_workshop)
REFERENCES WORKSHOPS (id)
ON DELETE CASCADE
ON UPDATE CASCADE;

-- =============================================================================
-- AUTH_USERS
-- =============================================================================

-- Relación con estudiantes (cuando user_type = 'STUDENT')
-- Nota: Esta FK solo se aplica cuando user_type = 'STUDENT'
-- La validación completa se hace con constraints

-- Relación con administradores (cuando user_type = 'ADMINISTRATOR')
-- Nota: Esta FK solo se aplica cuando user_type = 'ADMINISTRATOR'
-- La validación completa se hace con constraints

-- =============================================================================
-- USER_SESSIONS
-- =============================================================================

-- Relación con usuarios de autenticación
ALTER TABLE USER_SESSIONS
ADD CONSTRAINT fk_session_auth_user
FOREIGN KEY (id_auth_user)
REFERENCES AUTH_USERS(id)
ON DELETE CASCADE
ON UPDATE CASCADE;

-- =============================================================================
-- AUDIT_LOG
-- =============================================================================

-- Relación con tablas de auditoría
ALTER TABLE AUDIT_LOG
ADD CONSTRAINT fk_audit_table
FOREIGN KEY (id_audit_table)
REFERENCES AUDIT_TABLES (id)
ON DELETE RESTRICT
ON UPDATE CASCADE;

-- Relación con acciones de auditoría
ALTER TABLE AUDIT_LOG
ADD CONSTRAINT fk_audit_action
FOREIGN KEY (id_audit_action)
REFERENCES AUDIT_ACTIONS (id)
ON DELETE RESTRICT
ON UPDATE CASCADE;

-- Relación con campos de auditoría (opcional)
ALTER TABLE AUDIT_LOG
ADD CONSTRAINT fk_audit_field
FOREIGN KEY (id_audit_field)
REFERENCES AUDIT_FIELDS (id)
ON DELETE RESTRICT
ON UPDATE CASCADE;

-- Relación con usuarios de autenticación
ALTER TABLE AUDIT_LOG
ADD CONSTRAINT fk_audit_log_auth_user
FOREIGN KEY (id_auth_user) REFERENCES AUTH_USERS(id)
ON DELETE CASCADE
ON UPDATE CASCADE;

-- =============================================================================
-- NOTIFICATIONS
-- =============================================================================

-- Relación con tipos de notificación
ALTER TABLE NOTIFICATIONS
ADD CONSTRAINT fk_notification_type
FOREIGN KEY (id_notification_type)
REFERENCES NOTIFICATION_TYPES (id)
ON DELETE RESTRICT
ON UPDATE CASCADE;

-- Relación con tablas relacionadas (opcional)
ALTER TABLE NOTIFICATIONS
ADD CONSTRAINT fk_notification_related_table
FOREIGN KEY (id_notification_related_table)
REFERENCES AUDIT_TABLES (id)
ON DELETE RESTRICT
ON UPDATE CASCADE;

-- Relación con usuarios de autenticación
ALTER TABLE NOTIFICATIONS
ADD CONSTRAINT fk_notification_auth_user
FOREIGN KEY (id_auth_user) REFERENCES AUTH_USERS(id)
ON DELETE CASCADE
ON UPDATE CASCADE;

-- =============================================================================
-- CONFIGURACIÓN FINAL
-- =============================================================================

SET FOREIGN_KEY_CHECKS = 1;

SELECT "Foreign keys creadas correctamente" AS mensaje;
