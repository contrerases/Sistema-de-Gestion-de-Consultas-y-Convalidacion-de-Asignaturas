

SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS CONVALIDATIONS;
DROP TABLE IF EXISTS ADMINISTRATORS;
DROP TABLE IF EXISTS STUDENTS;
DROP TABLE IF EXISTS AUTH_STUDENTS;
DROP TABLE IF EXISTS SUBJECTS;
DROP TABLE IF EXISTS COURSES;

DROP TABLE IF EXISTS CURRICULUM_COURSES;
DROP TABLE IF EXISTS WORKSHOPS;
DROP TABLE IF EXISTS DEPARTMENTS;
DROP TABLE IF EXISTS SUBJECTS;

DROP TABLE IF EXISTS REQUESTS;

DROP TABLE IF EXISTS TYPES_CONVALIDATIONS;

DROP TABLE IF EXISTS TYPES_CURRICULUM_COURSES;

DROP TABLE IF EXISTS WORKSHOPS_INSCRIPTIONS;

DROP TABLE IF EXISTS WORKSHOPS_GRADES;



CREATE TABLE ADMINISTRATORS (
    id INT AUTO_INCREMENT NOT NULL,
    first_name VARCHAR(255) NOT NULL,
    second_name VARCHAR(255) NOT NULL,
    first_last_name VARCHAR(255) NOT NULL,
    second_last_name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    PRIMARY KEY (id)
);

-- Tabla Alumnos
CREATE TABLE STUDENTS (
    id INT AUTO_INCREMENT NOT NULL,
    rol_student VARCHAR(10) UNIQUE NOT NULL,
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


CREATE TABLE TYPES_CONVALIDATIONS ( 
    id INT AUTO_INCREMENT NOT NULL, 
    name VARCHAR(255) NOT NULL UNIQUE, -- Asignatura INF, Asignatutra Externa, Curso Certificado, Taller de INF, Proyecto Personal
    PRIMARY KEY (id)
);

CREATE TABLE TYPES_CURRICULUM_COURSES(
    id INT AUTO_INCREMENT NOT NULL,
    name VARCHAR(255) NOT NULL UNIQUE,  -- Libre, Electivo, Electivo INF
    PRIMARY KEY (id)
);

CREATE TABLE CURRICULUM_COURSES (
    id INT NOT NULL AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL UNIQUE, -- libre 1 .. n , Electivo 1 ... n m Electivo Informatica 1 ... n
    id_type_curriculum_course INT NOT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (id_type_curriculum_course) REFERENCES TYPES_CURRICULM_COURSES (id)
);

CREATE TABLE DEPARTMENTS (
    id INT AUTO_INCREMENT NOT NULL,
    name VARCHAR(255) NOT NULL UNIQUE,
    PRIMARY KEY (id)
);






CREATE TABLE SUBJECTS (
    id INT AUTO_INCREMENT NOT NULL,
    acronym VARCHAR(255) UNIQUE NOT NULL,	
    name VARCHAR(255) UNIQUE NOT NULL,
    id_department INT NOT NULL,
    credits INT NOT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (id_department) REFERENCES DEPARTMENTS (id) 
);


CREATE TABLE REQUESTS (
    id INT NOT NULL AUTO_INCREMENT,
    id_student INT NOT NULL,
    creation_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    revision_date TIMESTAMP,
    comments TEXT DEFAULT NULL,
    id_user_approves INT DEFAULT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (id_student) REFERENCES STUDENTS (id),
    FOREIGN KEY (id_user_approves) REFERENCES ADMINISTRATORS (id)
);



CREATE TABLE CONVALIDATIONS (
    id INT NOT NULL AUTO_INCREMENT,
    id_request INT NOT NULL,
    id_convalidation_type INT NOT NULL, -- Asignatura INF, Asignatutra Externa,  Curso Certificado,Taller de INF, Proyecto Personal
      state ENUM('Enviada', 'Rechazada', 'Aprobada por DI', 'En espera de DE', 'Aprobada por DE') NOT NULL DEFAULT 'Enviada',  -- Enviada, Rechazada, Aprobada por DI, En espera de DE, Aprobada por DE
    id_curriculum_course INT NOT NULL,
    id_subject_to_convalidate INT NULL,
    id_workshop_to_convalidate INT NULL,
    certified_course_name VARCHAR(255) NULL,
    personal_project_name VARCHAR(255) NULL,
    file_data LONGBLOB DEFAULT NULL,
    file_name VARCHAR(255) DEFAULT NULL, 
    PRIMARY KEY (id),
    FOREIGN KEY (id_request) REFERENCES REQUESTS (id),
    FOREIGN KEY (id_convalidation_type) REFERENCES TYPES_CONVALIDATIONS (id),
    FOREIGN KEY (id_curriculum_course) REFERENCES CURRICULUM_COURSES (id),   
    CONSTRAINT fk_subject FOREIGN KEY (id_subject_to_convalidate) REFERENCES SUBJECTS (id),
    CONSTRAINT fk_workshop FOREIGN KEY (id_workshop_to_convalidate) REFERENCES WORKSHOPS (id),
    INDEX (id_request)
);

CREATE TABLE WORKSHOPS (
    id INT AUTO_INCREMENT NOT NULL,
    name VARCHAR(255) NOT NULL UNIQUE,
    semester ENUM('1', '2') NOT NULL,
    year INT NOT NULL,
    professor VARCHAR(255) NOT NULL,
    initial_date TIMESTAMP NOT NULL,
    file_data LONGBLOB DEFAULT NULL,
    available BOOLEAN NOT NULL DEFAULT TRUE,
    PRIMARY KEY (id)
);


CREATE TABLE WORKSHOPS_INSCRIPTIONS (
    id INT AUTO_INCREMENT NOT NULL,
    id_student INT NOT NULL,
    id_workshop INT NOT NULL,
    id_curriculum_course INT NOT NULL, -- libre 
    is_convalidated BOOLEAN NOT NULL DEFAULT FALSE,
    PRIMARY KEY (id),
    FOREIGN KEY (id_student) REFERENCES STUDENTS (id),
    FOREIGN KEY (id_workshop) REFERENCES WORKSHOPS (id),
    FOREIGN KEY (id_curriculum_course) REFERENCES CURRICULUM_COURSES (id)
);

CREATE TABLE WORKSHOPS_GRADES (
    id INT AUTO_INCREMENT NOT NULL,
    id_student INT NOT NULL,
    id_workshop INT NOT NULL,
    grade INT NOT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (id_student) REFERENCES STUDENTS (id),
    FOREIGN KEY (id_workshop) REFERENCES WORKSHOPS (id)
);


