--------------------------------------------------------------------------------------------------------
---------------------------------- CLAVES FORÁNEAS DE LA BASE DE DATOS ----------------------------------
--------------------------------------------------------------------------------------------------------

-- =============================================================================
-- CURRICULUM_COURSES
-- =============================================================================

-- Relación con tipos de cursos curriculares
ALTER TABLE CURRICULUM_COURSES
ADD CONSTRAINT fk_curriculum_course_type
FOREIGN KEY (id_curriculum_course_type)
REFERENCES CURRICULUM_COURSES_TYPES (id)
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
REFERENCES CONVALIDATION_TYPES (id)
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
-- CONVALIDATIONS_EXTERNAL_ACTIVITIES
-- =============================================================================

-- Relación con convalidaciones
ALTER TABLE CONVALIDATIONS_EXTERNAL_ACTIVITIES
ADD CONSTRAINT fk_convalidation_external_activity_convalidation
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
-- USERS
-- =============================================================================

-- Relación de usuarios con autenticación (tabla principal)
ALTER TABLE USERS
ADD CONSTRAINT fk_user_auth
FOREIGN KEY (id)
REFERENCES AUTH_USERS(id)
ON DELETE CASCADE
ON UPDATE CASCADE;

-- =============================================================================
-- NOTIFICATIONS
-- =============================================================================


-- Relación con usuarios de autenticación
ALTER TABLE NOTIFICATIONS
ADD CONSTRAINT fk_notification_user
FOREIGN KEY (id_user) REFERENCES USERS(id)
ON DELETE CASCADE
ON UPDATE CASCADE;

-- =============================================================================
-- STUDENTS
-- =============================================================================
ALTER TABLE STUDENTS
ADD CONSTRAINT fk_students_user
FOREIGN KEY (id) REFERENCES USERS(id)
ON DELETE CASCADE ON UPDATE CASCADE;

-- =============================================================================
-- ADMINISTRATORS
-- =============================================================================
ALTER TABLE ADMINISTRATORS
ADD CONSTRAINT fk_administrators_user
FOREIGN KEY (id) REFERENCES USERS(id)
ON DELETE CASCADE ON UPDATE CASCADE;

-- =============================================================================
-- CONFIGURACIÓN FINAL
-- =============================================================================

SELECT "Foreign keys creadas correctamente" AS mensaje;
