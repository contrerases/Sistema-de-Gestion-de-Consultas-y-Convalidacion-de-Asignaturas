INSERT INTO ADMINISTRATORS (first_name, second_name, first_last_name, second_last_name, email, password) 
VALUES 
('Juan', 'Carlos', 'González', 'Pérez', 'juan@example.com', 'password123'),
('María', 'Luisa', 'Martínez', 'García', 'maria@example.com', 'secret123'),
('Pedro', '', 'Ramírez', 'López', 'pedro@example.com', 'admin123');


INSERT INTO STUDENTS (rol_student, first_name, second_name, first_last_name, second_last_name, email, password) 
VALUES 
('A001', 'José', 'Manuel', 'Gutiérrez', 'Rodríguez', 'jose@example.com', 'student123'),
('A002', 'Ana', 'María', 'Sánchez', 'Gómez', 'ana@example.com', 'test123'),
('A003', 'Luis', 'Miguel', 'Fernández', 'Pérez', 'luis@example.com', 'pass123');


INSERT INTO TYPES_COURSES (name) 
VALUES 
('Asignatura INF'),
('Asignatura Externa'),
('Curso Certificado'),
('Taller de INF'),
('Proyecto Personal');


INSERT INTO GENERIC_COURSES (name) 
VALUES 
('Introducción a la Programación'),
('Base de Datos Avanzadas'),
('Diseño de Interfaces de Usuario');


INSERT INTO WORKSHOPS (name) 
VALUES 
('Taller de Python'),
('Taller de Desarrollo Web'),
('Taller de Machine Learning');


INSERT INTO DEPARTMENTS (name) 
VALUES 
('Informática'),
('Matemáticas'),
('Ciencias Sociales');


INSERT INTO SPECIFIC_COURSES (acronym, name, id_department, credits) 
VALUES 
('INF101', 'Introducción a la Programación', 1, 4),
('DBA201', 'Base de Datos Avanzadas', 1, 5),
('WEB301', 'Desarrollo Web Avanzado', 1, 5),
('MAT101', 'Cálculo I', 2, 4),
('SOC201', 'Sociología General', 3, 3);

INSERT INTO CONVALIDATIONS (id_student, convalidation_type, id_generic_course, id_specific_course, state, comments, creation_date, revision_date, user_approves) 
VALUES 
(1, 1, 1, 1, 'Aprobada por DI', 'Convalidación aprobada', '2024-04-25 12:00:00', '2024-04-26 10:00:00', 1),
(2, 3, 3, 3, 'En espera de DE', 'Convalidación pendiente de revisión', '2024-04-26 14:00:00', NULL, 2),
(3, 2, 2, 2, 'Enviada', NULL, '2024-04-27 09:00:00', NULL, 3);
