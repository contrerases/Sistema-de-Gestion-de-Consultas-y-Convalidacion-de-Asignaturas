-- Insertar datos en la tabla ADMINISTRATORS
INSERT INTO ADMINISTRATORS (first_name, second_name, first_last_name, second_last_name, email, password)
VALUES 
('John', 'A.', 'Doe', 'Smith', 'john.doe@example.com', 'password123'),
('Jane', 'B.', 'Roe', 'Johnson', 'jane.roe@example.com', 'password456');

-- Insertar datos en la tabla STUDENTS
INSERT INTO STUDENTS (rol_student, rut_student, campus_student, first_name, second_name, first_last_name, second_last_name, email, password)
VALUES 
('20200001', '12345678-9', 'Main Campus', 'Alice', 'C.', 'Brown', 'Miller', 'alice.brown@example.com', 'password789'),
('20200002', '98765432-1', 'City Campus', 'Bob', 'D.', 'White', 'Taylor', 'bob.white@example.com', 'password012');

-- Insertar datos en la tabla TYPES_COURSES
INSERT INTO TYPES_COURSES (name)
VALUES 
('Asignatura INF'),
('Asignatura Externa'),
('Curso Certificado'),
('Taller de INF'),
('Proyecto Personal');

-- Insertar datos en la tabla DEPARTMENTS
INSERT INTO DEPARTMENTS (name)
VALUES 
('Computer Science'),
('Mathematics');

-- Insertar datos en la tabla CURRICULUM_COURSES
INSERT INTO CURRICULUM_COURSES (name)
VALUES 
('Algorithms'),
('Data Structures');

-- Insertar datos en la tabla WORKSHOPS
INSERT INTO WORKSHOPS (name)
VALUES 
('Workshop A'),
('Workshop B');

-- Insertar datos en la tabla SUBJECTS
INSERT INTO SUBJECTS (acronym, name, id_department, credits)
VALUES 
('CS101', 'Introduction to Computer Science', 1, 3),
('MATH201', 'Advanced Calculus', 2, 4);


-- Insertar datos en la tabla REQUESTS
INSERT INTO REQUESTS (id_student, comments, id_user_approves)
VALUES 
(1,  'Request for course convalidation', 1),
(2, 'Request for workshop convalidation', 2);


-- Insertar datos en la tabla CONVALIDATIONS
INSERT INTO CONVALIDATIONS (id_request, id_convalidation_type, state, id_curriculum_course, id_subject_to_convalidate, id_workshop_to_convalidate, certified_course_name, personal_project_name, file_data, file_name)
VALUES 
(1, 1, 'Enviada', 1, 1, NULL, NULL, NULL, NULL, NULL),
(1, 2, 'Enviada', 2, 2, NULL, NULL, NULL, NULL, NULL),
(2, 3, 'Enviada', 1, NULL, 1, 'Certified Course A', NULL, NULL, 'certificate_a.pdf'),
(2, 4, 'Enviada', 2, NULL, 2, NULL, 'Personal Project A', NULL, NULL);



