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


SELECT "Índices creados correctamente" AS mensaje;
