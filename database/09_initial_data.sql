-- DATOS INICIALES DEL SISTEMA SGSCT
-- del Sistema de Gestión de Solicitudes de Convalidaciones y Talleres

-- =============================================================================
-- CONFIGURACIÓN INICIAL
-- =============================================================================

-- Desactiva las restricciones de clave foránea temporalmente
SET FOREIGN_KEY_CHECKS = 0;

-- =============================================================================
-- DATOS DE CATÁLOGOS (PRIMERO)
-- =============================================================================

-- Estados de talleres
INSERT INTO WORKSHOP_STATES (name, description, is_active) VALUES
('INSCRIPCION', 'Período de inscripción abierto', 1),
('CERRADO', 'Inscripciones cerradas', 1),
('EN_CURSO', 'Taller en desarrollo', 1),
('FINALIZADO', 'Taller completado', 1),
('CANCELADO', 'Taller cancelado', 0);

-- Estados de convalidaciones
INSERT INTO CONVALIDATION_STATES (name, description, is_active) VALUES
('ENVIADA', 'Convalidación enviada para revisión', 1),
('RECHAZADA_DI', 'Rechazada por Dirección de Investigación', 1),
('APROBADA_DI', 'Aprobada por Dirección de Investigación', 1),
('ENVIADA_DE', 'Enviada a Dirección de Estudios', 1),
('RECHAZADA_DE', 'Rechazada por Dirección de Estudios', 1),
('APROBADA_DE', 'Aprobada por Dirección de Estudios', 1);

-- Tipos de convalidaciones
INSERT INTO CONVALIDATION_TYPES (name) VALUES
('Electivo DI'),
('Electivo Externo'),
('Curso Certificado'),
('Taller de INF'),
('Proyecto Personal');

-- Tipos de cursos curriculares
INSERT INTO CURRICULUM_COURSES_TYPES (name) VALUES
('Libre'),
('Electivo INF'),
('Electivo');

-- Acciones de auditoría
INSERT INTO AUDIT_ACTIONS (name, description) VALUES
('INSERT', 'Inserción de registro'),
('UPDATE', 'Actualización de registro'),
('DELETE', 'Eliminación de registro'),
('STATUS_CHANGE', 'Cambio de estado');

-- Campos de auditoría
INSERT INTO AUDIT_FIELDS (name, description) VALUES
('STATE', 'Estado del registro'),
('COMMENTS', 'Comentarios'),
('ID_CREATED_BY', 'Usuario que creó'),
('ID_UPDATED_BY', 'Usuario que actualizó'),
('AVAILABLE', 'Disponibilidad'),
('GRADE', 'Calificación'),
('IS_CONVALIDATED', 'Convalidación'),
('NAME', 'Nombre'),
('EMAIL', 'Correo electrónico'),
('PASSWORD', 'Contraseña'),
('FILE_DATA', 'Datos de archivo'),
('FILE_NAME', 'Nombre de archivo'),
('SYLLABUS_DATA', 'Datos de programa'),
('INSCRIPTION_START_DATE', 'Fecha inicio inscripción'),
('INSCRIPTION_END_DATE', 'Fecha fin inscripción'),
('COURSE_START_DATE', 'Fecha inicio curso'),
('COURSE_END_DATE', 'Fecha fin curso'),
('CURRICULUM_COURSE_CONVALIDATION', 'Convalidación de curso'),
('OTHER', 'Otro campo');

-- Tipos de notificación
INSERT INTO NOTIFICATION_TYPES (name, description, is_active) VALUES
('CONVALIDATION_STATUS', 'Cambio de estado en convalidación', 1),
('WORKSHOP_REMINDER', 'Recordatorio de taller', 1),
('WORKSHOP_INSCRIPTION', 'Inscripción a taller', 1),
('WORKSHOP_CANCELLATION', 'Cancelación de taller', 1),
('APPROVAL_REQUIRED', 'Aprobación requerida', 1),
('DOCUMENT_UPLOADED', 'Documento subido', 1),
('DEADLINE_REMINDER', 'Recordatorio de fecha límite', 1),
('GRADE_PUBLISHED', 'Calificación publicada', 1),
('SYSTEM_ANNOUNCEMENT', 'Anuncio del sistema', 1),
('GRADES_UPLOADED', 'Calificaciones subidas', 1);

