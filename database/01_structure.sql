--------------------------------------------------------------------------------------------------------
---------------------------------- ESTRUCTURA DE LA BASE DE DATOS --------------------------------------
--------------------------------------------------------------------------------------------------------

-- Desactiva las restricciones de clave foránea temporalmente
SET FOREIGN_KEY_CHECKS = 0;

-- Eliminación de tablas en orden inverso a sus dependencias
DROP TABLE IF EXISTS CONVALIDATION_STATE_HISTORY;
DROP TABLE IF EXISTS AUDIT_LOG;
DROP TABLE IF EXISTS NOTIFICATIONS;
DROP TABLE IF EXISTS WORKSHOPS_GRADES;
DROP TABLE IF EXISTS WORKSHOPS_INSCRIPTIONS;
DROP TABLE IF EXISTS CONVALIDATIONS;
DROP TABLE IF EXISTS REQUESTS;
DROP TABLE IF EXISTS SUBJECTS;
DROP TABLE IF EXISTS CURRICULUM_COURSES;
DROP TABLE IF EXISTS WORKSHOPS;
DROP TABLE IF EXISTS STUDENTS;
DROP TABLE IF EXISTS ADMINISTRATORS;
DROP TABLE IF EXISTS DEPARTMENTS;
DROP TABLE IF EXISTS TYPES_CURRICULUM_COURSES;
DROP TABLE IF EXISTS TYPES_CONVALIDATIONS;

-- Reactiva las restricciones de clave foránea
SET FOREIGN_KEY_CHECKS = 1;


--------------------------------------------------------------------------------------------------------
------------------------------------ TABLAS DE LA BASE DE DATOS ----------------------------------------
--------------------------------------------------------------------------------------------------------


---------------------------------------------------------------
---------------------- TABLAS DE CATALOGOS --------------------
---------------------------------------------------------------


-- Tipos de convalidaciones disponibles
CREATE TABLE IF NOT EXISTS TYPES_CONVALIDATIONS (
    id INT AUTO_INCREMENT NOT NULL,
    name VARCHAR(255) NOT NULL UNIQUE, -- Electivo DI, Electivo Externo, Curso Certificado, Taller de INF, Proyecto Personal
    PRIMARY KEY (id)
);

-- Tipos de cursos del currículum
CREATE TABLE IF NOT EXISTS TYPES_CURRICULUM_COURSES (
    id INT AUTO_INCREMENT NOT NULL,
    name VARCHAR(255) NOT NULL UNIQUE, -- Libre, Electivo, Electivo INF
    PRIMARY KEY (id)
);

------------------------------------------------------------------
---------------------- TABLAS MAESTRAS ---------------------------
------------------------------------------------------------------

-- Departamentos
CREATE TABLE IF NOT EXISTS DEPARTMENTS (
    id INT AUTO_INCREMENT NOT NULL,
    name VARCHAR(255) NOT NULL UNIQUE,
    PRIMARY KEY (id)
);

-- Asignaturas de la universidad
CREATE TABLE IF NOT EXISTS SUBJECTS (
    id INT AUTO_INCREMENT NOT NULL,
    acronym VARCHAR(255) UNIQUE NOT NULL,
    name VARCHAR(255) UNIQUE NOT NULL,
    id_department INT NOT NULL,
    credits INT NOT NULL,
    PRIMARY KEY (id)
);

-- Cursos del plan de estudios
CREATE TABLE IF NOT EXISTS CURRICULUM_COURSES (
    id INT NOT NULL AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL, -- libre 1 .. n , Electivo 1 ... n, Electivo Informatica 1 ... n
    id_type_curriculum_course INT NOT NULL,
    PRIMARY KEY (id)
);

-- Talleres ofrecidos
CREATE TABLE IF NOT EXISTS WORKSHOPS (
    id INT AUTO_INCREMENT NOT NULL,
    name VARCHAR(255) NOT NULL UNIQUE,
    semester ENUM('1', '2') NOT NULL,
    year INT NOT NULL,
    professor VARCHAR(255) NOT NULL,
    initial_date TIMESTAMP NOT NULL,
    inscription_deadline TIMESTAMP NOT NULL,
    file_data LONGBLOB DEFAULT NULL,
    available BOOLEAN NOT NULL DEFAULT TRUE,
    state VARCHAR(255) NOT NULL DEFAULT 'Inscripcion',
    PRIMARY KEY (id)
);


--------------------------------------------------------------------------
------------------------- TABLAS DE NEGOCIO ------------------------------
--------------------------------------------------------------------------

