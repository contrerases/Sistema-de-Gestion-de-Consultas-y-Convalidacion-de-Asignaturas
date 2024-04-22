-- Crea la base de datos
CREATE DATABASE IF NOT EXISTS SGC;

USE SGC;



-- Tabla Administradores

DROP TABLE IF EXISTS `CONVALIDATIONS`;
DROP TABLE IF EXISTS `ADMINISTRATORS`;
DROP TABLE IF EXISTS `STUDENTS`;
DROP TABLE IF EXISTS `AUTH_STUDENTS`;
DROP TABLE IF EXISTS `SUBJECTS`;
DROP TABLE IF EXISTS `COURSES`;



CREATE TABLE
    `ADMINISTRATORS` (
        `id` INT NOT NULL AUTO_INCREMENT,
        `first_name` VARCHAR(255) NOT NULL,
        `second_name` VARCHAR(255) NOT NULL,
        `first_last_name` VARCHAR(255) NOT NULL,
        `second_last_name` VARCHAR(255) NOT NULL,
        `email` VARCHAR(255) NOT NULL UNIQUE,
        `password` VARCHAR(255) NOT NULL,
        PRIMARY KEY (`id`)
    );






-- Tabla Alumnos
CREATE TABLE
    `STUDENTS` (
        `rol` VARCHAR(10) NOT NULL UNIQUE,
        `verificator_number` VARCHAR(1) NOT NULL CHECK (verificator_number REGEXP '^[0-9K]$'),
        `first_name` VARCHAR(255) NOT NULL,
        `second_name` VARCHAR(255) NOT NULL,
        `first_last_name` VARCHAR(255) NOT NULL,
        `second_last_name` VARCHAR(255) NOT NULL,
        PRIMARY KEY (`rol`)
    );




CREATE TABLE
    `AUTH_STUDENTS` (
        `rol` VARCHAR(10) NOT NULL UNIQUE,
        `email` VARCHAR(255) NOT NULL UNIQUE,
        `password_hash` VARCHAR(255) NOT NULL,
        `token` VARCHAR(255) NOT NULL,
        `expiration_date` TIMESTAMP NOT NULL,
        PRIMARY KEY (`rol`),
        FOREIGN KEY (`rol`) REFERENCES `STUDENTS` (`rol`)
    );

-- Tabla Cursos


CREATE TABLE
    `SUBJECTS` (
        `id` INT NOT NULL AUTO_INCREMENT,
        `name` VARCHAR(255) NOT NULL UNIQUE,
        `type` VARCHAR(100) NOT NULL,
        PRIMARY KEY (`id`)
    );



CREATE TABLE
    `COURSES` (
        `id` INT NOT NULL AUTO_INCREMENT,
        `acronym` VARCHAR(255) NOT NULL UNIQUE,	
        `name` VARCHAR(255) NOT NULL,
        PRIMARY KEY (`id`)
    );




-- Tabla Convalidaciones
CREATE TABLE
    `CONVALIDATIONS` (
        `id` INT NOT NULL AUTO_INCREMENT,
        `rol` VARCHAR(10) NOT NULL,
        `id_origin_course` INT NOT NULL,
        `id_destination_course` INT NOT NULL,
        `state` VARCHAR(50) NOT NULL DEFAULT 'En revisión',
        `comments` TEXT DEFAULT NULL,
        `creation_date` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
        `approval_date` TIMESTAMP,
        `user_approves` INT NOT NULL,
        PRIMARY KEY (`id`),
        FOREIGN KEY (`rol`) REFERENCES `STUDENTS` (`rol`),
        FOREIGN KEY (`id_origin_course`) REFERENCES `COURSES` (`id`),
        FOREIGN KEY (`id_destination_course`) REFERENCES `SUBJECTS` (`id`),
        FOREIGN KEY (`user_approves`) REFERENCES `ADMINISTRATORS` (`id`)
    );

