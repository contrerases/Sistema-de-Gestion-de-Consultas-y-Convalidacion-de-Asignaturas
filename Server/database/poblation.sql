

-- Insertar datos de prueba en la tabla ADMINISTRATORS
INSERT INTO ADMINISTRATORS (first_name, second_name, first_last_name, second_last_name, email, password)
VALUES 
('Juan', 'Carlos', 'Pérez', 'González', 'juan.perez@example.com', 'password123'),
('Ana', 'María', 'López', 'Fernández', 'ana.lopez@example.com', 'password456');

-- Insertar datos de prueba en la tabla STUDENTS
INSERT INTO STUDENTS (rol_student, rut_student, campus_student, first_name, second_name, first_last_name, second_last_name, email, password)
VALUES 
('20210001', '12345678-9', 'Santiago', 'Luis', 'Alberto', 'García', 'Mendoza', 'luis.garcia@example.com', 'password789'),
('20210002', '98765432-1', 'Valparaíso', 'María', 'José', 'Rodríguez', 'López', 'maria.rodriguez@example.com', 'password321');

-- Insertar datos de prueba en la tabla TYPES_CONVALIDATIONS
INSERT INTO TYPES_CONVALIDATIONS (name)
VALUES 
('Asignatura INF'),
('Asignatura Externa'),
('Curso Certificado'),
('Taller de INF'),
('Proyecto Personal');

-- Insertar datos de prueba en la tabla TYPES_CURRICULM_COURSES
INSERT INTO TYPES_CURRICULM_COURSES (name)
VALUES 
('Libre'),
('Electivo Informática'),
('Electivo');

-- Insertar datos de prueba en la tabla CURRICULUM_COURSES
INSERT INTO CURRICULUM_COURSES (name, id_type_curriculum_course)
VALUES 
('Libre 1', 1),
('Libre 2', 1),
('Electivo 1', 3),
('Electivo de Informática 1', 2);

-- Insertar datos de prueba en la tabla DEPARTMENTS
INSERT INTO DEPARTMENTS (name)
VALUES 
('Departamento de Informática'),
('Departamento de Matemáticas');

-- Insertar datos de prueba en la tabla WORKSHOPS
INSERT INTO WORKSHOPS (name)
VALUES 
('Taller de Desarrollo Web'),
('Taller de Robótica');

-- Insertar datos de prueba en la tabla SUBJECTS
INSERT INTO SUBJECTS (acronym, name, id_department, credits)
VALUES 
('INF101', 'Introducción a la Informática', 1, 6),
('MAT101', 'Cálculo I', 2, 8);

-- Insertar datos de prueba en la tabla REQUESTS
INSERT INTO REQUESTS (id_student, creation_date, revision_date, comments, id_user_approves)
VALUES 
(1, '2023-01-01 10:00:00', '2023-01-05 14:00:00', 'Solicitud de convalidación', 1),
(2, '2023-02-01 11:00:00', '2023-02-05 15:00:00', 'Solicitud de convalidación', 2);

-- Insertar datos de prueba en la tabla CONVALIDATIONS
INSERT INTO CONVALIDATIONS (id_request, id_convalidation_type, state, id_curriculum_course, id_subject_to_convalidate, id_workshop_to_convalidate, certified_course_name, personal_project_name, file_data, file_name)
VALUES 
(1, 1, 'Enviada', 1, 1, NULL, NULL, NULL, NULL, NULL),
(2, 3, 'Enviada', 3, NULL, 1, 'Curso de Programación', NULL, NULL, NULL);

-- Reactivar restricciones de claves foráneas
SET FOREIGN_KEY_CHECKS = 1;
