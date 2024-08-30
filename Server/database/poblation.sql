INSERT INTO ADMINISTRATORS (first_name, second_name, first_last_name, second_last_name, email, password)
VALUES 
('Juan', 'Carlos', 'Gonzalez', 'Perez', 'juan.gonzalez@example.com', 'securepassword123'),
('Maria', 'Elena', 'Martinez', 'Lopez', 'maria.martinez@example.com', 'securepassword456');

INSERT INTO STUDENTS (rol_student, rut_student, campus_student, first_name, second_name, first_last_name, second_last_name, email, password)
VALUES 
('2020123456', '12345678-9', 'Campus Santiago', 'Pedro', 'Antonio', 'Rodriguez', 'Sanchez', 'pedro.rodriguez@example.com', 'securepassword789'),
('2020234567', '98765432-1', 'Campus Valparaiso', 'Ana', 'Beatriz', 'Fernandez', 'Torres', 'ana.fernandez@example.com', 'securepassword012');


INSERT INTO DEPARTMENTS (name)
VALUES 
('Departamento de Informática'),
('Departamento de Matemáticas');

INSERT INTO TYPES_CONVALIDATIONS (name)
VALUES 
('Asignatura INF'),
('Asignatura Externa'),
('Curso Certificado'),
('Taller de INF'),
('Proyecto Personal');

INSERT INTO TYPES_CURRICULUM_COURSES (name)
VALUES 
('Libre'),
('Electivo'),
('Electivo INF');


INSERT INTO WORKSHOPS (name, semester, year, professor, initial_date, available)
VALUES 
('Taller de Programación Avanzada', '1', 2024, 'Dr. Luis Sanchez', '2024-03-01 08:00:00', TRUE),
('Taller de Innovación Tecnológica', '2', 2024, 'Dra. Paula Medina', '2024-08-01 09:00:00', TRUE);



SELECT id INTO @id_libre FROM TYPES_CURRICULUM_COURSES WHERE name = 'Libre';
SELECT id INTO @id_electivo FROM TYPES_CURRICULUM_COURSES WHERE name = 'Electivo';
SELECT id INTO @id_electivo_inf FROM TYPES_CURRICULUM_COURSES WHERE name = 'Electivo INF';

INSERT INTO CURRICULUM_COURSES (name, id_type_curriculum_course)
VALUES 
('Libre 1', @id_libre),
('Electivo 1', @id_electivo),
('Electivo Informatica 1', @id_electivo_inf);


SELECT id INTO @id_informatica FROM DEPARTMENTS WHERE name = 'Departamento de Informática';
SELECT id INTO @id_matematicas FROM DEPARTMENTS WHERE name = 'Departamento de Matemáticas';


INSERT INTO SUBJECTS (acronym, name, id_department, credits)
VALUES 
('INF-101', 'Introducción a la Programación', @id_informatica, 10),
('MAT-101', 'Cálculo I', @id_matematicas, 10);


SELECT id INTO @id_student1 FROM STUDENTS WHERE email = 'pedro.rodriguez@example.com';
SELECT id INTO @id_student2 FROM STUDENTS WHERE email = 'ana.fernandez@example.com';
SELECT id INTO @id_admin1 FROM ADMINISTRATORS WHERE email = 'juan.gonzalez@example.com';


INSERT INTO REQUESTS (id_student, creation_date, revision_date, comments, id_user_approves)
VALUES 
(@id_student1, '2024-08-01 10:00:00', '2024-08-05 15:30:00', 'Solicitud de convalidación para asignatura externa.', @id_admin1),
(@id_student2, '2024-08-02 11:00:00', NULL, 'En espera de revisión de taller de INF.', NULL);


SELECT id INTO @id_request1 FROM REQUESTS WHERE id_student = @id_student1;
SELECT id INTO @id_request2 FROM REQUESTS WHERE id_student = @id_student2;
SELECT id INTO @id_convalidation_type1 FROM TYPES_CONVALIDATIONS WHERE name = 'Asignatura INF';
SELECT id INTO @id_curriculum_course1 FROM CURRICULUM_COURSES WHERE name = 'Libre 1';
SELECT id INTO @id_subject1 FROM SUBJECTS WHERE acronym = 'INF-101';

INSERT INTO CONVALIDATIONS (id_request, id_convalidation_type, state, id_curriculum_course, id_subject_to_convalidate)
VALUES 
(@id_request1, @id_convalidation_type1, 'Enviada', @id_curriculum_course1, @id_subject1),
(@id_request2, @id_convalidation_type1, 'Aprobada por DI', @id_curriculum_course1, @id_subject1);


SELECT id INTO @id_workshop1 FROM WORKSHOPS WHERE name = 'Taller de Programación Avanzada';
SELECT id INTO @id_workshop2 FROM WORKSHOPS WHERE name = 'Taller de Innovación Tecnológica';


INSERT INTO WORKSHOPS_INSCRIPTIONS (id_student, id_workshop, id_curriculum_course, is_convalidated)
VALUES 
(@id_student1, @id_workshop1, @id_curriculum_course1, FALSE),
(@id_student2, @id_workshop2, @id_curriculum_course1, TRUE);



INSERT INTO WORKSHOPS_GRADES (id_student, id_workshop, grade)
VALUES 
(@id_student1, @id_workshop1, 85),
(@id_student2, @id_workshop2, 90);