-- Nombres de tablas para auditoría (solo las que generan notificaciones)
INSERT INTO AUDIT_TABLES (name) VALUES
('CONVALIDATIONS'),
('REQUESTS'),
('WORKSHOPS'),
('WORKSHOPS_INSCRIPTIONS'),
('WORKSHOPS_GRADES');

-- =============================================================================
-- DATOS DE DEPARTAMENTOS
-- =============================================================================

-- Insertar Departamentos
INSERT INTO DEPARTMENTS (name) VALUES
('INFORMATICA'),
('QUIMICA'),
('ELECTRONICA'),
('DEFIDER'),
('ESTUDIOS HUMANISTICOS'),
('MATEMATICA');

-- =============================================================================
-- DATOS DE AUTENTICACIÓN (TABLA PRINCIPAL)
-- =============================================================================

-- Insertar datos de autenticación para todos los usuarios
-- Nota: Las contraseñas están hasheadas con bcrypt para máxima seguridad
INSERT INTO AUTH_USERS (
    email,
    password_hash
) VALUES (
    'pgodoy@usm.cl',
    '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewdBPj4J/8K5QKqG' -- hash de ejemplo para 'pedro123'
), (
    'camilocontrerases@gmail.com',
    '$2b$12$Nx9mK8pQ2rS5tU7vW1yZ3A6B9C0D1E2F3G4H5I6J7K8L9M0N1O2P3Q4R5S6T' -- hash de ejemplo para 'camilo123'
), (
    'alvarocarrasco@gmail.com',
    '$2b$12$Pq8rL5mN2sK9tU3vW7yZ1A4B6C9D2E5F8G1H4I7J0K3L6M9N2O5P8Q1R4S7T' -- hash de ejemplo para 'alvaro123'
);

-- =============================================================================
-- DATOS DE USUARIOS (TABLA HIJA)
-- =============================================================================

-- Insertar usuarios principales (datos comunes)
-- Nota: Los IDs corresponden a los generados automáticamente en AUTH_USERS
INSERT INTO USERS (
    id,
    first_names,
    last_names,
    campus
) VALUES (
    1, -- ID del usuario Pedro Godoy (Administrador)
    'Pedro Ignacio',
    'Godoy Barrera',
    'Casa Central'
), (
    2, -- ID del usuario Camilo Contreras (Estudiante)
    'Camilo Eugenio',
    'Contreras Espinoza',
    'Casa Central'
), (
    3, -- ID del usuario Alvaro Carrasco (Estudiante)
    'Alvaro Nicolas',
    'Carrasco Escobar',
    'Casa Central'
);

-- =============================================================================
-- DATOS DE ADMINISTRADORES (TABLA HIJA ESPECÍFICA)
-- =============================================================================

-- Insertar Administradores (datos específicos)
INSERT INTO ADMINISTRATORS (
    id
) VALUES (
    1 -- ID del usuario Pedro Godoy (Administrador)
);

-- =============================================================================
-- DATOS DE ESTUDIANTES (TABLA HIJA ESPECÍFICA)
-- =============================================================================

-- Insertar Estudiantes (datos específicos)
INSERT INTO STUDENTS (
    id,
    rol_student,
    rut_student,
    campus_student
) VALUES (
    2, -- ID del usuario Camilo Contreras
    '2018730637',
    '20369538k',
    'Casa Central'
), (
    3, -- ID del usuario Alvaro Carrasco
    '2018730181',
    '20360672k',
    'Casa Central'
);

-- =============================================================================
-- DATOS DE CURSOS CURRICULARES
-- =============================================================================

-- Insertar Cursos Curriculares
INSERT INTO CURRICULUM_COURSES (name, id_curriculum_course_type) VALUES
('LIBRE 1', 1),
('LIBRE 2', 1),
('LIBRE 3', 1),
('LIBRE 4', 1),
('LIBRE 5', 1),
('LIBRE 6', 1),
('LIBRE 7', 1),
('ELECTIVO DE INFORMATICA 1', 2),
('ELECTIVO DE INFORMATICA 2', 2),
('ELECTIVO DE INFORMATICA 3', 2),
('ELECTIVO DE INFORMATICA 4', 2),
('ELECTIVO 1', 3),
('ELECTIVO 2', 3),
('ELECTIVO 3', 3),
('ELECTIVO 4', 3);

