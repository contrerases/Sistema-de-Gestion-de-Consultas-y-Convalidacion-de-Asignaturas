--------------------------------------------------------------------------------------------------------
---------------------------------- CONSTRAINTS DE LA BASE DE DATOS --------------------------------------
--------------------------------------------------------------------------------------------------------

-- =============================================================================
-- RESUMEN DE CONSTRAINTS
-- =============================================================================
-- Total of constraints: 25
-- UNIQUE: 17 | CHECK: 8
-- CONVALIDATION_TYPES: 1 | CURRICULUM_COURSES_TYPES: 1 | DEPARTMENTS: 1
-- SUBJECTS: 3 | CURRICULUM_COURSES: 1 | WORKSHOPS: 5 | AUTH_USERS: 2
-- STUDENTS: 4 | REQUESTS: 1 | CONVALIDATIONS: 1
-- CONVALIDATIONS_SUBJECTS: 1 | CONVALIDATIONS_WORKSHOPS: 1 | CONVALIDATIONS_EXTERNAL_ACTIVITIES: 2
-- WORKSHOPS_INSCRIPTIONS: 1 | WORKSHOPS_GRADES: 2 | NOTIFICATIONS: 1

-- =============================================================================
-- CONFIGURACIÓN INICIAL
-- =============================================================================

SET FOREIGN_KEY_CHECKS = 0;

-- =============================================================================
-- CONVALIDATION_TYPES
-- =============================================================================

-- Nombre único
ALTER TABLE CONVALIDATION_TYPES
ADD CONSTRAINT uk_convalidation_type_name UNIQUE (name);

-- =============================================================================
-- CURRICULUM_COURSES_TYPES
-- =============================================================================

-- Nombre único
ALTER TABLE CURRICULUM_COURSES_TYPES
ADD CONSTRAINT uk_curriculum_course_type_name UNIQUE (name);

-- =============================================================================
-- DEPARTMENTS
-- =============================================================================

-- Nombre único
ALTER TABLE DEPARTMENTS
ADD CONSTRAINT uk_department_name UNIQUE (name);

-- =============================================================================
-- SUBJECTS
-- =============================================================================

-- Acrónimo único
ALTER TABLE SUBJECTS
ADD CONSTRAINT uk_subject_acronym UNIQUE (acronym);

-- Nombre único
ALTER TABLE SUBJECTS
ADD CONSTRAINT uk_subject_name UNIQUE (name);

-- Rango de créditos
ALTER TABLE SUBJECTS
ADD CONSTRAINT chk_subject_credits CHECK (credits >= 1 AND credits <= 10);

-- =============================================================================
-- CURRICULUM_COURSES
-- =============================================================================

-- Nombre único
ALTER TABLE CURRICULUM_COURSES
ADD CONSTRAINT uk_curriculum_course_name UNIQUE (name);

-- =============================================================================
-- WORKSHOPS
-- =============================================================================

-- Nombre único por semestre y año
ALTER TABLE WORKSHOPS
ADD CONSTRAINT uk_workshop_name_semester_year UNIQUE (name, semester, year);

-- Fechas de inscripción
ALTER TABLE WORKSHOPS
ADD CONSTRAINT chk_workshop_inscription_dates CHECK (inscription_end_date > inscription_start_date);

-- Fechas del curso
ALTER TABLE WORKSHOPS
ADD CONSTRAINT chk_workshop_course_dates CHECK (course_end_date > course_start_date);

-- Relación entre fechas
ALTER TABLE WORKSHOPS
ADD CONSTRAINT chk_workshop_inscription_before_course CHECK (inscription_end_date <= course_start_date);

-- Rango de año
ALTER TABLE WORKSHOPS
ADD CONSTRAINT chk_workshop_year CHECK (year >= 2000 AND year <= 2100);

-- Relación con profesores




-- =============================================================================
-- STUDENTS
-- =============================================================================

-- ROL único
ALTER TABLE STUDENTS
ADD CONSTRAINT uk_student_rol UNIQUE (rol_student);

-- RUT único
ALTER TABLE STUDENTS
ADD CONSTRAINT uk_student_rut UNIQUE (rut_student);

-- Formato de ROL (sin guión)
ALTER TABLE STUDENTS
ADD CONSTRAINT chk_student_rol_format CHECK (rol_student REGEXP '^[0-9]{10}$');

-- Formato de RUT (sin guión)
ALTER TABLE STUDENTS
ADD CONSTRAINT chk_student_rut_format CHECK (rut_student REGEXP '^[0-9]{7,8}[0-9kK]$');

-- =============================================================================
-- REQUESTS
-- =============================================================================

-- Fecha de revisión posterior a envío
ALTER TABLE REQUESTS
ADD CONSTRAINT chk_request_review_date CHECK (reviewed_at IS NULL OR reviewed_at >= sent_at);

