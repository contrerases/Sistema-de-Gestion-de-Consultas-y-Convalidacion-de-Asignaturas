-- Datos de muestra para la tabla ADMINISTRATORS
INSERT INTO ADMINISTRATORS (first_name, second_name, first_last_name, second_last_name, email, password) VALUES
('John', 'Doe', 'Smith', 'Johnson', 'john.doe@example.com', 'admin123'),
('Alice', 'Smith', 'Brown', 'Davis', 'alice.smith@example.com', 'admin456');

-- Datos de muestra para la tabla STUDENTS
INSERT INTO STUDENTS (rol, verificator_number, first_name, second_name, first_last_name, second_last_name, email, password) VALUES
(10001, '5', 'Michael', 'Johnson', 'Garcia', 'Lopez', 'michael.johnson@example.com', 'password123'),
(10002, 'K', 'Emma', 'Brown', 'Martinez', 'Gonzalez', 'emma.brown@example.com', 'password456'),
(10003, '7', 'Olivia', 'Hernandez', 'Perez', 'Lopez', 'olivia.hernandez@example.com', 'password789');

-- Datos de muestra para la tabla SUBJECTS
INSERT INTO SUBJECTS (name, type) VALUES
('Introduction to Computer Science', 'Electivo'),
('Calculus I', 'Libre'),
('World History', 'Electivo');

-- Datos de muestra para la tabla COURSES
INSERT INTO COURSES (acronym, name) VALUES
('CS101', 'Computer Science'),
('MATH101', 'Mathematics'),
('HIST101', 'History');

-- Datos de muestra para la tabla CONVALIDATIONS
INSERT INTO CONVALIDATIONS (rol, id_origin_course, id_destination_course, state, comments, creation_date, approval_date, user_approves) VALUES
(10001, 1, 3, 'En revisión', 'Comentario de prueba', '2024-04-10 10:30:00', '2024-04-11 13:45:00', 1),
(10002, 2, 1, 'Aceptada por el jefe de carrera', 'Comentario de prueba', '2024-04-11 09:45:00', '2024-04-12 15:20:00', 2),
(10003, 3, 2, 'Rechazada', 'Comentario de prueba', '2024-04-12 08:30:00', '2024-04-13 11:10:00', 1),
(10003, 1, 3, 'Finalizada', 'Comentario de prueba', '2024-04-13 11:15:00', '2024-04-14 12:30:00', 2);
