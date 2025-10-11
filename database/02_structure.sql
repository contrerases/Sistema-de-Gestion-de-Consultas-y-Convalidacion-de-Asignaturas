--------------------------------------------------------------------------------------------------------
---------------------------------- ESTRUCTURA DE LA BASE DE DATOS --------------------------------------
--------------------------------------------------------------------------------------------------------

-- =============================================================================
-- CONFIGURACIÓN INICIAL
-- =============================================================================

SET FOREIGN_KEY_CHECKS = 0;

-- Eliminación de tablas en orden inverso (dependencias primero)
DROP TABLE IF EXISTS NOTIFICATIONS;
DROP TABLE IF EXISTS AUTH_USERS;
DROP TABLE IF EXISTS WORKSHOPS_GRADES;
DROP TABLE IF EXISTS WORKSHOPS_INSCRIPTIONS;
DROP TABLE IF EXISTS CONVALIDATIONS_EXTERNAL_ACTIVITIES;
DROP TABLE IF EXISTS CONVALIDATIONS_WORKSHOPS;
DROP TABLE IF EXISTS CONVALIDATIONS_SUBJECTS;
DROP TABLE IF EXISTS CONVALIDATIONS;
DROP TABLE IF EXISTS REQUESTS;
DROP TABLE IF EXISTS WORKSHOPS;
DROP TABLE IF EXISTS CURRICULUM_COURSE_SLOTS;
DROP TABLE IF EXISTS SUBJECTS;
DROP TABLE IF EXISTS ADMINISTRATORS;
DROP TABLE IF EXISTS DEPARTMENTS;
DROP TABLE IF EXISTS WORKSHOP_STATE_TRANSITIONS;
DROP TABLE IF EXISTS CONVALIDATION_STATE_TRANSITIONS;
DROP TABLE IF EXISTS CONVALIDATION_STATES;
DROP TABLE IF EXISTS WORKSHOP_STATES;
DROP TABLE IF EXISTS CURRICULUM_COURSES_TYPES;
DROP TABLE IF EXISTS CONVALIDATION_TYPES;
DROP TABLE IF EXISTS USERS;
DROP TABLE IF EXISTS AUTH_USERS;
DROP TABLE IF EXISTS PROFESSORS;
DROP TABLE IF EXISTS WORKSHOPS_TOKENS;
DROP TABLE IF EXISTS USER_TYPES;
DROP TABLE IF EXISTS CAMPUS;



SET FOREIGN_KEY_CHECKS = 1;

-- =============================================================================
-- TABLAS DE CATÁLOGOS
-- =============================================================================

-- Campus universitarios
CREATE TABLE IF NOT EXISTS CAMPUS (
    id INT AUTO_INCREMENT NOT NULL,
    acronym VARCHAR(10) NOT NULL UNIQUE,
    name VARCHAR(255) NOT NULL,
    location VARCHAR(255) NOT NULL,
    PRIMARY KEY (id)
);

-- Tipos de usuarios del sistema
CREATE TABLE IF NOT EXISTS USER_TYPES (
    id INT AUTO_INCREMENT NOT NULL,
    user_type VARCHAR(50) NOT NULL UNIQUE,
    PRIMARY KEY (id)
);

-- Tipos de convalidaciones disponibles

CREATE TABLE IF NOT EXISTS CONVALIDATION_TYPES (
    id INT AUTO_INCREMENT NOT NULL,
    name VARCHAR(255) NOT NULL,
    PRIMARY KEY (id)
);

-- Tipos de cursos del currículum
CREATE TABLE IF NOT EXISTS CURRICULUM_COURSES_TYPES (
    id INT AUTO_INCREMENT NOT NULL,
    name VARCHAR(255) NOT NULL,
    PRIMARY KEY (id)
);

-- Estados de talleres
CREATE TABLE IF NOT EXISTS WORKSHOP_STATES (
    id INT AUTO_INCREMENT NOT NULL,
    name VARCHAR(255) NOT NULL,
    description TEXT(1000) NULL,
    PRIMARY KEY (id)
);

-- Estados de convalidaciones
CREATE TABLE IF NOT EXISTS CONVALIDATION_STATES (
    id INT AUTO_INCREMENT NOT NULL,
    name VARCHAR(255) NOT NULL,
    description TEXT(1000) NULL,
    PRIMARY KEY (id)
);

-- Transiciones válidas de estados de talleres
CREATE TABLE IF NOT EXISTS WORKSHOP_STATE_TRANSITIONS (
    id_from_state INT NOT NULL,
    id_to_state INT NOT NULL,
    PRIMARY KEY (id_from_state, id_to_state)
);

