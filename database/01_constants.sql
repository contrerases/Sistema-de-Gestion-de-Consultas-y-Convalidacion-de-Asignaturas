--------------------------------------------------------------------------------------------------------
---------------------------------- CONSTANTES DE LA BASE DE DATOS --------------------------------------
--------------------------------------------------------------------------------------------------------

-- =============================================================================
-- RESUMEN DE CONSTANTES
-- =============================================================================
-- Total de constantes: 39
-- Límites de texto: 25 | Límites numéricos: 8 | Patrones de validación: 3 | Autenticación: 5 | Tipos de usuario: 2 | Semestres: 2

-- =============================================================================
-- LÍMITES DE TEXTO
-- =============================================================================

-- Nombres de personas
SET @MAX_FIRST_NAMES_LENGTH = 255;
SET @MAX_LAST_NAMES_LENGTH = 255;
SET @MAX_COMMON_NAME_LENGTH = 255;
SET @MAX_FULL_NAME_LENGTH = 255;
SET @MAX_PROFESSOR_NAME_LENGTH = 255;

-- Información de contacto
SET @MAX_EMAIL_LENGTH = 255;

-- Información académica
SET @MAX_ROL_STUDENT_LENGTH = 11;
SET @MAX_RUT_STUDENT_LENGTH = 12;
SET @MAX_CAMPUS_STUDENT_LENGTH = 255;

-- Nombres de entidades
SET @MAX_DEPARTMENT_NAME_LENGTH = 255;
SET @MAX_SUBJECT_ACRONYM_LENGTH = 255;
SET @MAX_SUBJECT_NAME_LENGTH = 255;
SET @MAX_CURRICULUM_COURSE_NAME_LENGTH = 255;
SET @MAX_TYPE_NAME_LENGTH = 255;
SET @MAX_WORKSHOP_NAME_LENGTH = 255;
SET @MAX_CERTIFIED_COURSE_NAME_LENGTH = 255;
SET @MAX_PERSONAL_PROJECT_NAME_LENGTH = 255;

-- Archivos
SET @MAX_FILE_NAME_LENGTH = 255;

-- Comentarios y descripciones
SET @MAX_COMMENTS_LENGTH = 1000;
SET @MAX_NOTIFICATION_TITLE_LENGTH = 255;
SET @MAX_NOTIFICATION_MESSAGE_LENGTH = 1000;

-- Auditoría
SET @MAX_OLD_VALUE_LENGTH = 1000;
SET @MAX_NEW_VALUE_LENGTH = 1000;
SET @MAX_ID_SESSION_LENGTH = 255;

-- =============================================================================
-- LÍMITES NUMÉRICOS
-- =============================================================================

-- Calificaciones
SET @MIN_GRADE_VALUE = 0;
SET @MAX_GRADE_VALUE = 100;

-- Créditos
SET @MIN_CREDITS_VALUE = 1;
SET @MAX_CREDITS_VALUE = 10;

-- Años académicos
SET @MIN_YEAR_VALUE = 2000;
SET @MAX_YEAR_VALUE = 2100;

-- =============================================================================
-- PATRONES DE VALIDACIÓN
-- =============================================================================

SET @RUT_CHILEAN_PATTERN = '^[0-9]{7,8}[0-9kK]$';
SET @EMAIL_PATTERN = '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
SET @ROL_UNIVERSITY_PATTERN = '^[0-9]{9,10}$';

-- =============================================================================
-- AUTENTICACIÓN
-- =============================================================================

SET @HASH_ALGORITHM_BCRYPT = 'bcrypt';
SET @HASH_BCRYPT_ROUNDS = 12;
SET @HASH_BCRYPT_LENGTH = 255;
SET @PASSWORD_MIN_LENGTH = 8;
SET @PASSWORD_MAX_LENGTH = 128;
SET @SESSION_TOKEN_LENGTH = 32;
SET @SESSION_EXPIRY_HOURS = 24;

-- =============================================================================
-- ENUMs - TIPOS DE USUARIO
-- =============================================================================

SET @USER_TYPE_STUDENT = 'STUDENT';
SET @USER_TYPE_ADMINISTRATOR = 'ADMINISTRATOR';

-- =============================================================================
-- ENUMs - SEMESTRES
-- =============================================================================

SET @SEMESTER_FIRST = '1';
SET @SEMESTER_SECOND = '2';

SELECT "Constantes de la base de datos creadas correctamente" AS mensaje;