-- Solo administradores pueden revisar solicitudes
-- Nota: Esta validación se maneja a nivel de aplicación o con triggers
-- ya que MySQL no permite subconsultas en constraints CHECK

-- =============================================================================
-- CONVALIDATIONS
-- =============================================================================

-- Convalidación única por solicitud y curso
ALTER TABLE CONVALIDATIONS
ADD CONSTRAINT uk_convalidation_request_curriculum UNIQUE (id_request, id_curriculum_course);

-- Validar que el tipo de convalidación coincida con el contenido
-- Nota: Esta validación se maneja a nivel de aplicación o con triggers
-- ya que MySQL no permite subconsultas complejas en constraints CHECK

-- =============================================================================
-- CONVALIDATIONS_SUBJECTS
-- =============================================================================

-- Convalidación única por asignatura y solicitud
ALTER TABLE CONVALIDATIONS_SUBJECTS
ADD CONSTRAINT uk_convalidation_subject_request UNIQUE (id_subject, id_convalidation);

-- =============================================================================
-- CONVALIDATIONS_WORKSHOPS
-- =============================================================================

-- Convalidación única por taller y solicitud
ALTER TABLE CONVALIDATIONS_WORKSHOPS
ADD CONSTRAINT uk_convalidation_workshop_request UNIQUE (id_workshop, id_convalidation);

-- =============================================================================
-- CONVALIDATIONS_EXTERNAL_ACTIVITIES
-- =============================================================================

-- Nombre de actividad no vacío
ALTER TABLE CONVALIDATIONS_EXTERNAL_ACTIVITIES
ADD CONSTRAINT chk_external_activity_name CHECK (LENGTH(TRIM(activity_name)) > 0);

-- Validación de archivo
ALTER TABLE CONVALIDATIONS_EXTERNAL_ACTIVITIES
ADD CONSTRAINT chk_external_activity_file CHECK (
    (file_data IS NULL AND file_name IS NULL) OR
    (file_data IS NOT NULL AND file_name IS NOT NULL)
);

-- =============================================================================
-- WORKSHOPS_INSCRIPTIONS
-- =============================================================================

-- Inscripción única por estudiante y taller
ALTER TABLE WORKSHOPS_INSCRIPTIONS
ADD CONSTRAINT uk_inscription_student_workshop UNIQUE (id_student, id_workshop);

-- Validación de convalidación
-- Nota: Esta validación se maneja a nivel de aplicación o con triggers
-- ya que MySQL no permite usar columnas de FK directamente en constraints CHECK

-- Talleres cancelados no pueden tener inscripciones nuevas
-- Nota: Esta validación se maneja a nivel de aplicación o con triggers
-- ya que MySQL no permite subconsultas en constraints CHECK

-- Solo se puede inscribir durante el período de inscripción
-- Nota: Esta validación se maneja a nivel de aplicación o con triggers
-- ya que MySQL no permite subconsultas en constraints CHECK

-- =============================================================================
-- WORKSHOPS_GRADES
-- =============================================================================

-- Calificación única por estudiante y taller
ALTER TABLE WORKSHOPS_GRADES
ADD CONSTRAINT uk_grade_student_workshop UNIQUE (id_student, id_workshop);

-- Rango de calificación
ALTER TABLE WORKSHOPS_GRADES
ADD CONSTRAINT chk_grade_range CHECK (grade >= 0 AND grade <= 100);

-- Un estudiante solo puede tener calificación si está inscrito
-- Nota: Esta validación se maneja a nivel de aplicación o con triggers
-- ya que MySQL no permite subconsultas en constraints CHECK

-- =============================================================================
-- AUDIT_LOG
-- =============================================================================

-- Validación de usuario (usando FK)
-- No necesita constraint adicional porque ya tiene FK a AUTH_USERS

-- Validación de valores (manejada por triggers)
-- Esta validación se implementa en triggers debido a limitaciones de MariaDB con CHECK

-- =============================================================================
-- NOTIFICATIONS
-- =============================================================================

-- Validación de usuario (usando FK)
-- No necesita constraint adicional porque ya tiene FK a AUTH_USERS

-- Validación de entidad relacionada (manejada por triggers)
-- Esta validación se implementa en triggers debido a limitaciones de MariaDB con CHECK

-- Validación de fechas
ALTER TABLE NOTIFICATIONS
ADD CONSTRAINT chk_notification_dates CHECK (
    (read_at IS NULL OR read_at >= created_at) AND
    (sent_at IS NULL OR sent_at >= created_at)
);

-- =============================================================================
-- AUTH_USERS
-- =============================================================================

-- Email único
ALTER TABLE AUTH_USERS
ADD CONSTRAINT uk_auth_email UNIQUE (email);

