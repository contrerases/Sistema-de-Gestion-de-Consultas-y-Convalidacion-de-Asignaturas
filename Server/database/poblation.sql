INSERT INTO ADMINISTRATORS (first_name, second_name, first_last_name, second_last_name, email, password) VALUES
('Ana', 'Maria', 'Lopez', 'Martinez', 'ana.lopez@example.com', 'password123'),
('Luis', 'Carlos', 'Gomez', 'Fernandez', 'luis.gomez@example.com', 'password123'),
('Sofia', 'Elena', 'Ramirez', 'Mendez', 'sofia.ramirez@example.com', 'password123');


INSERT INTO STUDENTS (rol_student, rut_student, campus_student, first_name, second_name, first_last_name, second_last_name, email, password) VALUES
('2021001', '12345678-9', 'Campus Norte', 'Juan', 'Pablo', 'Pérez', 'García', 'juan.perez@example.com', 'password123'),
('2021002', '23456789-0', 'Campus Sur', 'María', 'José', 'González', 'Vásquez', 'maria.gonzalez@example.com', 'password123'),
('2021003', '34567890-1', 'Campus Centro', 'Carlos', 'Andrés', 'Martínez', 'Ortega', 'carlos.martinez@example.com', 'password123'),
('2021004', '45678901-2', 'Campus Este', 'Laura', 'Cristina', 'Fernández', 'Castro', 'laura.fernandez@example.com', 'password123'),
('2021005', '56789012-3', 'Campus Oeste', 'Pedro', 'Alejandro', 'Ramírez', 'Jara', 'pedro.ramirez@example.com', 'password123');


INSERT INTO TYPES_COURSES (name) VALUES
('Asignatura INF'),
('Asignatura Externa'),
('Curso Certificado'),
('Taller de INF'),
('Proyecto Personal');


INSERT INTO DEPARTMENTS (name) VALUES
('Departamento de Ingeniería'),
('Departamento de Ciencias Sociales'),
('Departamento de Humanidades');

INSERT INTO CURRICULUM_COURSES (name) VALUES
('Matemáticas Avanzadas'),
('Historia Contemporánea'),
('Literatura Inglesa');


INSERT INTO WORKSHOPS (name) VALUES
('Taller de Programación'),
('Taller de Escritura Creativa');


INSERT INTO SUBJECTS (acronym, name, id_department, credits) VALUES
('MAT201', 'Matemáticas II', 1, 6),
('HIS102', 'Historia del Mundo', 2, 5),
('LIT303', 'Literatura Contemporánea', 3, 4);


INSERT INTO REQUESTS (id_student, creation_date, revision_date, comments, id_user_approves) VALUES
(1, NOW(), NULL, 'Solicitud para convalidar Matemáticas Avanzadas.', 1),
(2, NOW(), NULL, 'Convalidación de Historia Contemporánea.', 2),
(3, NOW(), NULL, 'Solicitud de convalidación de Literatura Inglesa.', 3),
(4, NOW(), NULL, 'Petición para convalidar Taller de Programación.', 1),
(5, NOW(), NULL, 'Solicitud para convalidar Proyecto Personal.', 2);

INSERT INTO CONVALIDATIONS (id_request, id_convalidation_type, state, id_curriculum_course, id_subject_to_convalidate, id_workshop_to_convalidate, certified_course_name, personal_project_name, file_data, file_name) VALUES
-- Convalidaciones para la primera solicitud
(1, 1, 'Enviada', 1, NULL, NULL, NULL, NULL, NULL, NULL),
(1, 2, 'Enviada', 1, 1, NULL, NULL, NULL, NULL, NULL),
-- Convalidaciones para la segunda solicitud
(2, 3, 'Enviada', 1, NULL, NULL, NULL, NULL, NULL, NULL),
-- Convalidaciones para la tercera solicitud
(3, 1, 'Enviada', 1, 3, NULL, NULL, NULL, NULL, NULL),
-- Convalidaciones para la cuarta solicitud
(4, 4, 'Enviada', 1, NULL, 1, NULL, NULL, NULL, NULL),
-- Convalidaciones para la quinta solicitud
(5, 5, 'Enviada', 1, NULL, NULL, NULL, 'Proyecto Innovador', NULL, NULL);



