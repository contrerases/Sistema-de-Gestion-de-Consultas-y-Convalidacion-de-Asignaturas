--------------------------------------------------------------------------------------------------------
---------------------------------- DATOS DE PRUEBA PARA EL SISTEMA -------------------------------------
--------------------------------------------------------------------------------------------------------
-- Este archivo contiene datos de ejemplo para las tablas que NO tienen initial_data
-- Las tablas con datos iniciales (CAMPUS, USER_TYPES, DEPARTMENTS, etc.) están en 10_initial_data.sql
-- Respeta todas las foreign keys y constraints definidos
-- Fecha: 2025-10-11
-- 
-- NOTA: Este archivo requiere que 10_initial_data.sql haya sido ejecutado previamente
--------------------------------------------------------------------------------------------------------

-- =============================================================================
-- CONFIGURACIÓN INICIAL
-- =============================================================================

SET FOREIGN_KEY_CHECKS = 0;
SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";

-- =============================================================================
-- NOTAS IMPORTANTES
-- =============================================================================
-- Las siguientes tablas YA tienen datos en 10_initial_data.sql y NO se llenan aquí:
-- - CAMPUS
-- - USER_TYPES  
-- - WORKSHOP_STATES
-- - CONVALIDATION_STATES
-- - CONVALIDATION_TYPES
-- - CURRICULUM_COURSES_TYPES
-- - DEPARTMENTS
-- - CURRICULUM_COURSE_SLOTS
-- - SUBJECTS
-- - WORKSHOP_STATE_TRANSITIONS
-- - CONVALIDATION_STATE_TRANSITIONS
--
-- Este archivo SOLO llena las tablas de datos de negocio y prueba
-- =============================================================================

-- =============================================================================
-- PROFESORES
-- =============================================================================

INSERT INTO PROFESSORS (id, name, email) VALUES
(1, 'Dr. Juan Pérez Informatica', 'juan.perez@usm.cl'),
(2, 'Dra. María González Quimica', 'maria.gonzalez@usm.cl'),
(3, 'Ing. Carlos Rodríguez Electronica', 'carlos.rodriguez@usm.cl'),
(4, 'Dra. Ana Martínez Defider', 'ana.martinez@usm.cl'),
(5, 'Prof. Pedro Sánchez Humanidades', 'pedro.sanchez@usm.cl'),
(6, 'Dra. Laura Torres Matematica', 'laura.torres@usm.cl');

-- =============================================================================
-- TALLERES
-- =============================================================================
-- Usando estados de 10_initial_data.sql: 1=INSCRIPCION, 2=EN_CURSO, 3=FINALIZADO, 4=CERRADO, 5=CANCELADO

INSERT INTO WORKSHOPS (id, name, semester, year, id_professor, description, inscription_start_date, inscription_end_date, course_start_date, course_end_date, syllabus_path, id_workshop_state, inscriptions_number, limit_inscriptions) VALUES
(1, 'Desarrollo Web con React', '1', 2025, 1, 'Taller práctico de desarrollo frontend con React y TypeScript', '2025-03-01 00:00:00', '2025-03-15 23:59:59', '2025-03-20 08:00:00', '2025-06-30 18:00:00', '/syllabi/react-2025-1.pdf', 3, 25, 30),
(2, 'Introducción a Machine Learning', '1', 2025, 2, 'Fundamentos de aprendizaje automático con Python y scikit-learn', '2025-03-01 00:00:00', '2025-03-15 23:59:59', '2025-03-20 08:00:00', '2025-06-30 18:00:00', '/syllabi/ml-2025-1.pdf', 3, 30, 35),
(3, 'Desarrollo de APIs con FastAPI', '2', 2025, 1, 'Construcción de APIs RESTful con Python y FastAPI', '2025-08-01 00:00:00', '2025-08-15 23:59:59', '2025-08-20 08:00:00', '2025-12-15 18:00:00', '/syllabi/fastapi-2025-2.pdf', 1, 15, 25),
(4, 'Diseño UX/UI', '2', 2025, 4, 'Principios de diseño de experiencia de usuario e interfaces', '2025-08-01 00:00:00', '2025-08-15 23:59:59', '2025-08-20 08:00:00', '2025-12-15 18:00:00', '/syllabi/ux-2025-2.pdf', 1, 20, 30),
(5, 'DevOps y CI/CD', '1', 2026, 3, 'Automatización de despliegues con Docker, Kubernetes y GitHub Actions', '2026-03-01 00:00:00', '2026-03-15 23:59:59', '2026-03-20 08:00:00', '2026-06-30 18:00:00', NULL, 1, 0, 25),
(6, 'Ciberseguridad Básica', '1', 2026, 5, 'Fundamentos de seguridad informática y ethical hacking', '2026-03-01 00:00:00', '2026-03-15 23:59:59', '2026-03-20 08:00:00', '2026-06-30 18:00:00', NULL, 1, 0, 30);

