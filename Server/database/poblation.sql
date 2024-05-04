-- Insertar datos en la tabla ADMINISTRATORS
INSERT INTO ADMINISTRATORS (first_name, second_name, first_last_name, second_last_name, email, password) VALUES
('John', 'Doe', 'Smith', '', 'johndoe@example.com', 'password123'),
('Jane', 'Doe', 'Brown', '', 'janedoe@example.com', 'password456');

-- Insertar datos en la tabla STUDENTS
INSERT INTO STUDENTS (rol_student, first_name, second_name, first_last_name, second_last_name, email, password) VALUES
('A123', 'Alice', '', 'Johnson', '', 'alice@example.com', 'student123'),
('B456', 'Bob', '', 'Smith', '', 'bob@example.com', 'student456');

-- Insertar datos en la tabla TYPES_COURSES
INSERT INTO TYPES_COURSES (name) VALUES
('Subject INF'), ('External Subject'), ('Certified Course'), ('INF Workshop'), ('Personal Project');

-- Insertar datos en la tabla DEPARTMENTS
INSERT INTO DEPARTMENTS (name) VALUES
('Department A'), ('Department B'), ('Department C');

-- Insertar datos en la tabla CURRICULUM_COURSES
INSERT INTO CURRICULUM_COURSES (name) VALUES
('Course A'), ('Course B'), ('Course C');

-- Insertar datos en la tabla WORKSHOPS
INSERT INTO WORKSHOPS (name) VALUES
('Workshop 1'), ('Workshop 2'), ('Workshop 3');

-- Insertar datos en la tabla SUBJECTS
INSERT INTO SUBJECTS (acronym, name, id_department, credits) VALUES
('SUB1', 'Subject 1', 1, 3),
('SUB2', 'Subject 2', 2, 4),
('SUB3', 'Subject 3', 3, 5);

-- Insertar datos en la tabla CONVALIDATIONS
INSERT INTO CONVALIDATIONS (id_student, id_convalidation_type, id_user_approves, id_curriculum_course, id_subject_to_convalidate, id_workshop_to_convalidate, certified_course_name, personal_project_name, file_name) VALUES
(1, 1, 1, 1, 1, NULL, 'Course Name 1', NULL, 'file1.pdf'),
(2, 3, 2, 2, NULL, NULL, NULL, 'Project 1', 'file2.pdf');