-- =============================================================================
-- DATOS DE ASIGNATURAS
-- =============================================================================

-- Insertar Asignaturas
INSERT INTO SUBJECTS (acronym, name, id_department, credits) VALUES
('HIW111', 'ALEMÁN NIVEL ELEMENTAL', 5, 2),
('HIW110', 'ALEMÁN NIVEL PRINCIPIANTE', 5, 2),
('HRW200', 'ARTE E INGENIERÍA', 5, 2),
('HAA101', 'ARTES VISUALES EN CHILE', 5, 2),
('HAH102', 'CIENCIAS SOCIALES', 5, 2),
('HAC100', 'COMUNICACIÓN ESCRITA: LECTOESCRITURA A PARTIR DE GRANDES OBRAS', 5, 2),
('HAA102', 'COMUNICACIÓN ORAL: RETÓRICA Y PUESTA EN ESCENA', 5, 2),
('HRW104', 'CRECIMIENTO Y DESARROLLO PERSONAL', 5, 2),
('HAS100', 'DESAFIOS SOCIALES DE LAS ORGANIZACIONES Y EMPRESAS', 5, 2),
('HAF101', 'EL MÉTODO CIENTÍFICO', 5, 2),
('HFW145', 'ESCRITURA ACADÉMICA II', 5, 2),
('HFW124', 'ESPAÑOL COMO LENGUA EXTRANJERA II', 5, 2),
('HFW125', 'ESPAÑOL COMO LENGUA EXTRANJERA III', 5, 2),
('HRW130', 'ETICA', 5, 2),
('HFW144', 'EXPRESIÓN ORAL Y ESCRITA', 5, 2),
('HAF100', 'FILOSOFÍA DE LA TECNOLOGÍA', 5, 2),
('HRW131', 'FORMAC.Y LIDERAZGO EMPRESARIAL', 5, 2),
('HRW203', 'HISTORIA DE LA CONSTRUCCIÓN', 5, 2),
('HAH101', 'HISTORIA ECONÓMICA', 5, 2),
('HCW100', 'INGLÉS 1', 5, 2),
('HCW101', 'INGLÉS 2', 5, 2),
('HCW102', 'INGLÉS 3', 5, 2),
('HCW200', 'INGLÉS 4', 5, 2),
('HCW201', 'INGLÉS 5', 5, 2),
('HCW202', 'INGLÉS 6', 5, 2),
('HCW300', 'INGLÉS 7', 5, 2),
('HCW207', 'INGLÉS AMBIENTAL', 5, 2),
('HCW326', 'INGLÉS CONVERSACIÓN II', 5, 2),
('HTW130', 'INTRODUCCIÓN A LA MÚSICA', 5, 2),
('HRW230', 'LENGUAJE MUSICAL DEL SIGLO XX', 5, 2),
('HFW136', 'MISTERIOS Y TRADICIONES DE LA CULTURA RAPA NUI', 5, 2),
('HAH103', 'POLÍTICA E INSTITUCIONES', 5, 2),
('HRW153', 'PRACTICA EN ACCION COMUNITARIA', 5, 2),
('HRW151', 'RELACIONES INTERPERSONALES', 5, 2),
('HRW132', 'SOCIEDAD Y POLITICA CONTEMPORÁNEA', 5, 2),
('HRW202', 'TEORIA DEL CINE', 5, 2),
('HAF102', 'TEORÍAS FEMINISTAS Y EQUIDAD DE GÉNERO', 5, 2),
('HRW103', 'VISIÓN ESTÉTICA DEL QUEHACER HUMANO', 5, 2),
('HRW102', 'VISIÓN INMANENTE DEL QUEHACER HUMANO', 5, 2),
('HRW133', 'ÉTICA Y ARGUMENTACIÓN CRÍTICA', 5, 2),
('EFI102', 'ATLETISMO', 4, 2),
('EFI103', 'BÁSQUETBOL', 4, 2),
('EFI100', 'EDUCACIÓN FÍSICA I (DAMAS Y VARONES)', 4, 2),
('EFI105', 'FÚTBOL', 4, 2),
('EFI108', 'HANDBOL', 4, 2),
('EFI109', 'JUDO', 4, 2),
('EFI110', 'KÁRATE', 4, 2),
('EFI115', 'TAEKWONDO', 4, 2),
('EFI113', 'TENIS', 4, 2),
('EFI114', 'TENIS DE MESA', 4, 2),
('EFI116', 'VÓLEIBOL', 4, 2);

