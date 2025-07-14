--------------------------------------------------------------------------------------------------------
---------------------------------- ESTRUCTURA DE LA BASE DE DATOS --------------------------------------
--------------------------------------------------------------------------------------------------------

-- =============================================================================
-- RESUMEN DE TABLAS
-- =============================================================================
-- Total de tablas: 25
-- Catálogos: 8 | Maestras: 4 | Negocio: 12 | Usuario: 2 | Autenticación: 2 | Auditoría: 2

-- =============================================================================
-- CONFIGURACIÓN INICIAL
-- =============================================================================

SET FOREIGN_KEY_CHECKS = 0;

-- Eliminación de tablas en orden inverso (dependencias primero)
DROP TABLE IF EXISTS AUDIT_LOG;
DROP TABLE IF EXISTS NOTIFICATIONS;
DROP TABLE IF EXISTS USER_SESSIONS;
DROP TABLE IF EXISTS AUTH_USERS;
DROP TABLE IF EXISTS WORKSHOPS_GRADES;
DROP TABLE IF EXISTS WORKSHOPS_INSCRIPTIONS;
DROP TABLE IF EXISTS CONVALIDATIONS_PERSONAL_PROJECTS;
DROP TABLE IF EXISTS CONVALIDATIONS_CERTIFIED_COURSES;
DROP TABLE IF EXISTS CONVALIDATIONS_WORKSHOPS;
DROP TABLE IF EXISTS CONVALIDATIONS_SUBJECTS;
DROP TABLE IF EXISTS CONVALIDATIONS;
DROP TABLE IF EXISTS REQUESTS;
DROP TABLE IF EXISTS WORKSHOPS;
DROP TABLE IF EXISTS CURRICULUM_COURSES;
DROP TABLE IF EXISTS SUBJECTS;
DROP TABLE IF EXISTS STUDENTS;
DROP TABLE IF EXISTS ADMINISTRATORS;
DROP TABLE IF EXISTS DEPARTMENTS;
DROP TABLE IF EXISTS AUDIT_TABLES;
DROP TABLE IF EXISTS NOTIFICATION_TYPES;
DROP TABLE IF EXISTS AUDIT_FIELDS;
DROP TABLE IF EXISTS AUDIT_ACTIONS;
DROP TABLE IF EXISTS CONVALIDATION_STATES;
DROP TABLE IF EXISTS WORKSHOP_STATES;
DROP TABLE IF EXISTS TYPES_CURRICULUM_COURSES;
DROP TABLE IF EXISTS TYPES_CONVALIDATIONS;

-- Eliminación de triggers
DROP TRIGGER IF EXISTS tr_auth_users_before_insert;
DROP TRIGGER IF EXISTS tr_auth_users_before_update;
DROP TRIGGER IF EXISTS tr_requests_before_insert;
DROP TRIGGER IF EXISTS tr_requests_before_update;
DROP TRIGGER IF EXISTS tr_workshops_inscriptions_before_insert;
DROP TRIGGER IF EXISTS tr_workshops_inscriptions_before_update;

SET FOREIGN_KEY_CHECKS = 1;

-- =============================================================================
-- TABLAS DE CATÁLOGOS
-- =============================================================================

-- Tipos de convalidaciones disponibles
CREATE TABLE IF NOT EXISTS TYPES_CONVALIDATIONS (
    id INT AUTO_INCREMENT NOT NULL,
    name VARCHAR(255) NOT NULL,
    PRIMARY KEY (id)
);

-- Tipos de cursos del currículum
CREATE TABLE IF NOT EXISTS TYPES_CURRICULUM_COURSES (
    id INT AUTO_INCREMENT NOT NULL,
    name VARCHAR(255) NOT NULL,
    PRIMARY KEY (id)
);

-- Estados de talleres
CREATE TABLE IF NOT EXISTS WORKSHOP_STATES (
    id INT AUTO_INCREMENT NOT NULL,
    name VARCHAR(255) NOT NULL,
    description TEXT(1000) NULL,
    is_active TINYINT(1) NOT NULL DEFAULT 1,
    PRIMARY KEY (id)
);

-- Estados de convalidaciones
CREATE TABLE IF NOT EXISTS CONVALIDATION_STATES (
    id INT AUTO_INCREMENT NOT NULL,
    name VARCHAR(255) NOT NULL,
    description TEXT(1000) NULL,
    is_active TINYINT(1) NOT NULL DEFAULT 1,
    PRIMARY KEY (id)
);