-- Solicitudes de convalidación
CREATE TABLE IF NOT EXISTS REQUESTS (
    id INT NOT NULL AUTO_INCREMENT,
    id_student INT NOT NULL,
    creation_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    revision_date TIMESTAMP,
    comments TEXT DEFAULT NULL,
    id_user_approves INT DEFAULT NULL,
    created_by INT NULL,
    updated_by INT NULL,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- Convalidaciones realizadas
CREATE TABLE IF NOT EXISTS CONVALIDATIONS (
    id INT NOT NULL AUTO_INCREMENT,
    id_request INT NOT NULL,
    id_convalidation_type INT NOT NULL,
    state ENUM(
        'Enviada',
        'Rechazada',
        'Aprobada por DI',
        'En espera de DE',
        'Aprobada por DE'
    ) NOT NULL DEFAULT 'Enviada',
    id_curriculum_course INT NOT NULL,
    id_subject_to_convalidate INT NULL,
    id_workshop_to_convalidate INT NULL,
    certified_course_name VARCHAR(255) NULL,
    personal_project_name VARCHAR(255) NULL,
    file_data LONGBLOB DEFAULT NULL,
    file_name VARCHAR(255) DEFAULT NULL,
    created_by INT NULL,
    updated_by INT NULL,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);


-- Inscripciones a talleres
CREATE TABLE IF NOT EXISTS WORKSHOPS_INSCRIPTIONS (
    id INT AUTO_INCREMENT NOT NULL,
    id_student INT NOT NULL,
    id_workshop INT NOT NULL,
    id_curriculum_course INT NOT NULL,
    is_convalidated BOOLEAN NOT NULL DEFAULT FALSE,
    PRIMARY KEY (id)
);

-- Calificaciones de talleres
CREATE TABLE IF NOT EXISTS WORKSHOPS_GRADES (
    id INT AUTO_INCREMENT NOT NULL,
    id_student INT NOT NULL,
    id_workshop INT NOT NULL,
    grade INT NOT NULL,
    PRIMARY KEY (id)
);


-----------------------------------------------------------------------------
--------------------------- TABLAS DE USUARIO -------------------------------
-----------------------------------------------------------------------------

-- Tabla de administradores
CREATE TABLE IF NOT EXISTS ADMINISTRATORS (
    id INT AUTO_INCREMENT NOT NULL,
    first_name VARCHAR(255) NOT NULL,
    second_name VARCHAR(255) NOT NULL,
    first_last_name VARCHAR(255) NOT NULL,
    second_last_name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    PRIMARY KEY (id)
);


-- Tabla de estudiantes
CREATE TABLE IF NOT EXISTS STUDENTS (
    id INT AUTO_INCREMENT NOT NULL,
    rol_student VARCHAR(11) UNIQUE NOT NULL,
    rut_student VARCHAR(12) UNIQUE NOT NULL,
    campus_student VARCHAR(255) NOT NULL,
    first_name VARCHAR(255) NOT NULL,
    second_name VARCHAR(255) NOT NULL,
    first_last_name VARCHAR(255) NOT NULL,
    second_last_name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    PRIMARY KEY (id)
);


--------------------------------------------------------------------------
------------------------- TABLAS DE AUDITORÍA ----------------------------
--------------------------------------------------------------------------

-- Tabla principal de auditoría
CREATE TABLE IF NOT EXISTS AUDIT_LOG (
    id INT AUTO_INCREMENT PRIMARY KEY,
    table_name VARCHAR(50) NOT NULL,
    record_id INT NOT NULL,
    action VARCHAR(20) NOT NULL, -- INSERT, UPDATE, DELETE, STATUS_CHANGE
    field_name VARCHAR(100) NULL,
    old_value TEXT NULL,
    new_value TEXT NULL,
    id_student INT NULL,
    id_administrator INT NULL,
    user_type ENUM('student', 'administrator', 'system') NULL,
    ip_address VARCHAR(45) NULL,
    user_agent TEXT NULL,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    session_id VARCHAR(255) NULL,
    additional_data JSON NULL
);

-- Tabla de historial de estados para convalidaciones
CREATE TABLE IF NOT EXISTS CONVALIDATION_STATE_HISTORY (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_convalidation INT NOT NULL,
    old_state VARCHAR(50) NULL,
    new_state VARCHAR(50) NOT NULL,
    changed_by INT NULL,
    user_type ENUM('student', 'administrator', 'system') NULL,
    comments TEXT NULL,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla de notificaciones del sistema
CREATE TABLE IF NOT EXISTS NOTIFICATIONS (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_student INT NULL,
    id_administrator INT NULL,
    user_type ENUM('student', 'administrator') NOT NULL,
    type VARCHAR(50) NOT NULL, -- 'request_status', 'workshop_reminder', 'approval_required', etc.
    title VARCHAR(255) NOT NULL,
    message TEXT NOT NULL,
    is_read BOOLEAN DEFAULT FALSE,
    is_sent BOOLEAN DEFAULT FALSE,
    related_table VARCHAR(50) NULL,
    related_id INT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    read_at TIMESTAMP NULL,
    sent_at TIMESTAMP NULL
);


--------------------------------------------------------------------------------------------------------------
----------------------------------------- FOREIGN KEYS -------------------------------------------------------
--------------------------------------------------------------------------------------------------------------

-- Foreign keys para la tabla CURRICULUM_COURSES
ALTER TABLE CURRICULUM_COURSES
    ADD CONSTRAINT fk_curriculum_course_type
    FOREIGN KEY (id_type_curriculum_course)
    REFERENCES TYPES_CURRICULUM_COURSES (id)
    ON DELETE RESTRICT
    ON UPDATE CASCADE;

-- Foreign keys para la tabla REQUESTS
ALTER TABLE REQUESTS
    ADD CONSTRAINT fk_request_student
    FOREIGN KEY (id_student)
    REFERENCES STUDENTS (id)
    ON DELETE CASCADE
    ON UPDATE CASCADE;

ALTER TABLE REQUESTS
    ADD CONSTRAINT fk_request_approver
    FOREIGN KEY (id_user_approves)
    REFERENCES ADMINISTRATORS (id)
    ON DELETE SET NULL
    ON UPDATE CASCADE;

ALTER TABLE REQUESTS
    ADD CONSTRAINT fk_request_created_by
    FOREIGN KEY (created_by)
    REFERENCES ADMINISTRATORS (id)
    ON DELETE SET NULL
    ON UPDATE CASCADE;

ALTER TABLE REQUESTS
    ADD CONSTRAINT fk_request_updated_by
    FOREIGN KEY (updated_by)
    REFERENCES ADMINISTRATORS (id)
    ON DELETE SET NULL
    ON UPDATE CASCADE;

-- Foreign keys para la tabla CONVALIDATIONS
ALTER TABLE CONVALIDATIONS
    ADD CONSTRAINT fk_validation_request
    FOREIGN KEY (id_request)
    REFERENCES REQUESTS (id)
    ON DELETE CASCADE
    ON UPDATE CASCADE;

ALTER TABLE CONVALIDATIONS
    ADD CONSTRAINT fk_validation_type
    FOREIGN KEY (id_convalidation_type)
    REFERENCES TYPES_CONVALIDATIONS (id)
    ON DELETE RESTRICT
    ON UPDATE CASCADE;

ALTER TABLE CONVALIDATIONS
    ADD CONSTRAINT fk_validation_curriculum
    FOREIGN KEY (id_curriculum_course)
    REFERENCES CURRICULUM_COURSES (id)
    ON DELETE RESTRICT
    ON UPDATE CASCADE;

ALTER TABLE CONVALIDATIONS
    ADD CONSTRAINT fk_convalidation_created_by
    FOREIGN KEY (created_by)
    REFERENCES ADMINISTRATORS (id)
    ON DELETE SET NULL
    ON UPDATE CASCADE;

ALTER TABLE CONVALIDATIONS
    ADD CONSTRAINT fk_convalidation_updated_by
    FOREIGN KEY (updated_by)
    REFERENCES ADMINISTRATORS (id)
    ON DELETE SET NULL
    ON UPDATE CASCADE;

-- Foreign keys para la tabla WORKSHOPS_INSCRIPTIONS
ALTER TABLE WORKSHOPS_INSCRIPTIONS
    ADD CONSTRAINT fk_inscription_student
    FOREIGN KEY (id_student)
    REFERENCES STUDENTS (id)
    ON DELETE CASCADE
    ON UPDATE CASCADE;

ALTER TABLE WORKSHOPS_INSCRIPTIONS
    ADD CONSTRAINT fk_inscription_workshop
    FOREIGN KEY (id_workshop)
    REFERENCES WORKSHOPS (id)
    ON DELETE CASCADE
    ON UPDATE CASCADE;

-- Foreign keys para la tabla AUDIT_LOG
ALTER TABLE AUDIT_LOG
    ADD CONSTRAINT fk_audit_student
    FOREIGN KEY (id_student)
    REFERENCES STUDENTS (id)
    ON DELETE SET NULL
    ON UPDATE CASCADE;

ALTER TABLE AUDIT_LOG
    ADD CONSTRAINT fk_audit_administrator
    FOREIGN KEY (id_administrator)
    REFERENCES ADMINISTRATORS (id)
    ON DELETE SET NULL
    ON UPDATE CASCADE;

-- Foreign keys para la tabla CONVALIDATION_STATE_HISTORY
ALTER TABLE CONVALIDATION_STATE_HISTORY
    ADD CONSTRAINT fk_state_history_convalidation
    FOREIGN KEY (id_convalidation)
    REFERENCES CONVALIDATIONS (id)
    ON DELETE CASCADE
    ON UPDATE CASCADE;

-- Foreign keys para la tabla NOTIFICATIONS
ALTER TABLE NOTIFICATIONS
    ADD CONSTRAINT fk_notification_student
    FOREIGN KEY (id_student)
    REFERENCES STUDENTS (id)
    ON DELETE CASCADE
    ON UPDATE CASCADE;

ALTER TABLE NOTIFICATIONS
    ADD CONSTRAINT fk_notification_administrator
    FOREIGN KEY (id_administrator)
    REFERENCES ADMINISTRATORS (id)
    ON DELETE CASCADE
    ON UPDATE CASCADE;


--------------------------------------------------------------------------------------------------------------
----------------------------------------- ÍNDICES -----------------------------------------------------------
--------------------------------------------------------------------------------------------------------------

-- Índices para búsquedas rápidas en CONVALIDATIONS
CREATE INDEX idx_convalidation_request ON CONVALIDATIONS (id_request);

-- Índices para búsquedas en WORKSHOPS
CREATE INDEX idx_workshop_name ON WORKSHOPS (name);
CREATE INDEX idx_workshop_semester_year ON WORKSHOPS (semester, year);

-- Índices para búsquedas en STUDENTS
CREATE INDEX idx_student_rut ON STUDENTS (rut_student);
CREATE INDEX idx_student_email ON STUDENTS (email);

-- Índices para búsquedas en REQUESTS
CREATE INDEX idx_request_student ON REQUESTS (id_student);
CREATE INDEX idx_request_date ON REQUESTS (creation_date);
CREATE INDEX idx_request_creation_date ON REQUESTS(creation_date);

-- Índices para AUDIT_LOG
CREATE INDEX idx_audit_table_record ON AUDIT_LOG (table_name, record_id);
CREATE INDEX idx_audit_action ON AUDIT_LOG (action);
CREATE INDEX idx_audit_user ON AUDIT_LOG (id_student, id_administrator, user_type);
CREATE INDEX idx_audit_timestamp ON AUDIT_LOG (timestamp);

-- Índices para historial de estados
CREATE INDEX idx_convalidation_state_history ON CONVALIDATION_STATE_HISTORY (id_convalidation, timestamp);

-- Índices para notificaciones
CREATE INDEX idx_notifications_user ON NOTIFICATIONS (id_student, id_administrator, user_type);
CREATE INDEX idx_notifications_type ON NOTIFICATIONS (type);
CREATE INDEX idx_notifications_read ON NOTIFICATIONS (is_read, created_at);


--------------------------------------------------------------------------------------------------------------
------------------------------------ CONSTRAINTS ------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------

-- Restricción CHECK para la tabla CONVALIDATIONS
ALTER TABLE CONVALIDATIONS
    ADD CONSTRAINT chk_convalidation_type
    CHECK (
        (id_subject_to_convalidate IS NOT NULL AND id_workshop_to_convalidate IS NULL AND certified_course_name IS NULL AND personal_project_name IS NULL) OR
        (id_subject_to_convalidate IS NULL AND id_workshop_to_convalidate IS NOT NULL AND certified_course_name IS NULL AND personal_project_name IS NULL) OR
        (id_subject_to_convalidate IS NULL AND id_workshop_to_convalidate IS NULL AND certified_course_name IS NOT NULL AND personal_project_name IS NULL) OR
        (id_subject_to_convalidate IS NULL AND id_workshop_to_convalidate IS NULL AND certified_course_name IS NULL AND personal_project_name IS NOT NULL)
    );

-- Restricción CHECK para la tabla WORKSHOPS_GRADES
ALTER TABLE WORKSHOPS_GRADES
    ADD CONSTRAINT chk_grade
    CHECK (grade BETWEEN 0 AND 100);

-- Restricción UNIQUE para la tabla WORKSHOPS_INSCRIPTIONS
ALTER TABLE WORKSHOPS_INSCRIPTIONS
    ADD CONSTRAINT uk_student_workshop
    UNIQUE (id_student, id_workshop);


SELECT "Estructura de la base de datos creada correctamente";
