-- =============================
-- ÍNDICES PARA OPTIMIZACIÓN SGSCT
-- =============================

SET FOREIGN_KEY_CHECKS = 0;

-- AUTH_USERS: Búsqueda rápida por email (login)
ALTER TABLE AUTH_USERS DROP INDEX IF EXISTS idx_auth_users_email;
CREATE INDEX idx_auth_users_email ON AUTH_USERS(email);

-- USERS: Búsqueda por nombre y campus
ALTER TABLE USERS DROP INDEX IF EXISTS idx_users_full_name;
CREATE INDEX idx_users_full_name ON USERS(full_name);
ALTER TABLE USERS DROP INDEX IF EXISTS idx_users_campus;
CREATE INDEX idx_users_campus ON USERS(id_campus);

-- USERS: Búsqueda por RUT y ROL
ALTER TABLE USERS DROP INDEX IF EXISTS idx_users_rut;
CREATE INDEX idx_users_rut ON USERS(rut_student);
ALTER TABLE USERS DROP INDEX IF EXISTS idx_users_rol;
CREATE INDEX idx_users_rol ON USERS(rol_student);

-- SUBJECTS: Búsqueda por nombre y acrónimo
ALTER TABLE SUBJECTS DROP INDEX IF EXISTS idx_subjects_name;
CREATE INDEX idx_subjects_name ON SUBJECTS(name);
ALTER TABLE SUBJECTS DROP INDEX IF EXISTS idx_subjects_acronym;
CREATE INDEX idx_subjects_acronym ON SUBJECTS(acronym);
ALTER TABLE SUBJECTS DROP INDEX IF EXISTS idx_subjects_department;
CREATE INDEX idx_subjects_department ON SUBJECTS(id_department);

-- CURRICULUM_COURSE_SLOTS: Búsqueda por nombre y tipo
ALTER TABLE CURRICULUM_COURSE_SLOTS DROP INDEX IF EXISTS idx_curriculum_course_slots_name;
CREATE INDEX idx_curriculum_course_slots_name ON CURRICULUM_COURSE_SLOTS(name);
ALTER TABLE CURRICULUM_COURSE_SLOTS DROP INDEX IF EXISTS idx_curriculum_course_slots_type;
CREATE INDEX idx_curriculum_course_slots_type ON CURRICULUM_COURSE_SLOTS(id_curriculum_course_type);

-- WORKSHOPS: Búsqueda por nombre, año, semestre y estado
ALTER TABLE WORKSHOPS DROP INDEX IF EXISTS idx_workshops_name;
CREATE INDEX idx_workshops_name ON WORKSHOPS(name);
ALTER TABLE WORKSHOPS DROP INDEX IF EXISTS idx_workshops_year_semester;
CREATE INDEX idx_workshops_year_semester ON WORKSHOPS(year, semester);
ALTER TABLE WORKSHOPS DROP INDEX IF EXISTS idx_workshops_state;
CREATE INDEX idx_workshops_state ON WORKSHOPS(id_workshop_state);

-- WORKSHOPS_INSCRIPTIONS: Búsqueda por estudiante y taller
ALTER TABLE WORKSHOPS_INSCRIPTIONS DROP INDEX IF EXISTS idx_workshops_insc_student;
CREATE INDEX idx_workshops_insc_student ON WORKSHOPS_INSCRIPTIONS(id_student);
ALTER TABLE WORKSHOPS_INSCRIPTIONS DROP INDEX IF EXISTS idx_workshops_insc_workshop;
CREATE INDEX idx_workshops_insc_workshop ON WORKSHOPS_INSCRIPTIONS(id_workshop);

-- WORKSHOPS_GRADES: Búsqueda por estudiante y taller
ALTER TABLE WORKSHOPS_GRADES DROP INDEX IF EXISTS idx_workshops_grades_student;
CREATE INDEX idx_workshops_grades_student ON WORKSHOPS_GRADES(id_student);
ALTER TABLE WORKSHOPS_GRADES DROP INDEX IF EXISTS idx_workshops_grades_workshop;
CREATE INDEX idx_workshops_grades_workshop ON WORKSHOPS_GRADES(id_workshop);

-- REQUESTS: Búsqueda por estudiante y revisor
ALTER TABLE REQUESTS DROP INDEX IF EXISTS idx_requests_student;
CREATE INDEX idx_requests_student ON REQUESTS(id_student);
ALTER TABLE REQUESTS DROP INDEX IF EXISTS idx_requests_reviewed_by;
CREATE INDEX idx_requests_reviewed_by ON REQUESTS(id_reviewed_by);

-- CONVALIDATIONS: Búsqueda por solicitud, tipo y estado
ALTER TABLE CONVALIDATIONS DROP INDEX IF EXISTS idx_convalidations_request;
CREATE INDEX idx_convalidations_request ON CONVALIDATIONS(id_request);
ALTER TABLE CONVALIDATIONS DROP INDEX IF EXISTS idx_convalidations_type;
CREATE INDEX idx_convalidations_type ON CONVALIDATIONS(id_convalidation_type);
ALTER TABLE CONVALIDATIONS DROP INDEX IF EXISTS idx_convalidations_state;
CREATE INDEX idx_convalidations_state ON CONVALIDATIONS(id_convalidation_state);
ALTER TABLE CONVALIDATIONS DROP INDEX IF EXISTS idx_convalidations_course;
CREATE INDEX idx_convalidations_course ON CONVALIDATIONS(id_curriculum_course);

-- CONVALIDATIONS_SUBJECTS: Búsqueda por asignatura
ALTER TABLE CONVALIDATIONS_SUBJECTS DROP INDEX IF EXISTS idx_convalidations_subjects_subject;
CREATE INDEX idx_convalidations_subjects_subject ON CONVALIDATIONS_SUBJECTS(id_subject);