-- Acciones de auditoría
CREATE TABLE IF NOT EXISTS AUDIT_ACTIONS (
    id INT AUTO_INCREMENT NOT NULL,
    name VARCHAR(255) NOT NULL,
    description TEXT(1000) NULL,
    PRIMARY KEY (id)
);

-- Campos de auditoría
CREATE TABLE IF NOT EXISTS AUDIT_FIELDS (
    id INT AUTO_INCREMENT NOT NULL,
    name VARCHAR(255) NOT NULL,
    description TEXT(1000) NULL,
    PRIMARY KEY (id)
);

-- Tipos de notificación
CREATE TABLE IF NOT EXISTS NOTIFICATION_TYPES (
    id INT AUTO_INCREMENT NOT NULL,
    name VARCHAR(255) NOT NULL,
    description TEXT(1000) NULL,
    is_active TINYINT(1) NOT NULL DEFAULT 1,
    PRIMARY KEY (id)
);

-- Nombres de tablas para auditoría
CREATE TABLE IF NOT EXISTS AUDIT_TABLES (
    id INT AUTO_INCREMENT NOT NULL,
    name VARCHAR(255) NOT NULL,
    description TEXT(1000) NULL,
    PRIMARY KEY (id)
);

-- =============================================================================
-- TABLAS MAESTRAS
-- =============================================================================

-- Departamentos académicos
CREATE TABLE IF NOT EXISTS DEPARTMENTS (
    id INT AUTO_INCREMENT NOT NULL,
    name VARCHAR(255) NOT NULL,
    PRIMARY KEY (id)
);

-- Asignaturas de la universidad
CREATE TABLE IF NOT EXISTS SUBJECTS (
    id INT AUTO_INCREMENT NOT NULL,
    acronym VARCHAR(255) NOT NULL,
    name VARCHAR(255) NOT NULL,
    id_department INT NOT NULL,
    credits INT NOT NULL,
    PRIMARY KEY (id)
);

-- Cursos del currículum
CREATE TABLE IF NOT EXISTS CURRICULUM_COURSES (
    id INT NOT NULL AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    id_type_curriculum_course INT NOT NULL,
    PRIMARY KEY (id)
);

-- Talleres ofrecidos
CREATE TABLE IF NOT EXISTS WORKSHOPS (
    id INT AUTO_INCREMENT NOT NULL,
    name VARCHAR(255) NOT NULL,
    semester ENUM('1', '2') NOT NULL,
    year INT NOT NULL,
    professor VARCHAR(255) NOT NULL,
    description TEXT(1000) NOT NULL,
    inscription_start_date TIMESTAMP NOT NULL,
    inscription_end_date TIMESTAMP NOT NULL,
    course_start_date TIMESTAMP NOT NULL,
    course_end_date TIMESTAMP NOT NULL,
    syllabus_data LONGBLOB DEFAULT NULL,
    available TINYINT(1) NOT NULL DEFAULT 1,
    id_workshop_state INT NOT NULL,
    PRIMARY KEY (id)
);

-- =============================================================================
-- TABLAS DE NEGOCIO
-- =============================================================================

-- Solicitudes de convalidación
CREATE TABLE IF NOT EXISTS REQUESTS (
    id INT NOT NULL AUTO_INCREMENT,
    id_student INT NOT NULL,
    sent_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    id_reviewed_by INT NULL,
    reviewed_at TIMESTAMP NULL,
    review_comments TEXT(1000) NULL,
    PRIMARY KEY (id)
);

-- Convalidaciones
CREATE TABLE IF NOT EXISTS CONVALIDATIONS (
    id INT NOT NULL AUTO_INCREMENT,
    id_request INT NOT NULL,
    id_convalidation_type INT NOT NULL,
    id_convalidation_state INT NOT NULL,
    id_curriculum_course INT NOT NULL,
    review_comments TEXT(1000) NULL,
    PRIMARY KEY (id)
);

-- Convalidaciones de asignaturas
CREATE TABLE IF NOT EXISTS CONVALIDATIONS_SUBJECTS (
    id_convalidation INT NOT NULL,
    id_subject INT NOT NULL,
    PRIMARY KEY (id_convalidation)
);

-- Convalidaciones de talleres
CREATE TABLE IF NOT EXISTS CONVALIDATIONS_WORKSHOPS (
    id_convalidation INT NOT NULL,
    id_workshop INT NOT NULL,
    PRIMARY KEY (id_convalidation)
);

-- Convalidaciones de cursos certificados
CREATE TABLE IF NOT EXISTS CONVALIDATIONS_CERTIFIED_COURSES (
    id_convalidation INT NOT NULL,
    course_name VARCHAR(255) NOT NULL,
    file_data LONGBLOB DEFAULT NULL,
    file_name VARCHAR(255) DEFAULT NULL,
    PRIMARY KEY (id_convalidation)
);

