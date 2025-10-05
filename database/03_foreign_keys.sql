--------------------------------------------------------------------------------------------------------
---------------------------------- CLAVES FORÁNEAS DE LA BASE DE DATOS ----------------------------------
--------------------------------------------------------------------------------------------------------

-- =============================================================================
-- WORKSHOP_STATE_TRANSITIONS
-- =============================================================================

-- Relación con estado origen
ALTER TABLE WORKSHOP_STATE_TRANSITIONS
ADD CONSTRAINT fk_workshop_transition_from_state
FOREIGN KEY (id_from_state)
REFERENCES WORKSHOP_STATES(id)
ON DELETE CASCADE
ON UPDATE CASCADE;

-- Relación con estado destino
ALTER TABLE WORKSHOP_STATE_TRANSITIONS
ADD CONSTRAINT fk_workshop_transition_to_state
FOREIGN KEY (id_to_state)
REFERENCES WORKSHOP_STATES(id)
ON DELETE CASCADE
ON UPDATE CASCADE;

-- =============================================================================
-- CONVALIDATION_STATE_TRANSITIONS
-- =============================================================================

-- Relación con estado origen
ALTER TABLE CONVALIDATION_STATE_TRANSITIONS
ADD CONSTRAINT fk_convalidation_transition_from_state
FOREIGN KEY (id_from_state)
REFERENCES CONVALIDATION_STATES(id)
ON DELETE CASCADE
ON UPDATE CASCADE;

-- Relación con estado destino
ALTER TABLE CONVALIDATION_STATE_TRANSITIONS
ADD CONSTRAINT fk_convalidation_transition_to_state
FOREIGN KEY (id_to_state)
REFERENCES CONVALIDATION_STATES(id)
ON DELETE CASCADE
ON UPDATE CASCADE;

-- =============================================================================
-- CURRICULUM_COURSE_SLOTS
-- =============================================================================

-- Relación con tipos de cursos curriculares
ALTER TABLE CURRICULUM_COURSE_SLOTS
ADD CONSTRAINT fk_curriculum_course_slot_type
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


ALTER TABLE WORKSHOPS
ADD CONSTRAINT fk_workshop_professor
FOREIGN KEY (id_professor)
REFERENCES PROFESSORS (id)
ON DELETE RESTRICT
ON UPDATE CASCADE;

-- =============================================================================
-- REQUESTS
-- =============================================================================

ALTER TABLE REQUESTS
ADD CONSTRAINT fk_request_student
FOREIGN KEY (id_student)
REFERENCES USERS (id)
ON DELETE CASCADE
ON UPDATE CASCADE;


ALTER TABLE REQUESTS
ADD CONSTRAINT fk_request_reviewed_by
FOREIGN KEY (id_reviewed_by)
REFERENCES USERS (id)
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

-- Relación con curriculum course slots
ALTER TABLE CONVALIDATIONS
ADD CONSTRAINT fk_convalidation_curriculum_course_slot
FOREIGN KEY (id_curriculum_course)
REFERENCES CURRICULUM_COURSE_SLOTS (id)
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
REFERENCES USERS (id)
ON DELETE CASCADE
ON UPDATE CASCADE;

-- Relación con talleres
ALTER TABLE WORKSHOPS_INSCRIPTIONS
ADD CONSTRAINT fk_inscription_workshop
FOREIGN KEY (id_workshop)
REFERENCES WORKSHOPS (id)
ON DELETE CASCADE
ON UPDATE CASCADE;

-- Relación con curriculum course slots (opcional)
ALTER TABLE WORKSHOPS_INSCRIPTIONS
ADD CONSTRAINT fk_inscription_curriculum_course_slot
FOREIGN KEY (id_curriculum_course)
REFERENCES CURRICULUM_COURSE_SLOTS (id)
ON DELETE RESTRICT
ON UPDATE CASCADE;

-- =============================================================================
-- WORKSHOPS_GRADES
-- =============================================================================

-- Relación con estudiantes
ALTER TABLE WORKSHOPS_GRADES
ADD CONSTRAINT fk_grade_student
FOREIGN KEY (id_student)
REFERENCES USERS (id)
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

-- La FK de USERS a AUTH_USERS ya está definida en 02_structure.sql
-- No es necesario agregarla nuevamente aquí

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
-- WORKSHOPS_TOKENS
-- =============================================================================


ALTER TABLE WORKSHOPS_TOKENS
ADD CONSTRAINT fk_token_workshop
FOREIGN KEY (id_workshop)
REFERENCES WORKSHOPS (id)
ON DELETE CASCADE
ON UPDATE CASCADE;

-- Relación con profesores
ALTER TABLE WORKSHOPS_TOKENS
ADD CONSTRAINT fk_token_professor
FOREIGN KEY (id_professor)
REFERENCES PROFESSORS (id)
ON DELETE RESTRICT
ON UPDATE CASCADE;


ALTER TABLE WORKSHOPS_TOKENS
ADD CONSTRAINT fk_token_created_by
FOREIGN KEY (created_by)
REFERENCES USERS (id)
ON DELETE RESTRICT
ON UPDATE CASCADE;

-- =============================================================================
-- CONFIGURACIÓN FINAL
-- =============================================================================

SELECT "Foreign keys creadas correctamente" AS mensaje;