-- =============================================================================
-- DATOS DE TALLERES DE EJEMPLO
-- =============================================================================

-- Insertar Talleres de ejemplo
INSERT INTO WORKSHOPS (
    name,
    semester,
    year,
    professor,
    description,
    inscription_start_date,
    inscription_end_date,
    course_start_date,
    course_end_date,
    available,
    id_workshop_state
) VALUES (
    'Taller de Programación Python',
    '1',
    2024,
    'Dr. Juan Pérez',
    'Taller introductorio a la programación en Python para estudiantes de informática',
    '2024-02-01 00:00:00',
    '2024-02-15 23:59:59',
    '2024-03-01 09:00:00',
    '2024-06-30 18:00:00',
    1,
    1 -- INSCRIPCION
), (
    'Taller de Desarrollo Web',
    '1',
    2024,
    'Dra. María González',
    'Taller de desarrollo web con HTML, CSS y JavaScript',
    '2024-02-01 00:00:00',
    '2024-02-20 23:59:59',
    '2024-03-05 09:00:00',
    '2024-07-15 18:00:00',
    1,
    1 -- INSCRIPCION
), (
    'Taller de Base de Datos',
    '2',
    2024,
    'Dr. Carlos Rodríguez',
    'Taller de diseño y administración de bases de datos',
    '2024-07-01 00:00:00',
    '2024-07-15 23:59:59',
    '2024-08-01 09:00:00',
    '2024-12-15 18:00:00',
    1,
    1 -- INSCRIPCION
);

-- =============================================================================
-- DATOS DE SOLICITUDES DE EJEMPLO
-- =============================================================================

-- Insertar Solicitudes de ejemplo
INSERT INTO REQUESTS (
    id_student,
    sent_at
) VALUES (
    2, -- Camilo Contreras
    '2024-01-15 10:30:00'
), (
    3, -- Alvaro Carrasco
    '2024-01-20 14:45:00'
);

-- =============================================================================
-- DATOS DE CONVALIDACIONES DE EJEMPLO
-- =============================================================================

-- Insertar Convalidaciones principales
INSERT INTO CONVALIDATIONS (
    id_request,
    id_convalidation_type,
    id_convalidation_state,
    id_curriculum_course,
    review_comments
) VALUES (
    1, -- Solicitud de Camilo
    1, -- Electivo DI
    1, -- ENVIADA
    8, -- ELECTIVO DE INFORMATICA 1
    'Convalidación de alemán como electivo de informática'
), (
    2, -- Solicitud de Alvaro
    4, -- Taller de INF
    3, -- APROBADA_DI
    9, -- ELECTIVO DE INFORMATICA 2
    'Taller de programación aprobado como electivo'
), (
    1, -- Solicitud de Camilo
    3, -- Curso Certificado
    4, -- ENVIADA_DE
    10, -- ELECTIVO DE INFORMATICA 3
    'Convalidación de curso externo'
), (
    2, -- Solicitud de Alvaro
    5, -- Proyecto Personal
    2, -- RECHAZADA_DI
    11, -- ELECTIVO DE INFORMATICA 4
    'Convalidación de proyecto personal'
);

-- Insertar datos específicos para convalidaciones de asignaturas
INSERT INTO CONVALIDATIONS_SUBJECTS (
    id_convalidation,
    id_subject
) VALUES (
    1, -- Convalidación de Camilo (Electivo DI)
    1  -- ALEMÁN NIVEL ELEMENTAL
);

