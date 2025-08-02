-- =============================
-- ÍNDICES PARA OPTIMIZACIÓN SGSCT
-- =============================

-- AUTH_USERS: Búsqueda rápida por email (login)
CREATE INDEX idx_auth_users_email ON AUTH_USERS(email);

-- USERS: Búsqueda por nombre y campus
CREATE INDEX idx_users_full_name ON USERS(full_name);
CREATE INDEX idx_users_campus ON USERS(campus);

-- STUDENTS: Búsqueda por RUT y ROL
CREATE INDEX idx_students_rut ON STUDENTS(rut_student);
CREATE INDEX idx_students_rol ON STUDENTS(rol_student);

-- SUBJECTS: Búsqueda por nombre y acrónimo
CREATE INDEX idx_subjects_name ON SUBJECTS(name);
CREATE INDEX idx_subjects_acronym ON SUBJECTS(acronym);
CREATE INDEX idx_subjects_department ON SUBJECTS(id_department);

-- CURRICULUM_COURSES: Búsqueda por nombre y tipo
CREATE INDEX idx_curriculum_courses_name ON CURRICULUM_COURSES(name);
CREATE INDEX idx_curriculum_courses_type ON CURRICULUM_COURSES(id_curriculum_course_type);

-- WORKSHOPS: Búsqueda por nombre, año, semestre y estado
CREATE INDEX idx_workshops_name ON WORKSHOPS(name);
CREATE INDEX idx_workshops_year_semester ON WORKSHOPS(year, semester);
CREATE INDEX idx_workshops_state ON WORKSHOPS(id_workshop_state);

-- WORKSHOPS_INSCRIPTIONS: Búsqueda por estudiante y taller
CREATE INDEX idx_workshops_insc_student ON WORKSHOPS_INSCRIPTIONS(id_student);
CREATE INDEX idx_workshops_insc_workshop ON WORKSHOPS_INSCRIPTIONS(id_workshop);

-- WORKSHOPS_GRADES: Búsqueda por estudiante y taller
CREATE INDEX idx_workshops_grades_student ON WORKSHOPS_GRADES(id_student);
CREATE INDEX idx_workshops_grades_workshop ON WORKSHOPS_GRADES(id_workshop);

-- REQUESTS: Búsqueda por estudiante y revisor
CREATE INDEX idx_requests_student ON REQUESTS(id_student);
CREATE INDEX idx_requests_reviewed_by ON REQUESTS(id_reviewed_by);

-- CONVALIDATIONS: Búsqueda por solicitud, tipo y estado
CREATE INDEX idx_convalidations_request ON CONVALIDATIONS(id_request);
CREATE INDEX idx_convalidations_type ON CONVALIDATIONS(id_convalidation_type);
CREATE INDEX idx_convalidations_state ON CONVALIDATIONS(id_convalidation_state);
CREATE INDEX idx_convalidations_course ON CONVALIDATIONS(id_curriculum_course);

-- CONVALIDATIONS_SUBJECTS: Búsqueda por asignatura
CREATE INDEX idx_convalidations_subjects_subject ON CONVALIDATIONS_SUBJECTS(id_subject);

-- CONVALIDATIONS_WORKSHOPS: Búsqueda por taller
CREATE INDEX idx_convalidations_workshops_workshop ON CONVALIDATIONS_WORKSHOPS(id_workshop);

-- CONVALIDATIONS_EXTERNAL_ACTIVITIES: Búsqueda por nombre de actividad
CREATE INDEX idx_convalidations_external_activity_name ON CONVALIDATIONS_EXTERNAL_ACTIVITIES(activity_name);

-- NOTIFICATIONS: Búsqueda por usuario, tipo y estado de lectura
CREATE INDEX idx_notifications_user ON NOTIFICATIONS(id_user);
CREATE INDEX idx_notifications_type ON NOTIFICATIONS(notification_type);
CREATE INDEX idx_notifications_is_read ON NOTIFICATIONS(is_read);

-- =============================================================================
-- ÍNDICES PARA NUEVAS TABLAS
-- =============================================================================

-- WORKSHOPS_TOKENS: Búsqueda por token, expiración y taller
CREATE INDEX idx_workshop_tokens_token ON WORKSHOPS_TOKENS(token);
CREATE INDEX idx_workshop_tokens_expiration ON WORKSHOPS_TOKENS(expiration_at);
CREATE INDEX idx_workshop_tokens_workshop ON WORKSHOPS_TOKENS(id_workshop);
CREATE INDEX idx_workshop_tokens_professor ON WORKSHOPS_TOKENS(id_professor);
CREATE INDEX idx_workshop_tokens_created_by ON WORKSHOPS_TOKENS(created_by);
CREATE INDEX idx_workshop_tokens_is_used ON WORKSHOPS_TOKENS(is_used);

-- PROFESSORS: Búsqueda por email y estado activo
CREATE INDEX idx_professors_email ON PROFESSORS(email);
CREATE INDEX idx_professors_active ON PROFESSORS(is_active);
CREATE INDEX idx_professors_name ON PROFESSORS(name);

-- WORKSHOPS: Índice faltante para profesor
CREATE INDEX idx_workshops_professor ON WORKSHOPS(id_professor);

-- =============================================================================
-- ÍNDICES COMPUESTOS PARA OPTIMIZACIÓN
-- =============================================================================

-- WORKSHOPS_TOKENS: Búsqueda por taller y estado de uso
CREATE INDEX idx_workshop_tokens_workshop_used ON WORKSHOPS_TOKENS(id_workshop, is_used);

-- WORKSHOPS_TOKENS: Búsqueda por profesor y expiración
CREATE INDEX idx_workshop_tokens_professor_expiration ON WORKSHOPS_TOKENS(id_professor, expiration_at);

-- WORKSHOPS: Búsqueda por año, semestre y estado
CREATE INDEX idx_workshops_year_semester_state ON WORKSHOPS(year, semester, id_workshop_state);

-- WORKSHOPS_GRADES: Búsqueda por taller y estudiante
CREATE INDEX idx_workshop_grades_workshop_student ON WORKSHOPS_GRADES(id_workshop, id_student);

-- WORKSHOPS_INSCRIPTIONS: Búsqueda por taller y estudiante
CREATE INDEX idx_workshop_inscriptions_workshop_student ON WORKSHOPS_INSCRIPTIONS(id_workshop, id_student);

SELECT "Índices creados correctamente" AS mensaje;