-- Formato de email
ALTER TABLE AUTH_USERS
ADD CONSTRAINT chk_auth_email_format CHECK (email REGEXP '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$');

-- =============================================================================
-- PROFESSORS
-- =============================================================================

-- Email único
ALTER TABLE PROFESSORS
ADD CONSTRAINT uk_professor_email UNIQUE (email);

-- Nombre no vacío
ALTER TABLE PROFESSORS
ADD CONSTRAINT chk_professor_name CHECK (LENGTH(TRIM(name)) > 0);

-- Formato de email
ALTER TABLE PROFESSORS
ADD CONSTRAINT chk_professor_email_format CHECK (email REGEXP '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$');

-- =============================================================================
-- WORKSHOPS_TOKENS
-- =============================================================================

-- Token único
ALTER TABLE WORKSHOPS_TOKENS
ADD CONSTRAINT uk_token_unique UNIQUE (token);

-- Token no vacío
ALTER TABLE WORKSHOPS_TOKENS
ADD CONSTRAINT chk_token_not_empty CHECK (LENGTH(TRIM(token)) > 0);

-- Fecha de expiración posterior a creación
ALTER TABLE WORKSHOPS_TOKENS
ADD CONSTRAINT chk_token_expiration CHECK (expiration_at > created_at);

-- Fecha de uso posterior a creación
ALTER TABLE WORKSHOPS_TOKENS
ADD CONSTRAINT chk_token_used_at CHECK (used_at IS NULL OR used_at >= created_at);

-- =============================================================================
-- CONSTRAINTS ADICIONALES PARA OPTIMIZACIÓN
-- =============================================================================

-- WORKSHOPS: Límite de inscripciones positivo
ALTER TABLE WORKSHOPS
ADD CONSTRAINT chk_workshop_inscriptions_limit CHECK (limit_inscriptions >= 0);

-- WORKSHOPS: Número de inscripciones no negativo
ALTER TABLE WORKSHOPS
ADD CONSTRAINT chk_workshop_inscriptions_number CHECK (inscriptions_number >= 0);

-- WORKSHOPS: Número de inscripciones no puede exceder el límite
ALTER TABLE WORKSHOPS
ADD CONSTRAINT chk_workshop_inscriptions_vs_limit CHECK (inscriptions_number <= limit_inscriptions);

-- WORKSHOPS_TOKENS: Expiración debe ser en el futuro
ALTER TABLE WORKSHOPS_TOKENS
ADD CONSTRAINT chk_token_expiration_future CHECK (expiration_at > created_at);

-- WORKSHOPS_TOKENS: Token debe tener al menos 10 caracteres
ALTER TABLE WORKSHOPS_TOKENS
ADD CONSTRAINT chk_token_length CHECK (LENGTH(token) >= 10);

-- PROFESSORS: Email debe ser válido
ALTER TABLE PROFESSORS
ADD CONSTRAINT chk_professor_email_format CHECK (email REGEXP '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$');

-- PROFESSORS: Nombre debe tener al menos 2 caracteres
ALTER TABLE PROFESSORS
ADD CONSTRAINT chk_professor_name_length CHECK (LENGTH(TRIM(name)) >= 2);

-- WORKSHOPS_GRADES: Calificación debe estar en rango válido
ALTER TABLE WORKSHOPS_GRADES
ADD CONSTRAINT chk_grade_range CHECK (grade >= 0 AND grade <= 100);

-- WORKSHOPS_GRADES: Calificación única por estudiante y taller
ALTER TABLE WORKSHOPS_GRADES
ADD CONSTRAINT uk_grade_student_workshop UNIQUE (id_student, id_workshop);

-- WORKSHOPS_INSCRIPTIONS: Inscripción única por estudiante y taller
ALTER TABLE WORKSHOPS_INSCRIPTIONS
ADD CONSTRAINT uk_inscription_student_workshop UNIQUE (id_student, id_workshop);

-- =============================================================================
-- CONSTRAINTS DE INTEGRIDAD DE DATOS
-- =============================================================================

-- WORKSHOPS: Fechas de inscripción deben ser coherentes
ALTER TABLE WORKSHOPS
ADD CONSTRAINT chk_workshop_inscription_dates_coherent CHECK (
    inscription_start_date < inscription_end_date AND
    inscription_end_date <= course_start_date AND
    course_start_date < course_end_date
);

-- WORKSHOPS_TOKENS: Solo un token activo por taller
-- (Se maneja a nivel de aplicación para mayor flexibilidad)

-- =============================================================================
-- CONFIGURACIÓN FINAL
-- =============================================================================

SET FOREIGN_KEY_CHECKS = 1;

SELECT "Constraints creadas correctamente" AS mensaje;