-- =============================================================================
-- USUARIOS DE AUTENTICACIÓN
-- =============================================================================
-- Columnas: id, email, password_hash
-- password_hash: $2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewY5sPLgvst.rCha (password123)

INSERT INTO AUTH_USERS (id, email, password_hash) VALUES
(1, 'juan.perez@estudiante.usm.cl', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewY5sPLgvst.rCha'),
(2, 'maria.gonzalez@estudiante.usm.cl', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewY5sPLgvst.rCha'),
(3, 'carlos.rodriguez@estudiante.usm.cl', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewY5sPLgvst.rCha'),
(4, 'ana.martinez@estudiante.usm.cl', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewY5sPLgvst.rCha'),
(5, 'pedro.sanchez@estudiante.usm.cl', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewY5sPLgvst.rCha'),
(6, 'laura.torres@estudiante.usm.cl', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewY5sPLgvst.rCha'),
(7, 'diego.fernandez@estudiante.usm.cl', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewY5sPLgvst.rCha'),
(8, 'sofia.ramirez@estudiante.usm.cl', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewY5sPLgvst.rCha'),
(9, 'admin.informatica@usm.cl', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewY5sPLgvst.rCha'),
(10, 'admin.di@usm.cl', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewY5sPLgvst.rCha');

-- =============================================================================
-- USUARIOS (ESTUDIANTES Y ADMINISTRADORES)
-- =============================================================================
-- Usando: campus_id de initial_data (1=CC, 2=SJ, 3=VSM), user_type_id (1=STUDENT, 2=ADMINISTRATOR)
-- Formato RUT: sin puntos ni guión, según constraint chk_student_rut_format (^[0-9]{7,8}[0-9kK]$)
-- Formato ROL: 10 dígitos, según constraint chk_student_rol_format (^[0-9]{10}$)

INSERT INTO USERS (id, full_name, id_campus, id_user_type, rol_student, rut_student) VALUES
-- Estudiantes
(1, 'Juan Pérez López', 1, 1, '2020123456', '20123456K'),
(2, 'María González Silva', 1, 1, '2020234567', '202345673'),
(3, 'Carlos Rodríguez Muñoz', 2, 1, '2020345678', '203456785'),
(4, 'Ana Martínez Rojas', 2, 1, '2020456789', '204567897'),
(5, 'Pedro Sánchez Díaz', 3, 1, '2020567890', '205678909'),
(6, 'Laura Torres Vega', 1, 1, '2020678901', '206789011'),
(7, 'Diego Fernández Castro', 3, 1, '2020789012', '207890123'),
(8, 'Sofía Ramírez Morales', 2, 1, '2020890123', '208901235'),
-- Administradores (no tienen rol_student ni rut_student por ser tipo ADMINISTRATOR)
(9, 'Roberto Admin Informática', 1, 2, NULL, NULL),
(10, 'Patricia Admin Dirección', 1, 2, NULL, NULL);

-- =============================================================================
-- INSCRIPCIONES A TALLERES
-- =============================================================================
-- Usando: id_student de USERS (1-8), id_workshop de WORKSHOPS (1-6), id_curriculum_course de initial_data (1-15)
-- Columnas: id, id_student, id_workshop, id_curriculum_course, is_convalidated, inscription_at

INSERT INTO WORKSHOPS_INSCRIPTIONS (id, id_student, id_workshop, id_curriculum_course, is_convalidated, inscription_at) VALUES
-- Taller 1 (React, estado=FINALIZADO)
(1, 1, 1, 1, 0, '2025-03-05 10:30:00'),
(2, 2, 1, 4, 0, '2025-03-06 14:20:00'),
(3, 3, 1, 9, 0, '2025-03-07 09:15:00'),
(4, 4, 1, 2, 0, '2025-03-08 16:45:00'),
(5, 5, 1, 5, 0, '2025-03-09 11:00:00'),
-- Taller 2 (ML, estado=FINALIZADO)
(6, 2, 2, 7, 0, '2025-03-05 12:00:00'),
(7, 3, 2, 10, 0, '2025-03-06 15:30:00'),
(8, 6, 2, 3, 0, '2025-03-07 10:45:00'),
(9, 7, 2, 6, 0, '2025-03-08 13:20:00'),
(10, 8, 2, 8, 0, '2025-03-09 08:50:00'),
-- Taller 3 (FastAPI, estado=INSCRIPCION)
(11, 1, 3, 11, 0, '2025-08-05 09:00:00'),
(12, 4, 3, 12, 0, '2025-08-06 14:30:00'),
(13, 5, 3, 13, 0, '2025-08-07 11:45:00'),
-- Taller 4 (UX/UI, estado=INSCRIPCION)
(14, 6, 4, 14, 0, '2025-08-05 10:15:00'),
(15, 7, 4, 15, 0, '2025-08-06 16:00:00'),
(16, 8, 4, 1, 0, '2025-08-07 12:30:00');

-- =============================================================================
-- CALIFICACIONES DE TALLERES
-- =============================================================================
-- Solo para talleres con estado=FINALIZADO (id_workshop 1 y 2)
-- Columnas: id, id_student, id_workshop, grade (INT, escala 10-70), evaluated_at

INSERT INTO WORKSHOPS_GRADES (id, id_student, id_workshop, grade, evaluated_at) VALUES
(1, 1, 1, 65, '2025-07-05 14:00:00'),
(2, 2, 1, 58, '2025-07-05 14:05:00'),
(3, 3, 1, 68, '2025-07-05 14:10:00'),
(4, 4, 1, 70, '2025-07-05 14:15:00'),
(5, 5, 1, 62, '2025-07-05 14:20:00'),
(6, 2, 2, 67, '2025-07-05 15:00:00'),
(7, 3, 2, 55, '2025-07-05 15:05:00'),
(8, 6, 2, 69, '2025-07-05 15:10:00'),
(9, 7, 2, 63, '2025-07-05 15:15:00'),
(10, 8, 2, 70, '2025-07-05 15:20:00');

-- =============================================================================
-- SOLICITUDES DE CONVALIDACIÓN
-- =============================================================================
-- Columnas: id, id_student, sent_at, id_reviewed_by, reviewed_at

INSERT INTO REQUESTS (id, id_student, sent_at, id_reviewed_by, reviewed_at) VALUES
(1, 1, '2025-02-10 10:30:00', 9, '2025-02-15 14:20:00'),
(2, 2, '2025-02-12 11:45:00', 9, '2025-02-18 16:30:00'),
(3, 3, '2025-02-15 09:20:00', NULL, NULL),
(4, 4, '2025-03-01 14:15:00', 10, '2025-03-05 10:00:00'),
(5, 5, '2025-03-10 16:00:00', NULL, NULL),
(6, 6, '2025-03-20 13:30:00', 9, '2025-03-25 15:45:00');

-- =============================================================================
-- CONVALIDACIONES
-- =============================================================================
-- Columnas: id, id_request, id_convalidation_type, id_convalidation_state, id_curriculum_course, review_comments
-- Usando: id_convalidation_type (1-6), id_convalidation_state (1-6), id_curriculum_course (1-15)

INSERT INTO CONVALIDATIONS (id, id_request, id_convalidation_type, id_convalidation_state, id_curriculum_course, review_comments) VALUES
(1, 1, 1, 3, 9, 'Curso aprobado en programa de intercambio'),
(2, 2, 3, 6, 10, 'Taller completado satisfactoriamente'),
(3, 3, 1, 2, 11, NULL),
(4, 4, 2, 5, 12, 'Falta certificado de notas oficial'),
(5, 5, 4, 2, 13, NULL),
(6, 6, 1, 3, 14, 'Certificación internacional verificada');

-- =============================================================================
-- CONVALIDACIONES POR ASIGNATURA
-- =============================================================================
-- Columnas: id_convalidation (PK), id_subject
-- Solo convalidaciones de tipo ASIGNATURA EXTERNA (tipo 2)

INSERT INTO CONVALIDATIONS_SUBJECTS (id_convalidation, id_subject) VALUES
(1, 9),  -- Convalidación 1 por asignatura IWI-131 Programación
(4, 2);  -- Convalidación 4 por asignatura INF-239 Base de Datos

-- =============================================================================
-- CONVALIDACIONES POR TALLERES
-- =============================================================================
-- Columnas: id_convalidation (PK), id_workshop
-- Solo convalidaciones de tipo TALLER (tipo 3)

INSERT INTO CONVALIDATIONS_WORKSHOPS (id_convalidation, id_workshop) VALUES
(2, 2);  -- Convalidación 2 por taller Machine Learning

-- =============================================================================
-- CONVALIDACIONES POR ACTIVIDADES EXTERNAS
-- =============================================================================
-- Columnas: id_convalidation (PK), activity_name, description, file_path
-- Para convalidaciones tipo: PROYECTO PERSONAL (4), CURSO CERTIFICADO (5), OTRO (6)

INSERT INTO CONVALIDATIONS_EXTERNAL_ACTIVITIES (id_convalidation, activity_name, description, file_path) VALUES
(5, 'Sistema de Gestión Académica', 'Desarrollo de software completo con documentación técnica', '/uploads/proyectos/proyecto_student5.pdf'),
(6, 'Certified Ethical Hacker (CEH)', 'Certificación internacional en seguridad informática', '/uploads/certificados/ceh_student6.pdf');

-- =============================================================================
-- TOKENS DE TALLERES
-- =============================================================================
-- Columnas: id, id_workshop, token, id_professor, expiration_at, created_by, is_used, used_at

INSERT INTO WORKSHOPS_TOKENS (id, id_workshop, token, id_professor, expiration_at, created_by, is_used, used_at) VALUES
(1, 3, 'TOKEN-FASTAPI-2025-001', 1, '2025-08-20 23:59:59', 9, TRUE, '2025-08-05 09:00:00'),
(2, 3, 'TOKEN-FASTAPI-2025-002', 1, '2025-08-20 23:59:59', 9, FALSE, NULL),
(3, 4, 'TOKEN-UXUI-2025-001', 4, '2025-08-20 23:59:59', 10, TRUE, '2025-08-05 10:15:00'),
(4, 5, 'TOKEN-DEVOPS-2026-001', 3, '2026-03-20 23:59:59', 9, FALSE, NULL);

-- =============================================================================
-- TIPOS DE NOTIFICACIONES
-- =============================================================================

INSERT INTO NOTIFICATION_TYPES (id, name, description) VALUES
(1, 'CONVALIDACION_APROBADA', 'Notificación de convalidación aprobada'),
(2, 'CONVALIDACION_RECHAZADA', 'Notificación de convalidación rechazada'),
(3, 'TALLER_INSCRITO', 'Confirmación de inscripción a taller'),
(4, 'TALLER_CALIFICADO', 'Notificación de calificación de taller'),
(5, 'SOLICITUD_EN_REVISION', 'Solicitud en proceso de revisión'),
(6, 'INFORMACION_REQUERIDA', 'Se requiere información adicional');

-- =============================================================================
-- NOTIFICACIONES
-- =============================================================================
-- Columnas: id, id_user, notification_type (VARCHAR), message, is_read, is_sent, created_at, read_at, sent_at

INSERT INTO NOTIFICATIONS (id, id_user, notification_type, message, is_read, is_sent, created_at, read_at, sent_at) VALUES
(1, 1, 'WORKSHOP_REGISTRATION_CONFIRMED', 'Te has inscrito exitosamente al taller "Desarrollo Web con React"', 1, 1, '2025-03-05 10:35:00', '2025-03-05 11:00:00', '2025-03-05 10:35:00'),
(2, 1, 'WORKSHOP_GRADE_AVAILABLE', 'Tu calificación en el taller "Desarrollo Web con React" es 65', 1, 1, '2025-07-05 14:05:00', '2025-07-05 15:00:00', '2025-07-05 14:05:00'),
(3, 1, 'CONVALIDATION_APPROVED', 'Tu solicitud de convalidación ha sido aprobada', 0, 1, '2025-02-20 09:30:00', NULL, '2025-02-20 09:30:00'),
(4, 2, 'WORKSHOP_REGISTRATION_CONFIRMED', 'Te has inscrito exitosamente al taller "Introducción a Machine Learning"', 1, 1, '2025-03-05 12:05:00', '2025-03-05 13:00:00', '2025-03-05 12:05:00'),
(5, 2, 'CONVALIDATION_APPROVED', 'Tu convalidación de taller ha sido aprobada', 0, 1, '2025-02-25 12:00:00', NULL, '2025-02-25 12:00:00'),
(6, 3, 'REQUEST_STATUS_CHANGE', 'Tu solicitud está siendo evaluada por un administrador', 0, 1, '2025-02-16 10:00:00', NULL, '2025-02-16 10:00:00'),
(7, 4, 'CONVALIDATION_REJECTED', 'Se necesita el certificado de notas oficial para completar tu solicitud', 0, 1, '2025-03-05 10:30:00', NULL, '2025-03-05 10:30:00'),
(8, 5, 'REQUEST_STATUS_CHANGE', 'Tu proyecto personal está en proceso de evaluación', 0, 1, '2025-03-15 16:30:00', NULL, '2025-03-15 16:30:00'),
(9, 6, 'CONVALIDATION_APPROVED', 'Tu certificación en Ciberseguridad ha sido convalidada', 0, 1, '2025-03-30 12:30:00', NULL, '2025-03-30 12:30:00'),
(10, 7, 'WORKSHOP_REGISTRATION_CONFIRMED', 'Te has inscrito exitosamente al taller "Diseño UX/UI"', 1, 1, '2025-08-06 16:05:00', '2025-08-06 17:00:00', '2025-08-06 16:05:00');

-- =============================================================================
-- CONFIGURACIÓN FINAL
-- =============================================================================

SET FOREIGN_KEY_CHECKS = 1;

SELECT 'Datos de prueba insertados correctamente' AS mensaje;
SELECT CONCAT('Total de profesores: ', COUNT(*)) AS resumen FROM PROFESSORS
UNION ALL
SELECT CONCAT('Total de usuarios: ', COUNT(*)) FROM USERS
UNION ALL
SELECT CONCAT('Total de talleres: ', COUNT(*)) FROM WORKSHOPS
UNION ALL
SELECT CONCAT('Total de inscripciones: ', COUNT(*)) FROM WORKSHOPS_INSCRIPTIONS
UNION ALL
SELECT CONCAT('Total de convalidaciones: ', COUNT(*)) FROM CONVALIDATIONS
UNION ALL
SELECT CONCAT('Total de notificaciones: ', COUNT(*)) FROM NOTIFICATIONS;

-- =============================================================================
-- FIN DEL ARCHIVO
-- =============================================================================
