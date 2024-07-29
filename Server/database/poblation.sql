-- Poblar la tabla ADMINISTRATORS
INSERT INTO ADMINISTRATORS (first_name, second_name, first_last_name, second_last_name, email, password) VALUES
('John', 'Michael', 'Doe', 'Smith', 'john.doe@example.com', 'password123'),
('Jane', 'Alice', 'Doe', 'Johnson', 'jane.doe@example.com', 'password456');

-- Poblar la tabla STUDENTS
INSERT INTO STUDENTS (rol_student, rut_student, campus_student, first_name, second_name, first_last_name, second_last_name, email, password) VALUES
('2019012345', '12345678-9', 'Main Campus', 'Alice', 'Marie', 'Smith', 'Johnson', 'alice.smith@example.com', 'studentpass1'),
('2019012346', '98765432-1', 'Main Campus', 'Bob', 'James', 'Brown', 'Williams', 'bob.brown@example.com', 'studentpass2');

-- Poblar la tabla TYPES_CONVALIDATIONS
INSERT INTO TYPES_CONVALIDATIONS (name) VALUES
('Asignatura INF'),
('Asignatura Externa'),
('Curso Certificado'),
('Taller de INF'),
('Proyecto Personal');

-- Poblar la tabla TYPES_CURRICULUM_COURSES
INSERT INTO TYPES_CURRICULUM_COURSES (name) VALUES
('Libre'),
('Electivo'),
('Electivo INF');

-- Poblar la tabla CURRICULUM_COURSES
INSERT INTO CURRICULUM_COURSES (name, id_type_curriculum_course) VALUES
('Libre 1', 1),
('Electivo 1', 2),
('Electivo Informatica 1', 3);

-- Poblar la tabla DEPARTMENTS
INSERT INTO DEPARTMENTS (name) VALUES
('Computer Science'),
('Mathematics'),
('Physics');

-- Poblar la tabla WORKSHOPS
INSERT INTO WORKSHOPS (name) VALUES
('Advanced Programming Workshop'),
('Data Science Workshop');

-- Poblar la tabla SUBJECTS
INSERT INTO SUBJECTS (acronym, name, id_department, credits) VALUES
('CS101', 'Introduction to Computer Science', 1, 3),
('CS102', 'Data Structures', 1, 4),
('MATH101', 'Calculus I', 2, 4);

-- Poblar la tabla REQUESTS
INSERT INTO REQUESTS (id_student, revision_date, comments, id_user_approves) VALUES
(1, '2024-07-28 10:00:00', 'Pending review', 1),
(2, '2024-07-29 11:00:00', 'Approved', 2);

-- Poblar la tabla CONVALIDATIONS
INSERT INTO CONVALIDATIONS (id_request, id_convalidation_type, state, id_curriculum_course, id_subject_to_convalidate, id_workshop_to_convalidate, certified_course_name, personal_project_name, file_data, file_name) VALUES
(1, 1, 'Enviada', 1, 1, NULL, NULL, NULL, NULL, NULL),
(2, 3, 'Aprobada por DI', 2, NULL, 1, 'Certified Data Science Course', NULL, NULL, NULL);