-- Transiciones válidas de estados de convalidaciones
CREATE TABLE IF NOT EXISTS CONVALIDATION_STATE_TRANSITIONS (
    id_from_state INT NOT NULL,
    id_to_state INT NOT NULL,
    PRIMARY KEY (id_from_state, id_to_state)
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

-- Curriculum course slots (casillas curriculares)
CREATE TABLE IF NOT EXISTS CURRICULUM_COURSE_SLOTS (
    id INT NOT NULL AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    id_curriculum_course_type INT NOT NULL,
    PRIMARY KEY (id)
);

-- Talleres ofrecidos
CREATE TABLE IF NOT EXISTS WORKSHOPS (
    id INT AUTO_INCREMENT NOT NULL,
    name VARCHAR(255) NOT NULL,
    semester ENUM('1', '2') NOT NULL,
    year INT NOT NULL,
    id_professor INT NOT NULL,
    description TEXT(1000) NOT NULL,
    inscription_start_date TIMESTAMP NOT NULL,
    inscription_end_date TIMESTAMP NOT NULL,
    course_start_date TIMESTAMP NOT NULL,
    course_end_date TIMESTAMP NOT NULL,
    syllabus_path VARCHAR(500) DEFAULT NULL,
    id_workshop_state INT NOT NULL,
    inscriptions_number INT NOT NULL DEFAULT 0,
    limit_inscriptions INT NOT NULL DEFAULT 0,
    slug VARCHAR(255) AS (CONCAT(LOWER(REPLACE(name, ' ', '-')), '-', semester, '-', year)) STORED UNIQUE,
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
    id_reviewed_by INT NULL DEFAULT NULL,
    reviewed_at TIMESTAMP DEFAULT NULL,
    PRIMARY KEY (id)
);

-- Convalidaciones
CREATE TABLE IF NOT EXISTS CONVALIDATIONS (
    id INT NOT NULL AUTO_INCREMENT,
    id_request INT NOT NULL,
    id_convalidation_type INT NOT NULL,
    id_convalidation_state INT NOT NULL DEFAULT 1,
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

-- Convalidaciones de actividades externas (cursos certificados y proyectos personales, otros)
CREATE TABLE IF NOT EXISTS CONVALIDATIONS_EXTERNAL_ACTIVITIES (
    id_convalidation INT NOT NULL,
    activity_name VARCHAR(255) NOT NULL,
    description VARCHAR(255) NULL,
    file_path VARCHAR(500) NULL,
    PRIMARY KEY (id_convalidation)
);

-- Inscripciones a talleres
CREATE TABLE IF NOT EXISTS WORKSHOPS_INSCRIPTIONS (
    id INT AUTO_INCREMENT NOT NULL,
    id_student INT NOT NULL,
    id_workshop INT NOT NULL,
    id_curriculum_course INT NULL,
    is_convalidated TINYINT(1) NOT NULL DEFAULT 0,
    inscription_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- Calificaciones de talleres
CREATE TABLE IF NOT EXISTS WORKSHOPS_GRADES (
    id INT AUTO_INCREMENT NOT NULL,
    id_student INT NOT NULL,
    id_workshop INT NOT NULL,
    grade INT NOT NULL,
    evaluated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS WORKSHOPS_TOKENS (
    id INT AUTO_INCREMENT NOT NULL,
    id_workshop INT NOT NULL,
    token VARCHAR(255) UNIQUE NOT NULL,
    id_professor INT NOT NULL,
    expiration_at TIMESTAMP NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    used_at TIMESTAMP NULL,
    created_by INT NOT NULL,
    is_used BOOLEAN DEFAULT FALSE,
    PRIMARY KEY (id)
);



-- =============================================================================
-- TABLAS DE AUTENTICACIÓN
-- =============================================================================

CREATE TABLE IF NOT EXISTS AUTH_USERS (
    id INT AUTO_INCREMENT,
    email VARCHAR(255) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    PRIMARY KEY (id)
);

-- =============================================================================
-- TABLAS DE USUARIO
-- =============================================================================

-- Usuarios del sistema (estudiantes y administradores)
CREATE TABLE IF NOT EXISTS USERS (
    id INT NOT NULL,
    full_name VARCHAR(255) NOT NULL,
    id_campus INT NOT NULL,
    id_user_type INT NOT NULL,
    rol_student VARCHAR(11) NULL,
    rut_student VARCHAR(12) NULL,
    PRIMARY KEY (id),
    CONSTRAINT fk_user_auth FOREIGN KEY (id) REFERENCES AUTH_USERS(id) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_user_campus FOREIGN KEY (id_campus) REFERENCES CAMPUS(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_user_type FOREIGN KEY (id_user_type) REFERENCES USER_TYPES(id) ON DELETE RESTRICT ON UPDATE CASCADE
);






CREATE TABLE IF NOT EXISTS PROFESSORS (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL  
);




-- =============================================================================
-- TABLAS DE NOTIFICACIONES
-- =============================================================================

-- Notificaciones del sistema
CREATE TABLE IF NOT EXISTS NOTIFICATIONS (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_user INT NOT NULL,
    notification_type VARCHAR(50) NOT NULL,
    message TEXT(1000) NOT NULL,
    is_read TINYINT(1) DEFAULT 0,
    is_sent TINYINT(1) DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    read_at TIMESTAMP NULL,
    sent_at TIMESTAMP NULL
);


CREATE TABLE IF NOT EXISTS NOTIFICATION_TYPES (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    description TEXT(1000) NOT NULL
);


SELECT "Estructura de la base de datos creada correctamente" AS mensaje;