-- Convalidaciones de proyectos personales
CREATE TABLE IF NOT EXISTS CONVALIDATIONS_PERSONAL_PROJECTS (
    id_convalidation INT NOT NULL,
    project_name VARCHAR(255) NOT NULL,
    file_data LONGBLOB DEFAULT NULL,
    file_name VARCHAR(255) DEFAULT NULL,
    PRIMARY KEY (id_convalidation)
);

-- Inscripciones a talleres
CREATE TABLE IF NOT EXISTS WORKSHOPS_INSCRIPTIONS (
    id INT AUTO_INCREMENT NOT NULL,
    id_student INT NOT NULL,
    id_workshop INT NOT NULL,
    id_curriculum_course INT NULL,
    is_convalidated TINYINT(1) NOT NULL DEFAULT 0,
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

-- =============================================================================
-- TABLAS DE USUARIO
-- =============================================================================

-- Estudiantes del sistema
CREATE TABLE IF NOT EXISTS STUDENTS (
    id INT AUTO_INCREMENT NOT NULL,
    rol_student VARCHAR(11) NOT NULL,
    rut_student VARCHAR(12) NOT NULL,
    campus_student VARCHAR(255) NOT NULL,
    first_names VARCHAR(255) NOT NULL,
    last_names VARCHAR(255) NOT NULL,
    common_name VARCHAR(255) GENERATED ALWAYS AS (
        CONCAT(
            SUBSTRING_INDEX(first_names, ' ', 1),
            ' ',
            SUBSTRING_INDEX(last_names, ' ', 1)
        )
    ) STORED,
    full_name VARCHAR(255) GENERATED ALWAYS AS (
        CONCAT(first_names, ' ', last_names)
    ) STORED,
    PRIMARY KEY (id)
);

-- Administradores del sistema
CREATE TABLE IF NOT EXISTS ADMINISTRATORS (
    id INT AUTO_INCREMENT NOT NULL,
    first_names VARCHAR(255) NOT NULL,
    last_names VARCHAR(255) NOT NULL,
    common_name VARCHAR(255) GENERATED ALWAYS AS (
        CONCAT(
            SUBSTRING_INDEX(first_names, ' ', 1),
            ' ',
            SUBSTRING_INDEX(last_names, ' ', 1)
        )
    ) STORED,
    full_name VARCHAR(255) GENERATED ALWAYS AS (
        CONCAT(first_names, ' ', last_names)
    ) STORED,
    PRIMARY KEY (id)
);

-- =============================================================================
-- TABLAS DE AUTENTICACIÓN
-- =============================================================================

-- Autenticación centralizada
CREATE TABLE IF NOT EXISTS AUTH_USERS (
    id INT AUTO_INCREMENT NOT NULL,
    email VARCHAR(255) NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    user_type ENUM('STUDENT', 'ADMINISTRATOR') NOT NULL,
    id_user INT NOT NULL,
    is_active TINYINT(1) NOT NULL DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- Sesiones
CREATE TABLE IF NOT EXISTS USER_SESSIONS (
    id INT AUTO_INCREMENT NOT NULL,
    id_auth_user INT NOT NULL,
    session_token VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    expires_at TIMESTAMP NOT NULL,
    PRIMARY KEY (id)
);

-- =============================================================================
-- TABLAS DE AUDITORÍA
-- =============================================================================

-- Registro de auditoría
CREATE TABLE IF NOT EXISTS AUDIT_LOG (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_audit_table INT NOT NULL,
    id_record INT NOT NULL,
    id_audit_action INT NOT NULL,
    id_audit_field INT NULL,
    old_value VARCHAR(1000) NULL,
    new_value VARCHAR(1000) NULL,
    id_auth_user INT NOT NULL,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    id_session VARCHAR(255) NULL,
    additional_data JSON NULL
);

-- Notificaciones del sistema
CREATE TABLE IF NOT EXISTS NOTIFICATIONS (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_auth_user INT NOT NULL,
    id_notification_type INT NOT NULL,
    title VARCHAR(255) NOT NULL,
    message TEXT(1000) NOT NULL,
    is_read TINYINT(1) DEFAULT 0,
    is_sent TINYINT(1) DEFAULT 0,
    id_notification_related_table INT NULL,
    related_id INT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    read_at TIMESTAMP NULL,
    sent_at TIMESTAMP NULL
);

SELECT "Estructura de la base de datos creada correctamente" AS mensaje;