-- CONVALIDATIONS_WORKSHOPS: Búsqueda por taller
ALTER TABLE CONVALIDATIONS_WORKSHOPS DROP INDEX IF EXISTS idx_convalidations_workshops_workshop;
CREATE INDEX idx_convalidations_workshops_workshop ON CONVALIDATIONS_WORKSHOPS(id_workshop);

-- CONVALIDATIONS_EXTERNAL_ACTIVITIES: Búsqueda por nombre de actividad
ALTER TABLE CONVALIDATIONS_EXTERNAL_ACTIVITIES DROP INDEX IF EXISTS idx_convalidations_external_activity_name;
CREATE INDEX idx_convalidations_external_activity_name ON CONVALIDATIONS_EXTERNAL_ACTIVITIES(activity_name);

-- NOTIFICATIONS: Búsqueda por usuario, tipo y estado de lectura
ALTER TABLE NOTIFICATIONS DROP INDEX IF EXISTS idx_notifications_user;
CREATE INDEX idx_notifications_user ON NOTIFICATIONS(id_user);
ALTER TABLE NOTIFICATIONS DROP INDEX IF EXISTS idx_notifications_type;
CREATE INDEX idx_notifications_type ON NOTIFICATIONS(notification_type);
ALTER TABLE NOTIFICATIONS DROP INDEX IF EXISTS idx_notifications_is_read;
CREATE INDEX idx_notifications_is_read ON NOTIFICATIONS(is_read);

-- NOTIFICATION_TYPES: Búsqueda por nombre
ALTER TABLE NOTIFICATION_TYPES DROP INDEX IF EXISTS idx_notification_types_name;
CREATE INDEX idx_notification_types_name ON NOTIFICATION_TYPES(name);

-- =============================================================================
-- ÍNDICES PARA NUEVAS TABLAS
-- =============================================================================

-- WORKSHOPS_TOKENS: Búsqueda por token, expiración y taller
ALTER TABLE WORKSHOPS_TOKENS DROP INDEX IF EXISTS idx_workshop_tokens_token;
CREATE INDEX idx_workshop_tokens_token ON WORKSHOPS_TOKENS(token);
ALTER TABLE WORKSHOPS_TOKENS DROP INDEX IF EXISTS idx_workshop_tokens_expiration;
CREATE INDEX idx_workshop_tokens_expiration ON WORKSHOPS_TOKENS(expiration_at);
ALTER TABLE WORKSHOPS_TOKENS DROP INDEX IF EXISTS idx_workshop_tokens_workshop;
CREATE INDEX idx_workshop_tokens_workshop ON WORKSHOPS_TOKENS(id_workshop);
ALTER TABLE WORKSHOPS_TOKENS DROP INDEX IF EXISTS idx_workshop_tokens_professor;
CREATE INDEX idx_workshop_tokens_professor ON WORKSHOPS_TOKENS(id_professor);
ALTER TABLE WORKSHOPS_TOKENS DROP INDEX IF EXISTS idx_workshop_tokens_created_by;
CREATE INDEX idx_workshop_tokens_created_by ON WORKSHOPS_TOKENS(created_by);
ALTER TABLE WORKSHOPS_TOKENS DROP INDEX IF EXISTS idx_workshop_tokens_is_used;
CREATE INDEX idx_workshop_tokens_is_used ON WORKSHOPS_TOKENS(is_used);

-- PROFESSORS: Búsqueda por email y estado activo
ALTER TABLE PROFESSORS DROP INDEX IF EXISTS idx_professors_email;
CREATE INDEX idx_professors_email ON PROFESSORS(email);

ALTER TABLE PROFESSORS DROP INDEX IF EXISTS idx_professors_name;
CREATE INDEX idx_professors_name ON PROFESSORS(name);

-- WORKSHOPS: Índice faltante para profesor
ALTER TABLE WORKSHOPS DROP INDEX IF EXISTS idx_workshops_professor;
CREATE INDEX idx_workshops_professor ON WORKSHOPS(id_professor);

-- =============================================================================
-- ÍNDICES COMPUESTOS PARA OPTIMIZACIÓN
-- =============================================================================

-- WORKSHOPS_TOKENS: Búsqueda por taller y estado de uso
ALTER TABLE WORKSHOPS_TOKENS DROP INDEX IF EXISTS idx_workshop_tokens_workshop_used;
CREATE INDEX idx_workshop_tokens_workshop_used ON WORKSHOPS_TOKENS(id_workshop, is_used);

-- WORKSHOPS_TOKENS: Búsqueda por profesor y expiración
ALTER TABLE WORKSHOPS_TOKENS DROP INDEX IF EXISTS idx_workshop_tokens_professor_expiration;
CREATE INDEX idx_workshop_tokens_professor_expiration ON WORKSHOPS_TOKENS(id_professor, expiration_at);

-- WORKSHOPS: Búsqueda por año, semestre y estado
ALTER TABLE WORKSHOPS DROP INDEX IF EXISTS idx_workshops_year_semester_state;
CREATE INDEX idx_workshops_year_semester_state ON WORKSHOPS(year, semester, id_workshop_state);

-- WORKSHOPS_GRADES: Búsqueda por taller y estudiante
ALTER TABLE WORKSHOPS_GRADES DROP INDEX IF EXISTS idx_workshop_grades_workshop_student;
CREATE INDEX idx_workshop_grades_workshop_student ON WORKSHOPS_GRADES(id_workshop, id_student);



SET FOREIGN_KEY_CHECKS = 1;

SELECT "Índices creados correctamente" AS mensaje;
