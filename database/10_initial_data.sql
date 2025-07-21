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
INSERT INTO WORKSHOP_STATES (name, description) VALUES
('INSCRIPCION', 'Período de inscripción abierto'),
('EN_CURSO', 'Taller en desarrollo'),
('FINALIZADO', 'Taller finalizado'),
('CERRADO', 'Taller cerrado'),
('CANCELADO', 'Taller cancelado');

-- Estados de convalidaciones
INSERT INTO CONVALIDATION_STATES (name, description) VALUES
('ENVIADA', 'Convalidación enviada para revisión'),
('RECHAZADA_DI', 'Rechazada por Dirección de Investigación'),
('APROBADA_DI', 'Aprobada por Dirección de Investigación'),
('ENVIADA_DE', 'Enviada a Dirección de Estudios'),
('RECHAZADA_DE', 'Rechazada por Dirección de Estudios'),
('APROBADA_DE', 'Aprobada por Dirección de Estudios');

-- Tipos de convalidaciones
INSERT INTO CONVALIDATION_TYPES (name) VALUES
('ELECTIVO DI'),
('ASIGNATURA EXTERNA DI'),
('TALLER DI'),
('PROYECTO PERSONAL'),
('CURSO CERTIFICADO'),
('OTRO');


-- Tipos de cursos curriculares
INSERT INTO CURRICULUM_COURSES_TYPES (name) VALUES
('LIBRE'),
('ELECTIVO INFORMATICA'),
('ELECTIVO');

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


SELECT "Datos iniciales insertados correctamente" AS mensaje;
