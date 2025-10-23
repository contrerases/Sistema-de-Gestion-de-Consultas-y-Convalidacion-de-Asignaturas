-- =============================================================================
-- SCRIPT DE DATOS INICIALES
-- Sistema de Gestión de Solicitudes de Convalidación y Talleres DI
-- =============================================================================



SET FOREIGN_KEY_CHECKS = 0;

DELETE FROM CONVALIDATION_STATES WHERE 1 = 1;
DELETE FROM CONVALIDATION_TYPES WHERE 1 = 1;
DELETE FROM CURRICULUM_COURSES_TYPES WHERE 1 = 1;
DELETE FROM WORKSHOP_STATES WHERE 1 = 1;
DELETE FROM DEPARTMENTS WHERE 1 = 1;
DELETE FROM CURRICULUM_COURSE_SLOTS WHERE 1 = 1;
DELETE FROM SUBJECTS WHERE 1 = 1;
DELETE FROM CAMPUS WHERE 1 = 1;
DELETE FROM USER_TYPES WHERE 1 = 1;

-- Reiniciar las secuencias
ALTER TABLE CONVALIDATION_STATES AUTO_INCREMENT = 1;
ALTER TABLE CONVALIDATION_TYPES AUTO_INCREMENT = 1;
ALTER TABLE CURRICULUM_COURSES_TYPES AUTO_INCREMENT = 1;
ALTER TABLE WORKSHOP_STATES AUTO_INCREMENT = 1;
ALTER TABLE DEPARTMENTS AUTO_INCREMENT = 1;
ALTER TABLE CURRICULUM_COURSE_SLOTS AUTO_INCREMENT = 1;
ALTER TABLE SUBJECTS AUTO_INCREMENT = 1;
ALTER TABLE CAMPUS AUTO_INCREMENT = 1;
ALTER TABLE USER_TYPES AUTO_INCREMENT = 1;

-- =============================================================================
-- DATOS DE CONFIGURACIÓN DEL SISTEMA
-- =============================================================================

-- Campus universitarios
INSERT INTO CAMPUS (acronym, name, location) VALUES
('CC', 'CASA CENTRAL', 'VALPARAISO'),
('SJ', 'SAN JOAQUIN', 'SANTIAGO'),
('VSM', 'VITACURA', 'SANTIAGO');

-- Tipos de usuarios
INSERT INTO USER_TYPES (name) VALUES
('STUDENT'),
('ADMINISTRATOR');

-- Estados de talleres
INSERT IGNORE INTO WORKSHOP_STATES (name, description) VALUES
('INSCRIPCION', 'Período de inscripción abierto'),
('EN_CURSO', 'Taller en desarrollo'),
('FINALIZADO', 'Taller finalizado'),
('CERRADO', 'Taller cerrado'),
('CANCELADO', 'Taller cancelado');

-- Estados de convalidaciones
INSERT INTO CONVALIDATION_STATES (name) VALUES
('ENVIADA'),
('RECHAZADA_DI'),
('APROBADA_DI'),
('ENVIADA_DE'),
('RECHAZADA_DE'),
('APROBADA_DE');

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
-- DATOS DE CURRICULUM COURSE SLOTS (Casillas Curriculares)
-- =============================================================================


INSERT INTO CURRICULUM_COURSE_SLOTS (name, id_curriculum_course_type) VALUES
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
-- TRANSICIONES VÁLIDAS DE ESTADOS
-- =============================================================================

-- Transiciones válidas para talleres
INSERT INTO WORKSHOP_STATE_TRANSITIONS (id_from_state, id_to_state) VALUES
(1, 2),  -- INSCRIPCION → EN_CURSO
(1, 5),  -- INSCRIPCION → CANCELADO
(2, 3),  -- EN_CURSO → FINALIZADO
(3, 4);  -- FINALIZADO → CERRADO

-- Transiciones válidas para convalidaciones
INSERT INTO CONVALIDATION_STATE_TRANSITIONS (id_from_state, id_to_state) VALUES
(1, 2),  -- ENVIADA → RECHAZADA_DI
(1, 3),  -- ENVIADA → APROBADA_DI
(1, 4),  -- ENVIADA → ENVIADA_A_DE
(4, 5),  -- ENVIADA_A_DE → RECHAZADA_DE
(4, 6);  -- ENVIADA_A_DE → APROBADA_DE


SET FOREIGN_KEY_CHECKS = 1;

SELECT "Datos insertados correctamente"