-- Insertar datos específicos para convalidaciones de talleres
INSERT INTO CONVALIDATIONS_WORKSHOPS (
    id_convalidation,
    id_workshop
) VALUES (
    2, -- Convalidación de Alvaro (Taller de INF)
    1  -- Taller de Programación Python
);

-- Insertar datos específicos para convalidaciones de actividades externas
INSERT INTO CONVALIDATIONS_EXTERNAL_ACTIVITIES (
    id_convalidation,
    activity_name
) VALUES (
    3, -- Convalidación de Camilo (Curso Certificado)
    'Machine Learning Fundamentals'
), (
    4, -- Convalidación de Alvaro (Proyecto Personal)
    'Sistema de Gestión de Inventarios'
);

-- =============================================================================
-- DATOS DE INSCRIPCIONES DE EJEMPLO
-- =============================================================================

-- Insertar Inscripciones de ejemplo
INSERT INTO WORKSHOPS_INSCRIPTIONS (
    id_student,
    id_workshop,
    id_curriculum_course,
    is_convalidated
) VALUES (
    1, -- Camilo Contreras
    1, -- Taller de Programación Python
    8, -- ELECTIVO DE INFORMATICA 1
    1 -- Convalidado
), (
    2, -- Alvaro Carrasco
    2, -- Taller de Desarrollo Web
    9, -- ELECTIVO DE INFORMATICA 2
    0 -- No convalidado
);

-- =============================================================================
-- DATOS DE CALIFICACIONES DE EJEMPLO
-- =============================================================================

-- Insertar Calificaciones de ejemplo
INSERT INTO WORKSHOPS_GRADES (
    id_student,
    id_workshop,
    grade
) VALUES (
    1, -- Camilo Contreras
    1, -- Taller de Programación Python
    85
), (
    2, -- Alvaro Carrasco
    2, -- Taller de Desarrollo Web
    92
);

-- =============================================================================
-- DATOS DE NOTIFICACIONES DE EJEMPLO
-- =============================================================================

-- Insertar Notificaciones de ejemplo
INSERT INTO NOTIFICATIONS (
    id_user,
    id_notification_type,
    title,
    message,
    is_read,
    is_sent,
    id_notification_related_table,
    related_id
) VALUES (
    2, -- Camilo Contreras (user)
    1, -- CONVALIDATION_STATUS
    'Estado de Convalidación Actualizado',
    'Su convalidación de ALEMÁN NIVEL ELEMENTAL ha sido aprobada por DI',
    0,
    1,
    1, -- AUDIT_TABLES.CONVALIDATIONS (ID 1)
    1
), (
    3, -- Alvaro Carrasco (user)
    2, -- WORKSHOP_REMINDER
    'Recordatorio de Taller',
    'El taller de Desarrollo Web comienza mañana a las 9:00 AM',
    0,
    1,
    3, -- AUDIT_TABLES.WORKSHOPS (ID 3)
    2
);

-- =============================================================================
-- CONFIGURACIÓN FINAL
-- =============================================================================

-- Reactiva las restricciones de clave foránea
SET FOREIGN_KEY_CHECKS = 1;

-- =============================================================================
-- RESUMEN DE DATOS INSERTADOS
-- =============================================================================
-- Total de registros insertados:
-- - Estados de Talleres: 5
-- - Estados de Convalidaciones: 6
-- - Tipos de Convalidación: 5
-- - Tipos de Cursos Curriculares: 3
-- - Acciones de Auditoría: 4
-- - Campos de Auditoría: 20
-- - Tipos de Notificación: 10
-- - Tablas de Auditoría: 5
-- - Departamentos: 6
-- - Administradores: 1
-- - Estudiantes: 2
-- - Usuarios de Autenticación: 3
-- - Sesiones de Usuario: 3
-- - Cursos Curriculares: 15
-- - Asignaturas: 50
-- - Talleres: 3
-- - Solicitudes: 2
-- - Convalidaciones: 4
-- - Convalidaciones de Asignaturas: 1
-- - Convalidaciones de Talleres: 1
-- - Convalidaciones de Actividades Externas: 2
-- - Inscripciones: 2
-- - Calificaciones: 2
-- - Notificaciones: 2

SELECT "Datos iniciales insertados correctamente" AS mensaje;
