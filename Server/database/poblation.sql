INSERT INTO DEPARTMENTS (name) VALUES
('Computer Science'),
('Mathematics'),
('Physics');


INSERT INTO ADMINISTRATORS (first_name, second_name, first_last_name, second_last_name, email, password) VALUES
('John', 'A.', 'Doe', 'Smith', 'john.doe@example.com', 'password123'),
('Jane', 'B.', 'Doe', 'Johnson', 'jane.doe@example.com', 'password123');

INSERT INTO STUDENTS (rol_student, rut_student, campus_student, first_name, second_name, first_last_name, second_last_name, email, password) VALUES
('ROL123', '12345678-9', 'Main Campus', 'Alice', 'C.', 'Johnson', 'Brown', 'alice.johnson@example.com', 'password123'),
('ROL456', '98765432-1', 'North Campus', 'Bob', 'D.', 'Smith', 'Davis', 'bob.smith@example.com', 'password123');

INSERT INTO TYPES_COURSES (name) VALUES
('INF Course'),
('External Course'),
('Certified Course'),
('INF Workshop'),
('Personal Project');

INSERT INTO CURRICULUM_COURSES (name) VALUES
('Introduction to Programming'),
('Data Structures'),
('Algorithms'),
('Linear Algebra');


INSERT INTO WORKSHOPS (name) VALUES
('Machine Learning Workshop'),
('Web Development Workshop');


INSERT INTO SUBJECTS (acronym, name, id_department, credits) VALUES
('CS101', 'Introduction to Computer Science', 1, 3),
('MATH201', 'Calculus I', 2, 4),
('PHYS301', 'Classical Mechanics', 3, 3);


INSERT INTO REQUESTS (id_student, creation_date, revision_date, comments, id_user_approves) VALUES
(1, '2023-07-01 10:00:00', NULL, 'Requesting course convalidation.', 1),
(2, '2023-07-02 11:00:00', NULL, 'Requesting workshop convalidation.', 2);


INSERT INTO CONVALIDATIONS (id_request, id_convalidation_type, state, id_curriculum_course, id_subject_to_convalidate, id_workshop_to_convalidate, certified_course_name, personal_project_name, file_data, file_name) VALUES
(1, 1, 'Enviada', 1, 1, NULL, NULL, NULL, NULL, NULL),
(2, 4, 'Enviada', 2, NULL, 1, NULL, NULL, NULL, NULL);


