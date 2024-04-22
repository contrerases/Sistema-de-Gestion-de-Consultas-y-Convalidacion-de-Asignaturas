INSERT INTO `ADMINISTRATORS` (`first_name`, `second_name`, `first_last_name`, `second_last_name`, `email`, `password`) 
VALUES 
('Juan', 'Pablo', 'González', 'López', 'juan.gonzalez@example.com', 'password123'),
('María', 'José', 'Martínez', 'Sánchez', 'maria.martinez@example.com', 'securepassword'),
('Luis', '', 'Rodríguez', 'Hernández', 'luis.rodriguez@example.com', 'admin123'),
('Ana', 'Isabel', 'Fernández', 'García', 'ana.fernandez@example.com', 'adminpass'),
('Pedro', '', 'Díaz', 'Pérez', 'pedro.diaz@example.com', 'adminadmin');


INSERT INTO `STUDENTS` (`rol`, `verificator_number`, `first_name`, `second_name`, `first_last_name`, `second_last_name`) 
VALUES 
('201910001', 'K', 'Juan', 'Pablo', 'González', 'López'),
('201910002', '5', 'María', 'José', 'Martínez', 'Sánchez'),
('201910003', '3', 'Luis', '', 'Rodríguez', 'Hernández'),
('201910004', '8', 'Ana', 'Isabel', 'Fernández', 'García'),
('201910005', 'K', 'Pedro', '', 'Díaz', 'Pérez');

INSERT INTO `AUTH_STUDENTS` (`rol`, `email`, `password_hash`, `token`, `expiration_date`) 
VALUES 
('201910001', 'juan.gonzalez@example.com', 'hashedpassword123', 'randomtoken123', '2024-04-30 00:00:00'),
('201910002', 'maria.martinez@example.com', 'hashedsecurepassword', 'randomtoken456', '2024-04-30 00:00:00'),
('201910003', 'luis.rodriguez@example.com', 'hashedadmin123', 'randomtoken789', '2024-04-30 00:00:00'),
('201910004', 'ana.fernandez@example.com', 'hashedadminpass', 'randomtoken012', '2024-04-30 00:00:00'),
('201910005', 'pedro.diaz@example.com', 'hashedadminadmin', 'randomtoken345', '2024-04-30 00:00:00');


INSERT INTO `COURSES` (`acronym`, `name`) 
VALUES 
('MAT101', 'Matemáticas I'),
('ENG201', 'English Conversation'),
('PHY301', 'Physics III'),
('CHE401', 'Chemistry Lab'),
('BIO501', 'Biology Research');


INSERT INTO `SUBJECTS` (`name`, `type`) 
VALUES 
('Matemáticas I', 'Obligatoria'),
('Inglés II', 'Electiva'),
('Física II', 'Obligatoria'),
('Química Orgánica', 'Electiva'),
('Biología Molecular', 'Obligatoria');


INSERT INTO `CONVALIDATIONS` (`rol`, `id_origin_course`, `id_destination_course`, `state`, `comments`, `user_approves`) 
VALUES 
('201910001', 1, 2, 'Aprobada', 'Convalidación válida', 1),
('201910002', 3, 4, 'En revisión', 'Falta documentación', 2),
('201910003', 2, 3, 'Rechazada', 'Créditos insuficientes', 3),
('201910004', 4, 5, 'En revisión', 'Falta validación de contenido', 4),
('201910005', 1, 3, 'Pendiente', NULL, 5);
