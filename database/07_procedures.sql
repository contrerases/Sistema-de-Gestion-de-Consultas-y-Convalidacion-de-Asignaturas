-- =============================================================================
-- PROCEDIMIENTOS ALMACENADOS PARA LA API REST SGSCT
-- =============================================================================



-- =============================================================================
-- ELIMINACIÓN DE PROCEDIMIENTOS EXISTENTES (ORDEN ALFABÉTICO)
-- =============================================================================

-- Autenticación
DROP PROCEDURE IF EXISTS sp_change_password;
DROP PROCEDURE IF EXISTS sp_get_salt;
DROP PROCEDURE IF EXISTS sp_login;

-- Administradores
DROP PROCEDURE IF EXISTS sp_create_administrator;
DROP PROCEDURE IF EXISTS sp_delete_administrator;
DROP PROCEDURE IF EXISTS sp_get_administrator_by_id;
DROP PROCEDURE IF EXISTS sp_get_administrators;
DROP PROCEDURE IF EXISTS sp_update_administrator;

-- Convalidaciones
DROP PROCEDURE IF EXISTS sp_create_convalidation;
DROP PROCEDURE IF EXISTS sp_delete_convalidation;
DROP PROCEDURE IF EXISTS sp_get_convalidation_by_id;
DROP PROCEDURE IF EXISTS sp_get_convalidation_external_activities;
DROP PROCEDURE IF EXISTS sp_get_convalidation_subjects;
DROP PROCEDURE IF EXISTS sp_get_convalidation_workshops;
DROP PROCEDURE IF EXISTS sp_get_convalidations;
DROP PROCEDURE IF EXISTS sp_get_convalidations_by_student;
DROP PROCEDURE IF EXISTS sp_get_convalidations_by_state;
DROP PROCEDURE IF EXISTS sp_get_convalidations_by_type;
DROP PROCEDURE IF EXISTS sp_get_convalidations_reviewed_by_admin;
DROP PROCEDURE IF EXISTS sp_review_convalidation;
DROP PROCEDURE IF EXISTS sp_search_convalidations;
DROP PROCEDURE IF EXISTS sp_update_convalidation;

-- Estados de convalidaciones
DROP PROCEDURE IF EXISTS sp_create_convalidation_state;
DROP PROCEDURE IF EXISTS sp_delete_convalidation_state;
DROP PROCEDURE IF EXISTS sp_get_convalidation_states;
DROP PROCEDURE IF EXISTS sp_update_convalidation_state;

-- Tipos de convalidaciones
DROP PROCEDURE IF EXISTS sp_delete_convalidation_type;
DROP PROCEDURE IF EXISTS sp_update_convalidation_type;
DROP PROCEDURE IF EXISTS sp_get_convalidation_types;
DROP PROCEDURE IF EXISTS sp_create_convalidation_type;

-- Cursos curriculares
DROP PROCEDURE IF EXISTS sp_create_curriculum_course;
DROP PROCEDURE IF EXISTS sp_delete_curriculum_course;
DROP PROCEDURE IF EXISTS sp_get_curriculum_course_by_id;
DROP PROCEDURE IF EXISTS sp_get_curriculum_courses;
DROP PROCEDURE IF EXISTS sp_get_curriculum_courses_by_type;
DROP PROCEDURE IF EXISTS sp_get_curriculum_courses_not_convalidated_by_student;
DROP PROCEDURE IF EXISTS sp_update_curriculum_course;

-- Tipos de cursos curriculares
DROP PROCEDURE IF EXISTS sp_create_curriculum_course_type;
DROP PROCEDURE IF EXISTS sp_delete_curriculum_course_type;
DROP PROCEDURE IF EXISTS sp_get_curriculum_course_types;
DROP PROCEDURE IF EXISTS sp_update_curriculum_course_type;

-- Departamentos
DROP PROCEDURE IF EXISTS sp_create_department;
DROP PROCEDURE IF EXISTS sp_delete_department;
DROP PROCEDURE IF EXISTS sp_get_departments;
DROP PROCEDURE IF EXISTS sp_update_department;

-- Notificaciones
DROP PROCEDURE IF EXISTS sp_create_notification;
DROP PROCEDURE IF EXISTS sp_create_notification_administrators;
DROP PROCEDURE IF EXISTS sp_create_notification_students;
DROP PROCEDURE IF EXISTS sp_delete_notification;
DROP PROCEDURE IF EXISTS sp_get_notification_by_id;
DROP PROCEDURE IF EXISTS sp_get_notifications;
DROP PROCEDURE IF EXISTS sp_get_notifications_by_user;
DROP PROCEDURE IF EXISTS sp_get_notifications_unread;
DROP PROCEDURE IF EXISTS sp_mark_notification_as_read;
DROP PROCEDURE IF EXISTS sp_mark_notification_as_sent;

-- Profesores
DROP PROCEDURE IF EXISTS sp_create_professor;
DROP PROCEDURE IF EXISTS sp_get_professors;
DROP PROCEDURE IF EXISTS sp_update_professor;

-- Solicitudes
DROP PROCEDURE IF EXISTS sp_get_request_by_id;
DROP PROCEDURE IF EXISTS sp_get_request_convalidations;
DROP PROCEDURE IF EXISTS sp_get_requests_by_student;

-- Asignaturas
DROP PROCEDURE IF EXISTS sp_create_subject;
DROP PROCEDURE IF EXISTS sp_delete_subject;
DROP PROCEDURE IF EXISTS sp_get_subject_by_id;
DROP PROCEDURE IF EXISTS sp_get_subjects;
DROP PROCEDURE IF EXISTS sp_get_subjects_by_department;
DROP PROCEDURE IF EXISTS sp_update_subject;

-- Estudiantes
DROP PROCEDURE IF EXISTS sp_create_student;
DROP PROCEDURE IF EXISTS sp_delete_student;
DROP PROCEDURE IF EXISTS sp_get_student_by_id;
DROP PROCEDURE IF EXISTS sp_get_student_by_rol;
DROP PROCEDURE IF EXISTS sp_get_student_by_rut;
DROP PROCEDURE IF EXISTS sp_get_students;
DROP PROCEDURE IF EXISTS sp_search_students;
DROP PROCEDURE IF EXISTS sp_update_student;

-- Tokens
DROP PROCEDURE IF EXISTS sp_create_workshop_token;
DROP PROCEDURE IF EXISTS sp_get_workshop_tokens_active;
DROP PROCEDURE IF EXISTS sp_get_workshop_tokens_expired;
DROP PROCEDURE IF EXISTS sp_use_workshop_token;


DROP PROCEDURE IF EXISTS sp_create_workshop_grade;
DROP PROCEDURE IF EXISTS sp_delete_workshop_grade;
DROP PROCEDURE IF EXISTS sp_get_workshop_grade_by_id;
DROP PROCEDURE IF EXISTS sp_get_workshop_grades;
DROP PROCEDURE IF EXISTS sp_get_workshop_grades_by_student;
DROP PROCEDURE IF EXISTS sp_get_workshop_grades_by_workshop;
DROP PROCEDURE IF EXISTS sp_update_workshop_grade;

-- Inscripciones a talleres
DROP PROCEDURE IF EXISTS sp_create_workshop_inscription;
DROP PROCEDURE IF EXISTS sp_delete_workshop_inscription;
DROP PROCEDURE IF EXISTS sp_get_workshop_inscription_by_id;
DROP PROCEDURE IF EXISTS sp_get_workshop_inscriptions;
DROP PROCEDURE IF EXISTS sp_get_workshop_inscriptions_by_student;
DROP PROCEDURE IF EXISTS sp_get_workshop_inscriptions_by_workshop;
DROP PROCEDURE IF EXISTS sp_update_workshop_inscription;

-- Estados de talleres
DROP PROCEDURE IF EXISTS sp_create_workshop_state;
DROP PROCEDURE IF EXISTS sp_delete_workshop_state;
DROP PROCEDURE IF EXISTS sp_get_workshop_states;
DROP PROCEDURE IF EXISTS sp_update_workshop_state;

-- Talleres
DROP PROCEDURE IF EXISTS sp_change_workshop_state;
DROP PROCEDURE IF EXISTS sp_create_workshop;
DROP PROCEDURE IF EXISTS sp_delete_workshop;
DROP PROCEDURE IF EXISTS sp_get_workshop_by_id;
DROP PROCEDURE IF EXISTS sp_get_workshops;
DROP PROCEDURE IF EXISTS sp_get_workshops_by_state;
DROP PROCEDURE IF EXISTS sp_get_workshops_closed;
DROP PROCEDURE IF EXISTS sp_get_workshops_finished;
DROP PROCEDURE IF EXISTS sp_get_workshops_in_progress;
DROP PROCEDURE IF EXISTS sp_get_workshops_to_inscription;
DROP PROCEDURE IF EXISTS sp_search_workshops;
DROP PROCEDURE IF EXISTS sp_update_workshop;

-- =============================================================================
-- 1. PROCEDIMIENTOS DE CATÁLOGOS
-- =============================================================================

DELIMITER $$
-- Curriculum Courses Types --
CREATE PROCEDURE sp_get_curriculum_course_types()
BEGIN
    SELECT id, name AS curriculum_course_type FROM CURRICULUM_COURSES_TYPES;
END$$
CREATE PROCEDURE sp_create_curriculum_course_type(IN p_name VARCHAR(255))
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;
    START TRANSACTION;
    IF p_name IS NULL OR TRIM(p_name) = '' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El nombre del tipo de convalidación es requerido';
    END IF;
    INSERT INTO CONVALIDATION_TYPES (name) VALUES (p_name);
    COMMIT;
END$$
CREATE PROCEDURE sp_update_curriculum_course_type(IN p_id INT, IN p_name VARCHAR(255))
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;
    
    START TRANSACTION;
    IF p_id IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El ID del tipo de curso curricular es requerido';
    END IF;
    
    IF p_name IS NULL OR TRIM(p_name) = '' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El nombre del tipo de curso curricular es requerido';
    END IF;
    
    UPDATE CURRICULUM_COURSES_TYPES SET name = p_name WHERE id = p_id;
    
    IF ROW_COUNT() = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Tipo de curso curricular no encontrado';
    END IF;
    
    COMMIT;
END$$
CREATE PROCEDURE sp_delete_curriculum_course_type(IN p_id INT)
BEGIN
    DECLARE v_count INT;
    
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;
    
    START TRANSACTION;
    
    IF p_id IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El ID del tipo de curso curricular es requerido';   
    END IF;
    
    
    SELECT COUNT(*) INTO v_count FROM CURRICULUM_COURSES WHERE id_curriculum_course_type = p_id;
    
    IF v_count > 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No se puede eliminar el tipo de curso curricular porque está siendo usado';
    END IF;
    
    DELETE FROM CURRICULUM_COURSES_TYPES WHERE id = p_id;
    
    IF ROW_COUNT() = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Tipo de curso curricular no encontrado';
    END IF;
    
    COMMIT;
END$$

-- Convalidation States --
CREATE PROCEDURE sp_get_convalidation_states()
BEGIN
    SELECT id, name AS convalidation_state, description FROM CONVALIDATION_STATES;
END$$
CREATE PROCEDURE sp_create_convalidation_state(IN p_name VARCHAR(255), IN p_description TEXT)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;
    
    START TRANSACTION;
    
    IF p_name IS NULL OR TRIM(p_name) = '' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El nombre del estado de convalidación es requerido';
    END IF;
    
    INSERT INTO CONVALIDATION_STATES (name, description) VALUES (p_name, p_description);
    
    COMMIT;
END$$
CREATE PROCEDURE sp_update_convalidation_state(IN p_id INT, IN p_name VARCHAR(255), IN p_description TEXT)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;
    
    START TRANSACTION;
    
    IF p_id IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El ID del estado de convalidación es requerido';
    END IF;
    
    IF p_name IS NULL OR TRIM(p_name) = '' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El nombre del estado de convalidación es requerido';
    END IF;
    
    UPDATE CONVALIDATION_STATES SET name = p_name, description = p_description WHERE id = p_id;
    
    IF ROW_COUNT() = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Estado de convalidación no encontrado';
    END IF;
    
    COMMIT;
END$$
CREATE PROCEDURE sp_delete_convalidation_state(IN p_id INT)
BEGIN
    DECLARE v_count INT;
    
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;
    
    START TRANSACTION;
    
    IF p_id IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El ID del estado de convalidación es requerido';
    END IF;
    
    -- Verificar si está siendo usado
    SELECT COUNT(*) INTO v_count FROM CONVALIDATIONS WHERE id_convalidation_state = p_id;
    
    IF v_count > 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No se puede eliminar el estado de convalidación porque está siendo usado';
    END IF;
    
    DELETE FROM CONVALIDATION_STATES WHERE id = p_id;
    
    IF ROW_COUNT() = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Estado de convalidación no encontrado';
    END IF;
    
    COMMIT;
END$$

-- Workshop States --
CREATE PROCEDURE sp_get_workshop_states()
BEGIN
    SELECT id, name AS workshop_state, description FROM WORKSHOP_STATES;
END$$
CREATE PROCEDURE sp_create_workshop_state(IN p_name VARCHAR(255), IN p_description TEXT)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;
    
    START TRANSACTION;
    
    IF p_name IS NULL OR TRIM(p_name) = '' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El nombre del estado de taller es requerido';
    END IF;
    
    INSERT INTO WORKSHOP_STATES (name, description) VALUES (p_name, p_description);
    
    COMMIT;
END$$
CREATE PROCEDURE sp_update_workshop_state(IN p_id INT, IN p_name VARCHAR(255), IN p_description TEXT)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;
    
    START TRANSACTION;
    
    IF p_id IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El ID del estado de taller es requerido';
    END IF;
    
    IF p_name IS NULL OR TRIM(p_name) = '' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El nombre del estado de taller es requerido';
    END IF;
    
    UPDATE WORKSHOP_STATES SET name = p_name, description = p_description WHERE id = p_id;
    
    IF ROW_COUNT() = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Estado de taller no encontrado';
    END IF;
    
    COMMIT;
END$$
CREATE PROCEDURE sp_delete_workshop_state(IN p_id INT)
BEGIN
    DECLARE v_count INT;
    
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;
    
    START TRANSACTION;
    
    IF p_id IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El ID del estado de taller es requerido';
    END IF;
    
    -- Verificar si está siendo usado
    SELECT COUNT(*) INTO v_count FROM WORKSHOPS WHERE id_workshop_state = p_id;
    
    IF v_count > 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No se puede eliminar el estado de taller porque está siendo usado';
    END IF;
    
    DELETE FROM WORKSHOP_STATES WHERE id = p_id;
    
    IF ROW_COUNT() = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Estado de taller no encontrado';
    END IF;
    
    COMMIT;
END$$

-- Convalidation Types --
CREATE PROCEDURE sp_get_convalidation_types()
BEGIN
    SELECT id, name AS convalidation_type FROM CONVALIDATION_TYPES;
END$$
CREATE PROCEDURE sp_create_convalidation_type(IN p_name VARCHAR(255))
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;
    
    START TRANSACTION;
    
    IF p_name IS NULL OR TRIM(p_name) = '' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El nombre del tipo de convalidación es requerido';
    END IF;
    
    INSERT INTO CONVALIDATION_TYPES (name) VALUES (p_name);
    
    COMMIT;
END$$
CREATE PROCEDURE sp_update_convalidation_type(IN p_id INT, IN p_name VARCHAR(255))
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;
    
    START TRANSACTION;
    
    IF p_id IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El ID del tipo de convalidación es requerido';
    END IF;
    
    IF p_name IS NULL OR TRIM(p_name) = '' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El nombre del tipo de convalidación es requerido';
    END IF;
    
    UPDATE CONVALIDATION_TYPES SET name = p_name WHERE id = p_id;
    
    IF ROW_COUNT() = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Tipo de convalidación no encontrado';
    END IF;
    
    COMMIT;
END$$
CREATE PROCEDURE sp_delete_convalidation_type(IN p_id INT)
BEGIN
    DECLARE v_count INT;
    
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;
    
    START TRANSACTION;
    
    IF p_id IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El ID del tipo de curso curricular es requerido';
    END IF;
    
    -- Verificar si está siendo usado
    SELECT COUNT(*) INTO v_count FROM CURRICULUM_COURSES WHERE id_curriculum_course_type = p_id;
    
    IF v_count > 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No se puede eliminar el tipo de convalidación porque está siendo usado';
    END IF;
    
    DELETE FROM CONVALIDATION_TYPES WHERE id = p_id;
    
    IF ROW_COUNT() = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Tipo de convalidación no encontrado';
    END IF;
    
    COMMIT;
END$$

-- =============================================================================
-- 2. PROCEDIMIENTOS DE TABLAS MAESTRAS
-- =============================================================================

-- Departments --
CREATE PROCEDURE sp_get_departments()
BEGIN
    SELECT id, name AS department FROM DEPARTMENTS;
END$$
CREATE PROCEDURE sp_create_department(IN p_name VARCHAR(255))
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;
    
    START TRANSACTION;
    
    IF p_name IS NULL OR TRIM(p_name) = '' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El nombre del departamento es requerido';
    END IF;
    
    INSERT INTO DEPARTMENTS (name) VALUES (p_name);
    
    COMMIT;
END$$
CREATE PROCEDURE sp_update_department(IN p_id INT, IN p_name VARCHAR(255))
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;
    
    START TRANSACTION;
    
    IF p_id IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El ID del departamento es requerido';
    END IF;
    
    IF p_name IS NULL OR TRIM(p_name) = '' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El nombre del departamento es requerido';
    END IF;
    
    UPDATE DEPARTMENTS SET name = p_name WHERE id = p_id;
    
    IF ROW_COUNT() = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Departamento no encontrado';
    END IF;
    
    COMMIT;
END$$
CREATE PROCEDURE sp_delete_department(IN p_id INT)
BEGIN
    DECLARE v_count INT;
    
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;
    
    START TRANSACTION;
    
    IF p_id IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El ID del departamento es requerido';
    END IF;
    
    -- Verificar si está siendo usado
    SELECT COUNT(*) INTO v_count FROM SUBJECTS WHERE id_department = p_id;
    
    IF v_count > 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No se puede eliminar el departamento porque tiene asignaturas asociadas';
    END IF;
    
    DELETE FROM DEPARTMENTS WHERE id = p_id;
    
    IF ROW_COUNT() = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Departamento no encontrado';
    END IF;
    
    COMMIT;
END$$


-- Subjects --
CREATE PROCEDURE sp_get_subjects()
BEGIN
    SELECT id_subject, subject, acronym, credits, department FROM vw_subjects;
END$$
CREATE PROCEDURE sp_get_subject_by_id(IN p_id INT)
BEGIN
    SELECT id_subject, subject, acronym, credits, department FROM vw_subjects WHERE id_subject = p_id;
END$$
CREATE PROCEDURE sp_get_subjects_by_department(IN p_id_department INT)
BEGIN
    SELECT id_subject, subject, acronym, credits, department FROM vw_subjects WHERE id_department = p_id_department;
END$$
CREATE PROCEDURE sp_create_subject(
    IN p_acronym VARCHAR(255),
    IN p_name VARCHAR(255),
    IN p_id_department INT,
    IN p_credits INT
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;
    
    START TRANSACTION;
    
    IF p_acronym IS NULL OR TRIM(p_acronym) = '' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El acrónimo es requerido';
    END IF;
    
    IF p_name IS NULL OR TRIM(p_name) = '' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El nombre es requerido';
    END IF;
    
    IF p_id_department IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El departamento es requerido';
    END IF;
    
    IF p_credits < 1 OR p_credits > 10 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Los créditos deben estar entre 1 y 10';
    END IF;
    
    -- Verificar que el departamento existe
    IF NOT EXISTS (SELECT 1 FROM DEPARTMENTS WHERE id = p_id_department) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El departamento no existe';
    END IF;
    
    INSERT INTO SUBJECTS (acronym, name, id_department, credits) 
    VALUES (p_acronym, p_name, p_id_department, p_credits);
    
    COMMIT;
END$$
CREATE PROCEDURE sp_update_subject(
    IN p_id INT,
    IN p_acronym VARCHAR(255),
    IN p_name VARCHAR(255),
    IN p_id_department INT,
    IN p_credits INT
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;
    
    START TRANSACTION;
    
    IF p_id IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El ID de la asignatura es requerido';
    END IF;
    
    IF p_credits IS NOT NULL AND (p_credits < 1 OR p_credits > 10) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Los créditos deben estar entre 1 y 10';
    END IF;
    
    IF p_id_department IS NOT NULL AND NOT EXISTS (SELECT 1 FROM DEPARTMENTS WHERE id = p_id_department) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El departamento no existe';
    END IF;
    
    UPDATE SUBJECTS 
    SET acronym = COALESCE(p_acronym, acronym),
        name = COALESCE(p_name, name),
        id_department = COALESCE(p_id_department, id_department),
        credits = COALESCE(p_credits, credits)
    WHERE id = p_id;
    
    IF ROW_COUNT() = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Asignatura no encontrada';
    END IF;
    
    COMMIT;
END$$
CREATE PROCEDURE sp_delete_subject(IN p_id INT)
BEGIN
    DECLARE v_count INT;
    
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;
    
    START TRANSACTION;
    
    IF p_id IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El ID de la asignatura es requerido';
    END IF;
    
    -- Verificar si está siendo usada
    SELECT COUNT(*) INTO v_count FROM CONVALIDATIONS_SUBJECTS WHERE id_subject = p_id;
    
    IF v_count > 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No se puede eliminar la asignatura porque tiene convalidaciones asociadas';
    END IF;
    
    DELETE FROM SUBJECTS WHERE id = p_id;
    
    IF ROW_COUNT() = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Asignatura no encontrada';
    END IF;
    
    COMMIT;
END$$


-- Curriculum Courses --
CREATE PROCEDURE sp_get_curriculum_courses()
BEGIN
    SELECT id_curriculum_course, name, id_curriculum_course_type, curriculum_course FROM vw_curriculum_courses;
END$$
CREATE PROCEDURE sp_get_curriculum_course_by_id(IN p_id INT)
BEGIN
    SELECT id_curriculum_course, name, id_curriculum_course_type, curriculum_course FROM vw_curriculum_courses WHERE id_curriculum_course = p_id;
END$$
CREATE PROCEDURE sp_get_curriculum_courses_by_type(IN p_id_curriculum_course_type INT)
BEGIN
    SELECT id_curriculum_course, name, id_curriculum_course_type, curriculum_course FROM vw_curriculum_courses WHERE id_curriculum_course_type = p_id_curriculum_course_type;
END$$
CREATE PROCEDURE sp_get_curriculum_courses_not_convalidated_by_student(IN p_id_student INT)
BEGIN
    SELECT * FROM vw_curriculum_courses
    WHERE NOT EXISTS (
        SELECT 1 FROM CONVALIDATIONS 
        WHERE CONVALIDATIONS.id_curriculum_course = vw_curriculum_courses.id_curriculum_course 
        AND CONVALIDATIONS.id_request IN (SELECT REQUESTS.id FROM REQUESTS WHERE REQUESTS.id_student = p_id_student)
    );
END$$
CREATE PROCEDURE sp_create_curriculum_course(
    IN p_name VARCHAR(255),
    IN p_id_curriculum_course_type INT
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;
    
    START TRANSACTION;
    
    IF p_name IS NULL OR TRIM(p_name) = '' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El nombre del curso curricular es requerido';
    END IF;
    
    IF p_id_curriculum_course_type IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El tipo de curso curricular es requerido';
    END IF;
    
    -- Verificar que el tipo existe
    IF NOT EXISTS (SELECT 1 FROM CURRICULUM_COURSES_TYPES WHERE id = p_id_curriculum_course_type) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El tipo de curso curricular no existe';
    END IF;
    
    INSERT INTO CURRICULUM_COURSES (name, id_curriculum_course_type) 
    VALUES (p_name, p_id_curriculum_course_type);
    
    COMMIT;
END$$
CREATE PROCEDURE sp_update_curriculum_course(
    IN p_id INT,
    IN p_name VARCHAR(255),
    IN p_id_curriculum_course_type INT
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;
    
    START TRANSACTION;
    
    IF p_id IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El ID del curso curricular es requerido';
    END IF;
    
    IF p_id_curriculum_course_type IS NOT NULL AND NOT EXISTS (SELECT 1 FROM CURRICULUM_COURSES_TYPES WHERE id = p_id_curriculum_course_type) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El tipo de curso curricular no existe';
    END IF;
    
    UPDATE CURRICULUM_COURSES 
    SET name = COALESCE(p_name, name),
        id_curriculum_course_type = COALESCE(p_id_curriculum_course_type, id_curriculum_course_type)
    WHERE id = p_id;
    
    IF ROW_COUNT() = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Curso curricular no encontrado';
    END IF;
    
    COMMIT;
END$$
CREATE PROCEDURE sp_delete_curriculum_course(IN p_id INT)
BEGIN
    DECLARE v_count INT;
    
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;
    
    START TRANSACTION;
    
    IF p_id IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El ID del curso curricular es requerido';
    END IF;
    
    -- Verificar si está siendo usado
    SELECT COUNT(*) INTO v_count FROM CONVALIDATIONS WHERE id_curriculum_course = p_id;
    
    IF v_count > 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No se puede eliminar el curso curricular porque tiene convalidaciones asociadas';
    END IF;
    
    SELECT COUNT(*) INTO v_count FROM WORKSHOPS_INSCRIPTIONS WHERE id_curriculum_course = p_id;
    
    IF v_count > 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No se puede eliminar el curso curricular porque tiene inscripciones asociadas';
    END IF;
    
    DELETE FROM CURRICULUM_COURSES WHERE id = p_id;
    
    IF ROW_COUNT() = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Curso curricular no encontrado';
    END IF;
    
    COMMIT;
END$$

-- =============================================================================
-- 3. PROCEDIMIENTOS DE TALLERES
-- =============================================================================

CREATE PROCEDURE sp_get_workshops()
BEGIN
    SELECT id_workshop, name, semester, year, inscriptions_number, limit_inscriptions, professor, workshop_state, slug FROM vw_workshops;
END$$
CREATE PROCEDURE sp_get_workshop_by_id(IN p_id INT)
BEGIN
    SELECT id_workshop, name, semester, year, inscriptions_number, limit_inscriptions, professor, workshop_state, slug FROM vw_workshops WHERE id_workshop = p_id;
END$$
CREATE PROCEDURE sp_get_workshops_by_state(IN p_id_workshop_state INT)
BEGIN
    SELECT id_workshop, name, semester, year, inscriptions_number, limit_inscriptions, professor, workshop_state FROM vw_workshops WHERE id_workshop_state = p_id_workshop_state;
END$$
CREATE PROCEDURE sp_get_workshops_to_inscription()
BEGIN
    SELECT id_workshop, name, semester, year, inscriptions_number, limit_inscriptions, professor, workshop_state, slug FROM vw_workshops 
    WHERE NOW() BETWEEN inscription_start_date AND inscription_end_date
    AND inscriptions_number < limit_inscriptions;
END$$
CREATE PROCEDURE sp_get_workshops_in_progress()
BEGIN
    SELECT id_workshop, name, semester, year, inscriptions_number, limit_inscriptions, professor, workshop_state, slug FROM vw_workshops 
    WHERE NOW() BETWEEN course_start_date AND course_end_date;
END$$
CREATE PROCEDURE sp_get_workshops_closed()
BEGIN
    SELECT id_workshop, name, semester, year, inscriptions_number, limit_inscriptions, professor, workshop_state, slug FROM vw_workshops 
    WHERE NOW() > course_end_date;
END$$
CREATE PROCEDURE sp_get_workshops_finished()
BEGIN
    SELECT id_workshop, name, semester, year, inscriptions_number, limit_inscriptions, professor, workshop_state, slug FROM vw_workshops 
    WHERE id_workshop_state = 3;
END$$
CREATE PROCEDURE sp_search_workshops(
    IN p_name VARCHAR(255),
    IN p_semester ENUM('1', '2'),
    IN p_year INT,
    IN p_id_professor INT
)
BEGIN
    SELECT id_workshop, name, semester, year, inscriptions_number, limit_inscriptions, professor, workshop_state, slug FROM vw_workshops
    WHERE (p_name IS NULL OR workshop LIKE CONCAT('%', p_name, '%'))
    AND (p_semester IS NULL OR semester = p_semester)
    AND (p_year IS NULL OR year = p_year)
    AND (p_id_professor IS NULL OR id_professor = p_id_professor);
END$$
CREATE PROCEDURE sp_create_workshop(
    IN p_name VARCHAR(255),
    IN p_semester ENUM('1', '2'),
    IN p_year INT,
    IN p_id_professor INT,
    IN p_description TEXT,
    IN p_inscription_start_date TIMESTAMP,
    IN p_inscription_end_date TIMESTAMP,
    IN p_course_start_date TIMESTAMP,
    IN p_course_end_date TIMESTAMP,
    IN p_limit_inscriptions INT,
    IN p_id_workshop_state INT
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;
    
    START TRANSACTION;
    
    IF p_name IS NULL OR TRIM(p_name) = '' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El nombre del taller es requerido';
    END IF;
    
    IF p_semester IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El semestre es requerido';
    END IF;
    
    IF p_year IS NULL OR p_year < 2000 OR p_year > 2100 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El año debe estar entre 2000 y 2100';
    END IF;
    
    IF p_id_professor IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El profesor es requerido';
    END IF;
    
    IF p_description IS NULL OR TRIM(p_description) = '' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La descripción es requerida';
    END IF;
    
    IF p_inscription_start_date IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La fecha de inicio de inscripción es requerida';
    END IF;
    
    IF p_inscription_end_date IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La fecha de fin de inscripción es requerida';
    END IF;
    
    IF p_course_start_date IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La fecha de inicio del curso es requerida';
    END IF;
    
    IF p_course_end_date IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La fecha de fin del curso es requerida';
    END IF;
    
    IF p_limit_inscriptions IS NULL OR p_limit_inscriptions < 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El límite de inscripciones debe ser mayor o igual a 0';
    END IF;
    
    IF p_id_workshop_state IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El estado del taller es requerido';
    END IF;
    
    -- Verificar que el profesor existe
    IF NOT EXISTS (SELECT 1 FROM PROFESSORS WHERE id = p_id_professor) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El profesor no existe';
    END IF;
    
    -- Verificar que el estado existe
    IF NOT EXISTS (SELECT 1 FROM WORKSHOP_STATES WHERE id = p_id_workshop_state) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El estado del taller no existe';
    END IF;
    
    -- Verificar fechas
    IF p_inscription_end_date <= p_inscription_start_date THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La fecha de fin de inscripción debe ser posterior a la fecha de inicio';
    END IF;
    
    IF p_course_end_date <= p_course_start_date THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La fecha de fin del curso debe ser posterior a la fecha de inicio';
    END IF;
    
    IF p_inscription_end_date > p_course_start_date THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El período de inscripción debe terminar antes del inicio del curso';
    END IF;
    
    INSERT INTO WORKSHOPS (
        name, semester, year, id_professor, description,
        inscription_start_date, inscription_end_date,
        course_start_date, course_end_date,
        limit_inscriptions, id_workshop_state
    ) VALUES (
        p_name, p_semester, p_year, p_id_professor, p_description,
        p_inscription_start_date, p_inscription_end_date,
        p_course_start_date, p_course_end_date,
        p_limit_inscriptions, p_id_workshop_state
    );
    
    COMMIT;
END$$
CREATE PROCEDURE sp_update_workshop(
    IN p_id INT,
    IN p_name VARCHAR(255),
    IN p_semester ENUM('1', '2'),
    IN p_year INT,
    IN p_id_professor INT,
    IN p_description TEXT,
    IN p_inscription_start_date TIMESTAMP,
    IN p_inscription_end_date TIMESTAMP,
    IN p_course_start_date TIMESTAMP,
    IN p_course_end_date TIMESTAMP,
    IN p_limit_inscriptions INT,
    IN p_id_workshop_state INT
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;
    
    START TRANSACTION;
    
    IF p_id IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El ID del taller es requerido';
    END IF;
    
    IF p_year IS NOT NULL AND (p_year < 2000 OR p_year > 2100) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El año debe estar entre 2000 y 2100';
    END IF;
    
    IF p_limit_inscriptions IS NOT NULL AND p_limit_inscriptions < 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El límite de inscripciones debe ser mayor o igual a 0';
    END IF;
    
    IF p_id_professor IS NOT NULL AND NOT EXISTS (SELECT 1 FROM PROFESSORS WHERE id = p_id_professor) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El profesor no existe';
    END IF;
    
    IF p_id_workshop_state IS NOT NULL AND NOT EXISTS (SELECT 1 FROM WORKSHOP_STATES WHERE id = p_id_workshop_state) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El estado del taller no existe';
    END IF;
    
    UPDATE WORKSHOPS 
    SET name = COALESCE(p_name, name),
        semester = COALESCE(p_semester, semester),
        year = COALESCE(p_year, year),
        id_professor = COALESCE(p_id_professor, id_professor),
        description = COALESCE(p_description, description),
        inscription_start_date = COALESCE(p_inscription_start_date, inscription_start_date),
        inscription_end_date = COALESCE(p_inscription_end_date, inscription_end_date),
        course_start_date = COALESCE(p_course_start_date, course_start_date),
        course_end_date = COALESCE(p_course_end_date, course_end_date),
        limit_inscriptions = COALESCE(p_limit_inscriptions, limit_inscriptions),
        id_workshop_state = COALESCE(p_id_workshop_state, id_workshop_state)
    WHERE id = p_id;
    
    IF ROW_COUNT() = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Taller no encontrado';
    END IF;
    
    COMMIT;
END$$
CREATE PROCEDURE sp_delete_workshop(IN p_id INT)
BEGIN
    DECLARE v_count INT;
    
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;
    
    START TRANSACTION;
    
    IF p_id IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El ID del taller es requerido';
    END IF;
    
    -- Verificar si tiene inscripciones
    SELECT COUNT(*) INTO v_count FROM WORKSHOPS_INSCRIPTIONS WHERE id_workshop = p_id;
    
    IF v_count > 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No se puede eliminar el taller porque tiene inscripciones';
    END IF;
    
    -- Verificar si tiene calificaciones
    SELECT COUNT(*) INTO v_count FROM WORKSHOPS_GRADES WHERE id_workshop = p_id;
    
    IF v_count > 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No se puede eliminar el taller porque tiene calificaciones';
    END IF;
    
    -- Verificar si tiene convalidaciones
    SELECT COUNT(*) INTO v_count FROM CONVALIDATIONS_WORKSHOPS WHERE id_workshop = p_id;
    
    IF v_count > 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No se puede eliminar el taller porque tiene convalidaciones asociadas';
    END IF;
    
    DELETE FROM WORKSHOPS WHERE id = p_id;
    
    IF ROW_COUNT() = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Taller no encontrado';
    END IF;
    
    COMMIT;
END$$
CREATE PROCEDURE sp_change_workshop_state(IN p_id INT, IN p_id_workshop_state INT)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;
    
    START TRANSACTION;
    
    IF p_id IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El ID del taller es requerido';
    END IF;
    
    IF p_id_workshop_state IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El estado del taller es requerido';
    END IF;
    
    -- Verificar que el estado existe
    IF NOT EXISTS (SELECT 1 FROM WORKSHOP_STATES WHERE id = p_id_workshop_state) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El estado del taller no existe';
    END IF;
    
    UPDATE WORKSHOPS SET id_workshop_state = p_id_workshop_state WHERE id = p_id;
    
    IF ROW_COUNT() = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Taller no encontrado';
    END IF;
    
    COMMIT;
END$$

-- =============================================================================
-- 4. PROCEDIMIENTOS DE TABLAS DE NEGOCIO
-- =============================================================================

CREATE PROCEDURE sp_get_request_by_id(IN p_id INT)
BEGIN
    SELECT id_request, id_student, student, administrator, sent_at, reviewed_at, rol_student, rut_student, student_campus FROM vw_requests WHERE id = p_id;
END$$
CREATE PROCEDURE sp_get_requests_by_student(IN p_id_student INT)
BEGIN
    SELECT id_request, id_student, student, administrator, sent_at, reviewed_at, rol_student, rut_student, student_campus FROM vw_requests WHERE id_student = p_id_student;
END$$
CREATE PROCEDURE sp_get_request_convalidations(IN p_id_request INT)
BEGIN
    SELECT id_convalidation, id_request, convalidation_type, convalidation_state, curriculum_course, student, rol_student, rut_student FROM vw_convalidations WHERE id_request = p_id_request;
END$$

CREATE PROCEDURE sp_get_convalidations()
BEGIN
    SELECT id_convalidation, id_request, convalidation_type, convalidation_state, curriculum_course, student, rol_student, rut_student FROM vw_convalidations;
END$$
CREATE PROCEDURE sp_get_convalidation_by_id(IN p_id INT)
BEGIN
    SELECT * FROM vw_convalidations WHERE id_convalidation = p_id;
END$$
CREATE PROCEDURE sp_get_convalidations_by_student(IN p_id_student INT)
BEGIN
    SELECT id_convalidation, id_request, convalidation_type, convalidation_state, curriculum_course, student, rol_student, rut_student FROM vw_convalidations
    WHERE id_student = p_id_student;
END$$
CREATE PROCEDURE sp_get_convalidations_by_state(IN p_id_convalidation_state INT)
BEGIN
    SELECT id_convalidation, id_request, convalidation_type, convalidation_state, curriculum_course, student, rol_student, rut_student FROM vw_convalidations 
    WHERE id_convalidation_state = p_id_convalidation_state;
END$$
CREATE PROCEDURE sp_get_convalidations_by_type(IN p_id_convalidation_type INT)
BEGIN
    SELECT id_convalidation, id_request, convalidation_type, convalidation_state, curriculum_course, student, rol_student, rut_student FROM vw_convalidations 
    WHERE id_convalidation_type = p_id_convalidation_type;
END$$
CREATE PROCEDURE sp_get_convalidations_reviewed_by_admin(IN p_id_administrator INT)
BEGIN
    SELECT id_convalidation, id_request, convalidation_type, convalidation_state, curriculum_course, student, rol_student, rut_student FROM vw_convalidations 
    WHERE id_administrator = p_id_administrator;
END$$
CREATE PROCEDURE sp_get_convalidation_subjects(IN p_id_convalidation INT)
BEGIN
    SELECT * FROM vw_convalidation_subjects WHERE id_convalidation = p_id_convalidation;
END$$
CREATE PROCEDURE sp_get_convalidation_workshops(IN p_id_convalidation INT)
BEGIN
    SELECT * FROM vw_convalidation_workshops WHERE id_convalidation = p_id_convalidation;
END$$
CREATE PROCEDURE sp_get_convalidation_external_activities(IN p_id_convalidation INT)
BEGIN
    SELECT * FROM vw_convalidation_external_activities WHERE id_convalidation = p_id_convalidation;
END$$
CREATE PROCEDURE sp_search_convalidations(
    IN p_id_convalidation_state INT,
    IN p_id_convalidation_type INT,
    IN p_id_curriculum_course INT,
    IN p_id_student INT,
    IN p_id_curriculum_course_type INT,
    IN p_id_department INT,
    IN p_id_subject INT,
    IN p_id_workshop INT,
    IN p_date_from DATE,
    IN p_date_to DATE,
    IN p_review_date_from DATE,
    IN p_review_date_to DATE,
    IN p_id_administrator INT,
    IN p_campus VARCHAR(255),
    IN p_academic_year INT,
    IN p_semester ENUM('1', '2')
)
BEGIN
    SELECT id_convalidation, id_request, convalidation_type, convalidation_state, curriculum_course, student, rol_student, rut_student  FROM vw_convalidations
    WHERE (p_id_convalidation_state IS NULL OR id_convalidation_state = p_id_convalidation_state)
    AND (p_id_convalidation_type IS NULL OR id_convalidation_type = p_id_convalidation_type)
    AND (p_id_curriculum_course IS NULL OR id_curriculum_course = p_id_curriculum_course)
    AND (p_id_student IS NULL OR id_student = p_id_student)
    AND (p_id_curriculum_course_type IS NULL OR id_curriculum_course_type = p_id_curriculum_course_type)
    AND (p_id_department IS NULL OR id_department = p_id_department)
    AND (p_id_subject IS NULL OR id_subject = p_id_subject)
    AND (p_id_workshop IS NULL OR id_workshop = p_id_workshop)
    AND (p_date_from IS NULL OR DATE(created_at) >= p_date_from)
    AND (p_date_to IS NULL OR DATE(created_at) <= p_date_to)
    AND (p_review_date_from IS NULL OR DATE(reviewed_at) >= p_review_date_from)
    AND (p_review_date_to IS NULL OR DATE(reviewed_at) <= p_review_date_to)
    AND (p_id_administrator IS NULL OR id_administrator = p_id_administrator)
    AND (p_campus IS NULL OR campus = p_campus)
    AND (p_academic_year IS NULL OR academic_year = p_academic_year)
    AND (p_semester IS NULL OR semester = p_semester);
END$$
CREATE PROCEDURE sp_create_convalidation(
    IN p_id_student INT,
    IN p_id_convalidation_type INT,
    IN p_id_curriculum_course INT,
    IN p_review_comments TEXT,
    -- Parámetros para convalidación de asignatura
    IN p_id_subject INT,
    -- Parámetros para convalidación de taller
    IN p_id_workshop INT,
    -- Parámetros para convalidación de actividad externa
    IN p_activity_name VARCHAR(255),
    IN p_description VARCHAR(255),
    IN p_file_name VARCHAR(255),
    IN p_file_data LONGBLOB
)
BEGIN
    DECLARE v_request_id INT;
    DECLARE v_convalidation_id INT;
    DECLARE v_convalidation_state INT;
    
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;
    
    START TRANSACTION;
    
    IF p_id_student IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El ID del estudiante es requerido';
    END IF;
    
    IF p_id_convalidation_type IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El tipo de convalidación es requerido';
    END IF;
    
    IF p_id_curriculum_course IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El curso curricular es requerido';
    END IF;
    
    -- Verificar que el estudiante existe
    IF NOT EXISTS (SELECT 1 FROM STUDENTS WHERE id = p_id_student) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El estudiante no existe';
    END IF;
    
    -- Verificar que el tipo de convalidación existe
    IF NOT EXISTS (SELECT 1 FROM CONVALIDATION_TYPES WHERE id = p_id_convalidation_type) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El tipo de convalidación no existe';
    END IF;
    
    -- Verificar que el curso curricular existe
    IF NOT EXISTS (SELECT 1 FROM CURRICULUM_COURSES WHERE id = p_id_curriculum_course) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El curso curricular no existe';
    END IF;
    
    -- Verificar que al menos uno de los tipos de convalidación esté presente
    IF p_id_subject IS NULL AND p_id_workshop IS NULL AND (p_activity_name IS NULL OR TRIM(p_activity_name) = '') THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Debe especificar al menos un tipo de convalidación (asignatura, taller o actividad externa)';
    END IF;
    
    -- Verificar que solo se especifique un tipo de convalidación
    IF (p_id_subject IS NOT NULL AND p_id_workshop IS NOT NULL) OR 
       (p_id_subject IS NOT NULL AND p_activity_name IS NOT NULL AND TRIM(p_activity_name) != '') OR
       (p_id_workshop IS NOT NULL AND p_activity_name IS NOT NULL AND TRIM(p_activity_name) != '') THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Solo puede especificar un tipo de convalidación a la vez';
    END IF;
    
    -- Verificar que la asignatura existe (si se especifica)
    IF p_id_subject IS NOT NULL AND NOT EXISTS (SELECT 1 FROM SUBJECTS WHERE id = p_id_subject) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La asignatura no existe';
    END IF;
    
    -- Verificar que el taller existe (si se especifica)
    IF p_id_workshop IS NOT NULL AND NOT EXISTS (SELECT 1 FROM WORKSHOPS WHERE id = p_id_workshop) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El taller no existe';
    END IF;
    
    -- Determinar el estado inicial según el tipo de convalidación
    -- Según los datos iniciales: 1=ENVIADA, 2=RECHAZADA_DI, 3=APROBADA_DI, 4=ENVIADA_DE, 5=RECHAZADA_DE, 6=APROBADA_DE
    SET v_convalidation_state = 1; -- ENVIADA por defecto
    
    -- 1. Crear la solicitud
    INSERT INTO REQUESTS (id_student) VALUES (p_id_student);
    SET v_request_id = LAST_INSERT_ID();
    
    -- 2. Crear la convalidación
    INSERT INTO CONVALIDATIONS (
        id_request, id_convalidation_type, id_convalidation_state, 
        id_curriculum_course, review_comments
    ) VALUES (
        v_request_id, p_id_convalidation_type, v_convalidation_state, 
        p_id_curriculum_course, p_review_comments
    );
    SET v_convalidation_id = LAST_INSERT_ID();
    
    -- 3. Crear el registro correspondiente según el tipo
    IF p_id_subject IS NOT NULL THEN
        -- Convalidación de asignatura
        INSERT INTO CONVALIDATIONS_SUBJECTS (id_convalidation, id_subject) 
        VALUES (v_convalidation_id, p_id_subject);
    ELSEIF p_id_workshop IS NOT NULL THEN
        -- Convalidación de taller
        INSERT INTO CONVALIDATIONS_WORKSHOPS (id_convalidation, id_workshop) 
        VALUES (v_convalidation_id, p_id_workshop);
    ELSEIF p_activity_name IS NOT NULL AND TRIM(p_activity_name) != '' THEN
        -- Convalidación de actividad externa
        INSERT INTO CONVALIDATIONS_EXTERNAL_ACTIVITIES (
            id_convalidation, activity_name, description, file_name, file_data
        ) VALUES (
            v_convalidation_id, p_activity_name, p_description, p_file_name, p_file_data
        );
    END IF;
    
    COMMIT;
END$$
CREATE PROCEDURE sp_review_convalidation(
    IN p_id INT,
    IN p_id_convalidation_state INT,
    IN p_review_comments TEXT
)
BEGIN
    DECLARE v_current_state INT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;

    IF p_id IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El ID de la convalidación es requerido';
    END IF;

    IF p_id_convalidation_state IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El estado de convalidación es requerido';
    END IF;

    -- Verificar que la convalidación existe y obtener su estado actual
    SELECT id_convalidation_state INTO v_current_state FROM CONVALIDATIONS WHERE id = p_id;
    IF v_current_state IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Convalidación no encontrada';
    END IF;

    -- Solo permitir revisión si está en estado ENVIADA (1)
    IF v_current_state != 1 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Solo se puede revisar una convalidación en estado enviada';
    END IF;

    -- Verificar que el nuevo estado es válido (solo RECHAZADA_DI=2, APROBADA_DI=3, ENVIADA_DE=4)
    IF p_id_convalidation_state NOT IN (2, 3, 4) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El estado de revisión debe ser RECHAZADA_DI, APROBADA_DI o ENVIADA_DE';
    END IF;

    -- Actualizar estado y comentarios de revisión
    UPDATE CONVALIDATIONS
    SET id_convalidation_state = p_id_convalidation_state,
        review_comments = COALESCE(p_review_comments, review_comments)
    WHERE id = p_id;

    IF ROW_COUNT() = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Convalidación no encontrada';
    END IF;

    COMMIT;
END$$
CREATE PROCEDURE sp_update_convalidation(
    IN p_id INT,
    IN p_id_convalidation_state INT,
    IN p_review_comments TEXT
)
BEGIN
    DECLARE v_current_state INT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;

    IF p_id IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El ID de la convalidación es requerido';
    END IF;

    -- Verificar que la convalidación existe y obtener su estado actual
    SELECT id_convalidation_state INTO v_current_state FROM CONVALIDATIONS WHERE id = p_id;
    IF v_current_state IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Convalidación no encontrada';
    END IF;

    -- Solo permitir edición si está en estado ENVIADA (1)
    IF v_current_state != 1 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Solo se puede editar una convalidación en estado enviada';
    END IF;

    IF p_id_convalidation_state IS NOT NULL AND NOT EXISTS (SELECT 1 FROM CONVALIDATION_STATES WHERE id = p_id_convalidation_state) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El estado de convalidación no existe';
    END IF;

    UPDATE CONVALIDATIONS 
    SET id_convalidation_state = COALESCE(p_id_convalidation_state, id_convalidation_state),
        review_comments = COALESCE(p_review_comments, review_comments)
    WHERE id = p_id;

    IF ROW_COUNT() = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Convalidación no encontrada';
    END IF;

    COMMIT;
END$$
CREATE PROCEDURE sp_delete_convalidation(IN p_id INT)
BEGIN
    DECLARE v_state INT;
    
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;
    
    START TRANSACTION;
    
    IF p_id IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El ID de la convalidación es requerido';
    END IF;
    
    -- Verificar que no esté revisada
    SELECT id_convalidation_state INTO v_state FROM CONVALIDATIONS WHERE id = p_id;
    
    IF v_state != 1 THEN -- 1 = ENVIADA
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Solo se pueden eliminar convalidaciones en estado enviada';
    END IF;
    
    DELETE FROM CONVALIDATIONS WHERE id = p_id;
    
    IF ROW_COUNT() = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Convalidación no encontrada';
    END IF;
    
    COMMIT;
END$$


-- =============================================================================
-- 5. PROCEDIMIENTOS DE INSCRIPCIONES Y CALIFICACIONES
-- =============================================================================

CREATE PROCEDURE sp_get_workshop_inscriptions()
BEGIN
    SELECT id_inscription, rut_student, rol_student, student, workshop, is_convalidated, curriculum_course FROM vw_workshop_inscriptions;
END$$
CREATE PROCEDURE sp_get_workshop_inscription_by_id(IN p_id INT)
BEGIN
    SELECT * FROM vw_workshop_inscriptions WHERE id_inscription = p_id;
END$$
CREATE PROCEDURE sp_get_workshop_inscriptions_by_workshop(IN p_id_workshop INT)
BEGIN
    SELECT id_inscription, rut_student, rol_student, student FROM vw_workshop_inscriptions WHERE id_workshop = p_id_workshop;
END$$
CREATE PROCEDURE sp_get_workshop_inscriptions_by_student(IN p_id_student INT)
BEGIN
    SELECT id_inscription, workshop, is_convalidated, curriculum_course FROM vw_workshop_inscriptions WHERE id_student = p_id_student;
END$$
CREATE PROCEDURE sp_create_workshop_inscription(
    IN p_id_student INT,
    IN p_id_workshop INT,
    IN p_id_curriculum_course INT,
    IN p_is_convalidated TINYINT(1)
)
BEGIN
    DECLARE v_workshop_state INT;
    DECLARE v_inscriptions_count INT;
    DECLARE v_limit_inscriptions INT;
    DECLARE v_inscription_start_date TIMESTAMP;
    DECLARE v_inscription_end_date TIMESTAMP;
    
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;
    
    START TRANSACTION;
    
    IF p_id_student IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El ID del estudiante es requerido';
    END IF;
    
    IF p_id_workshop IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El ID del taller es requerido';
    END IF;
    
    -- Verificar que el estudiante existe
    IF NOT EXISTS (SELECT 1 FROM STUDENTS WHERE id = p_id_student) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El estudiante no existe';
    END IF;
    
    -- Verificar que el taller existe
    IF NOT EXISTS (SELECT 1 FROM WORKSHOPS WHERE id = p_id_workshop) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El taller no existe';
    END IF;
    
    -- Verificar que el curso curricular existe (si se proporciona)
    IF p_id_curriculum_course IS NOT NULL AND NOT EXISTS (SELECT 1 FROM CURRICULUM_COURSES WHERE id = p_id_curriculum_course) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El curso curricular no existe';
    END IF;
    
    -- Obtener información del taller
    SELECT id_workshop_state, inscriptions_number, limit_inscriptions, 
           inscription_start_date, inscription_end_date
    INTO v_workshop_state, v_inscriptions_count, v_limit_inscriptions,
         v_inscription_start_date, v_inscription_end_date
    FROM WORKSHOPS WHERE id = p_id_workshop;
    
    -- Verificar que el taller esté en estado de inscripción
    IF v_workshop_state != 1 THEN -- 1 = INSCRIPCION
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El taller no está en período de inscripción';
    END IF;
    
    -- Verificar que esté en período de inscripción
    IF NOW() < v_inscription_start_date OR NOW() > v_inscription_end_date THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El período de inscripción ha terminado o no ha comenzado';
    END IF;
    
    -- Verificar que hay cupos disponibles
    IF v_inscriptions_count >= v_limit_inscriptions THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No hay cupos disponibles para este taller';
    END IF;
    
    -- Verificar que el estudiante no esté ya inscrito
    IF EXISTS (SELECT 1 FROM WORKSHOPS_INSCRIPTIONS WHERE id_student = p_id_student AND id_workshop = p_id_workshop) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El estudiante ya está inscrito en este taller';
    END IF;
    
    -- Crear la inscripción
    INSERT INTO WORKSHOPS_INSCRIPTIONS (
        id_student, id_workshop, id_curriculum_course, is_convalidated
    ) VALUES (
        p_id_student, p_id_workshop, p_id_curriculum_course, COALESCE(p_is_convalidated, 0)
    );
    
    -- Actualizar el contador de inscripciones
    UPDATE WORKSHOPS SET inscriptions_number = inscriptions_number + 1 WHERE id = p_id_workshop;
    
    COMMIT;
END$$
CREATE PROCEDURE sp_update_workshop_inscription(
    IN p_id INT,
    IN p_id_curriculum_course INT,
    IN p_is_convalidated TINYINT(1)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;
    
    START TRANSACTION;
    
    IF p_id IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El ID de la inscripción es requerido';
    END IF;
    
    IF p_id_curriculum_course IS NOT NULL AND NOT EXISTS (SELECT 1 FROM CURRICULUM_COURSES WHERE id = p_id_curriculum_course) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El curso curricular no existe';
    END IF;
    
    UPDATE WORKSHOPS_INSCRIPTIONS 
    SET id_curriculum_course = COALESCE(p_id_curriculum_course, id_curriculum_course),
        is_convalidated = COALESCE(p_is_convalidated, is_convalidated)
    WHERE id = p_id;
    
    IF ROW_COUNT() = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Inscripción no encontrada';
    END IF;
    
    COMMIT;
END$$
CREATE PROCEDURE sp_delete_workshop_inscription(IN p_id INT)
BEGIN
    DECLARE v_id_workshop INT;
    DECLARE v_course_start_date TIMESTAMP;
    
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;
    
    START TRANSACTION;
    
    IF p_id IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El ID de la inscripción es requerido';
    END IF;
    
    
    SELECT id_workshop, course_start_date INTO v_id_workshop, v_course_start_date 
    FROM vw_workshop_inscriptions 
    WHERE id = p_id;
    
    IF v_id_workshop IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Inscripción no encontrada';
    END IF;
    
    -- Verificar que el taller aún no ha comenzado
    IF NOW() >= v_course_start_date THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No se puede eliminar la inscripción porque el taller ya ha comenzado';
    END IF;
    
    -- Eliminar la inscripción
    DELETE FROM WORKSHOPS_INSCRIPTIONS WHERE id = p_id;
    
    
    UPDATE WORKSHOPS SET inscriptions_number = inscriptions_number - 1 WHERE id = v_id_workshop;
    
    COMMIT;
END$$


CREATE PROCEDURE sp_get_workshop_grades()
BEGIN
    SELECT id_grade, student, workshop, rol_student, rut_student, grade  FROM vw_workshop_grades;
END$$
CREATE PROCEDURE sp_get_workshop_grade_by_id(IN p_id INT)
BEGIN
    SELECT * FROM vw_workshop_grades WHERE id_grade = p_id;
END$$
CREATE PROCEDURE sp_get_workshop_grades_by_workshop(IN p_id_workshop INT)
BEGIN
    SELECT id_grade, student, workshop, rol_student, rut_student, grade FROM vw_workshop_grades WHERE id_workshop = p_id_workshop;
END$$
CREATE PROCEDURE sp_get_workshop_grades_by_student(IN p_id_student INT)
BEGIN
    SELECT id_grade, student, workshop, rol_student, rut_student, grade FROM vw_workshop_grades WHERE id_student = p_id_student;
END$$
CREATE PROCEDURE sp_create_workshop_grade(
    IN p_id_student INT,
    IN p_id_workshop INT,
    IN p_grade INT
)
BEGIN
    DECLARE v_workshop_state INT;
    
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;
    
    START TRANSACTION;
    
    IF p_id_student IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El ID del estudiante es requerido';
    END IF;
    
    IF p_id_workshop IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El ID del taller es requerido';
    END IF;
    
    IF p_grade IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La calificación es requerida';
    END IF;
    
    IF p_grade < 0 OR p_grade > 100 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La calificación debe estar entre 0 y 100';
    END IF;
    
    -- Verificar que el estudiante existe
    IF NOT EXISTS (SELECT 1 FROM STUDENTS WHERE id = p_id_student) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El estudiante no existe';
    END IF;
    
    -- Verificar que el taller existe
    IF NOT EXISTS (SELECT 1 FROM WORKSHOPS WHERE id = p_id_workshop) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El taller no existe';
    END IF;
    
    -- Verificar que el estudiante está inscrito
    IF NOT EXISTS (SELECT 1 FROM WORKSHOPS_INSCRIPTIONS WHERE id_student = p_id_student AND id_workshop = p_id_workshop) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El estudiante no está inscrito en este taller';
    END IF;
    
    -- Verificar que no existe ya una calificación
    IF EXISTS (SELECT 1 FROM WORKSHOPS_GRADES WHERE id_student = p_id_student AND id_workshop = p_id_workshop) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Ya existe una calificación para este estudiante en este taller';
    END IF;
    
    -- Obtener el estado del taller
    SELECT id_workshop_state INTO v_workshop_state FROM WORKSHOPS WHERE id = p_id_workshop;
    
    -- Verificar que el taller esté finalizado
    IF v_workshop_state != 3 THEN -- 3 = FINALIZADO
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El taller no está finalizado';
    END IF;
    
    -- Crear la calificación
    INSERT INTO WORKSHOPS_GRADES (id_student, id_workshop, grade) 
    VALUES (p_id_student, p_id_workshop, p_grade);
    
    COMMIT;
END$$
CREATE PROCEDURE sp_update_workshop_grade(
    IN p_id INT,
    IN p_grade INT
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;
    
    START TRANSACTION;
    
    IF p_id IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El ID de la calificación es requerido';
    END IF;
    
    IF p_grade IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La calificación es requerida';
    END IF;
    
    IF p_grade < 0 OR p_grade > 100 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La calificación debe estar entre 0 y 100';
    END IF;
    
    UPDATE WORKSHOPS_GRADES SET grade = p_grade WHERE id = p_id;
    
    IF ROW_COUNT() = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Calificación no encontrada';
    END IF;
    
    COMMIT;
END$$
CREATE PROCEDURE sp_delete_workshop_grade(IN p_id INT)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;
    
    START TRANSACTION;
    
    IF p_id IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El ID de la calificación es requerido';
    END IF;
    
    DELETE FROM WORKSHOPS_GRADES WHERE id = p_id;
    
    IF ROW_COUNT() = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Calificación no encontrada';
    END IF;
    
    COMMIT;
END$$

-- =============================================================================
-- 6. PROCEDIMIENTOS DE AUTENTICACIÓN
-- =============================================================================


CREATE PROCEDURE sp_login(
    IN p_email VARCHAR(255),
    IN p_password_hash VARCHAR(255)
)
BEGIN
    DECLARE v_user_id INT;
    DECLARE v_user_type VARCHAR(20);

    SELECT id, user_type INTO v_user_id, v_user_type FROM AUTH_USERS WHERE email = p_email AND password_hash = p_password_hash;

    IF v_user_id IS NULL THEN
        SIGNAL SQLSTATE '45011' SET MESSAGE_TEXT = 'Credenciales inválidas';
    END IF;

    IF v_user_type = 'STUDENT' THEN
        SELECT * FROM vw_students WHERE id = v_user_id;
    ELSEIF v_user_type = 'ADMINISTRATOR' THEN
        SELECT * FROM vw_administrators WHERE id = v_user_id;
    ELSE
        SIGNAL SQLSTATE '45012' SET MESSAGE_TEXT = 'Usuario sin tipo definido';
    END IF;
END$$
CREATE PROCEDURE sp_change_password(
    IN p_id INT,
    IN p_new_password_hash VARCHAR(255),
    IN p_repeat_new_password_hash VARCHAR(255)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;

    IF p_id IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El ID del usuario es requerido';
    END IF;

    IF p_new_password_hash IS NULL OR TRIM(p_new_password_hash) = '' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La nueva contraseña es requerida';
    END IF;

    IF p_repeat_new_password_hash IS NULL OR TRIM(p_repeat_new_password_hash) = '' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La repetición de la nueva contraseña es requerida';
    END IF;

    IF p_new_password_hash != p_repeat_new_password_hash THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Las contraseñas no coinciden';
    END IF;

    UPDATE AUTH_USERS SET password_hash = p_new_password_hash WHERE id = p_id;

    IF ROW_COUNT() = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Usuario no encontrado';
    END IF;

    COMMIT;
END$$
CREATE PROCEDURE sp_get_salt(IN p_id INT)
BEGIN
    SELECT salt FROM AUTH_USERS WHERE id = p_id;
END$$

-- =============================================================================
-- 7. PROCEDIMIENTOS DE USUARIOS
-- =============================================================================


CREATE PROCEDURE sp_get_students()
BEGIN
    SELECT id_student, rut_student, student FROM vw_students;
END$$
CREATE PROCEDURE sp_get_student_by_id(IN p_id INT)
BEGIN
    SELECT * FROM vw_students WHERE id_student = p_id;
END$$
CREATE PROCEDURE sp_get_student_by_rut(IN p_rut VARCHAR(12))
BEGIN
    SELECT * FROM vw_students WHERE rut_student = p_rut;
END$$
CREATE PROCEDURE sp_get_student_by_rol(IN p_rol VARCHAR(11))
BEGIN
    SELECT * FROM vw_students WHERE rol_student = p_rol;
END$$
CREATE PROCEDURE sp_search_students(
    IN p_student VARCHAR(255),
    IN p_id_student INT,
    IN p_rut VARCHAR(12),
    IN p_rol VARCHAR(11),
    IN p_campus VARCHAR(255),
    IN p_email VARCHAR(255)
    )
BEGIN
    SELECT * FROM vw_students
    WHERE (p_student IS NULL OR student LIKE CONCAT('%', p_student, '%'))
    AND (p_id_student IS NULL OR id_student = p_id_student)
    AND (p_rut IS NULL OR rut_student = p_rut)
    AND (p_rol IS NULL OR rol_student = p_rol)
    AND (p_campus IS NULL OR campus = p_campus)
    AND (p_email IS NULL OR email = p_email);
END $$
CREATE PROCEDURE sp_create_student(
    IN p_full_name VARCHAR(255),
    IN p_campus VARCHAR(255),
    IN p_email VARCHAR(255),
    IN p_password_hash VARCHAR(255),
    IN p_rol_student VARCHAR(11),
    IN p_rut_student VARCHAR(12),
    IN p_campus_student VARCHAR(255),
    IN p_salt VARCHAR(255)
)
BEGIN
    DECLARE v_user_id INT;
    
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;
    
    START TRANSACTION;
    
    IF p_full_name IS NULL OR TRIM(p_full_name) = '' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El nombre completo es requerido';
    END IF;
    
    IF p_email IS NULL OR TRIM(p_email) = '' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El email es requerido';
    END IF;
    
    IF p_password_hash IS NULL OR TRIM(p_password_hash) = '' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La contraseña es requerida';
    END IF;
    
    IF p_rol_student IS NULL OR TRIM(p_rol_student) = '' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El ROL es requerido';
    END IF;
    
    IF p_rut_student IS NULL OR TRIM(p_rut_student) = '' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El RUT es requerido';
    END IF;
    
    -- Verificar que el email no esté registrado
    IF EXISTS (SELECT 1 FROM AUTH_USERS WHERE email = p_email) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El email ya está registrado';
    END IF;
    
    -- Verificar que el ROL no esté registrado
    IF EXISTS (SELECT 1 FROM USERS WHERE rol_student = p_rol_student) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El ROL ya está registrado';
    END IF;
    
    -- Verificar que el RUT no esté registrado
    IF EXISTS (SELECT 1 FROM USERS WHERE rut_student = p_rut_student) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El RUT ya está registrado';
    END IF;
    
    INSERT INTO AUTH_USERS (email, password_hash, salt) VALUES (p_email, p_password_hash, p_salt);
    SET v_user_id = LAST_INSERT_ID();
    
    INSERT INTO USERS (id, full_name, campus, rol_student, user_type, email) 
    VALUES (v_user_id, p_full_name, p_campus, p_rol_student, 'STUDENT', p_email);
    COMMIT;
END$$
CREATE PROCEDURE sp_update_student(
    IN p_id INT,
    IN p_full_name VARCHAR(255),
    IN p_campus VARCHAR(255),
    IN p_email VARCHAR(255),
    IN p_rol_student VARCHAR(11),
    IN p_rut_student VARCHAR(12),
    IN p_salt VARCHAR(255)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;
    
    START TRANSACTION;
    
    IF p_id IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El ID del estudiante es requerido';
    END IF;
    
    -- Verificar que el estudiante existe
    IF NOT EXISTS (SELECT 1 FROM STUDENTS WHERE id = p_id) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El estudiante no existe';
    END IF;
    
    -- Verificar email único
    IF p_email IS NOT NULL AND EXISTS (SELECT 1 FROM AUTH_USERS WHERE email = p_email AND id != p_id) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El email ya está registrado';
    END IF;
    
    -- Verificar ROL único
    IF p_rol_student IS NOT NULL AND EXISTS (SELECT 1 FROM STUDENTS WHERE rol_student = p_rol_student AND id != p_id) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El ROL ya está registrado';
    END IF;
    
    -- Verificar RUT único
    IF p_rut_student IS NOT NULL AND EXISTS (SELECT 1 FROM STUDENTS WHERE rut_student = p_rut_student AND id != p_id) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El RUT ya está registrado';
    END IF;
    
    UPDATE USERS 
    SET full_name = COALESCE(p_full_name, full_name),
        campus = COALESCE(p_campus, campus),
        rol_student = COALESCE(p_rol_student, rol_student),
        rut_student = COALESCE(p_rut_student, rut_student)
    WHERE id = p_id;

    COMMIT;
END$$
CREATE PROCEDURE sp_delete_student(IN p_id INT)
BEGIN
    DECLARE v_count INT;
    
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;
    
    START TRANSACTION;
    
    IF p_id IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El ID del estudiante es requerido';
    END IF;
    
    
    IF NOT EXISTS (SELECT 1 FROM USERS WHERE id = p_id) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El estudiante no existe';
    END IF;
    
    -- Verificar que no tenga solicitudes activas
    SELECT COUNT(*) INTO v_count FROM REQUESTS WHERE id_student = p_id;
    
    IF v_count > 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No se puede eliminar el estudiante porque tiene solicitudes activas';
    END IF;
    
    -- Verificar que no tenga inscripciones activas
    SELECT COUNT(*) INTO v_count FROM WORKSHOPS_INSCRIPTIONS WHERE id_student = p_id;
    
    IF v_count > 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No se puede eliminar el estudiante porque tiene inscripciones activas';
    END IF;
    
    DELETE FROM USERS WHERE id = p_id;
    COMMIT;
END$$


CREATE PROCEDURE sp_get_administrators()
BEGIN
    SELECT * FROM vw_admins_preview;
END$$
CREATE PROCEDURE sp_get_administrator_by_id(IN p_id INT)
BEGIN
    SELECT * FROM vw_admins WHERE id_administrator = p_id;
END$$
CREATE PROCEDURE sp_create_administrator(
    IN p_full_name VARCHAR(255),
    IN p_campus VARCHAR(255),
    IN p_email VARCHAR(255),
    IN p_password_hash VARCHAR(255),
    IN p_salt VARCHAR(255)
)
BEGIN
    DECLARE v_user_id INT;
    
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;
    
    START TRANSACTION;
    
    IF p_full_name IS NULL OR TRIM(p_full_name) = '' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El nombre completo es requerido';
    END IF;
    
    IF p_email IS NULL OR TRIM(p_email) = '' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El email es requerido';
    END IF;
    
    IF p_password_hash IS NULL OR TRIM(p_password_hash) = '' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La contraseña es requerida';
    END IF;
    
    -- Verificar que el email no esté registrado
    IF EXISTS (SELECT 1 FROM AUTH_USERS WHERE email = p_email) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El email ya está registrado';
    END IF;
    
    -- Crear usuario de autenticación
    INSERT INTO AUTH_USERS (email, password_hash, salt) VALUES (p_email, p_password_hash, p_salt);
    SET v_user_id = LAST_INSERT_ID();
    
    -- Crear usuario principal
    INSERT INTO USERS (id, full_name, campus, user_type) VALUES (v_user_id, p_full_name, p_campus, 'ADMINISTRATOR');
    
    COMMIT;
END$$
CREATE PROCEDURE sp_update_administrator(
    IN p_id INT,
    IN p_full_name VARCHAR(255),
    IN p_campus VARCHAR(255),
    IN p_email VARCHAR(255)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;
    
    START TRANSACTION;
    
    IF p_id IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El ID del administrador es requerido';
    END IF;
    
    -- Verificar que el administrador existe
    IF NOT EXISTS (SELECT 1 FROM ADMINISTRATORS WHERE id = p_id) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El administrador no existe';
    END IF;
    
    -- Verificar email único
    IF p_email IS NOT NULL AND EXISTS (SELECT 1 FROM AUTH_USERS WHERE email = p_email AND id != p_id) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El email ya está registrado';
    END IF;
    
    
    UPDATE USERS 
    SET full_name = COALESCE(p_full_name, full_name),
        campus = COALESCE(p_campus, campus)
    WHERE id = p_id;
    
    
    IF p_email IS NOT NULL THEN
        UPDATE AUTH_USERS SET email = p_email WHERE id = p_id;
    END IF;
    
    COMMIT;
END$$
CREATE PROCEDURE sp_delete_administrator(IN p_id INT)
BEGIN
    DECLARE v_count INT;
    
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;
    
    START TRANSACTION;
    
    IF p_id IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El ID del administrador es requerido';
    END IF;
    
    -- Verificar que el administrador existe
    IF NOT EXISTS (SELECT 1 FROM ADMINISTRATORS WHERE id = p_id) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El administrador no existe';
    END IF;
    
    -- Verificar que no tenga solicitudes revisadas
    SELECT COUNT(*) INTO v_count FROM REQUESTS WHERE id_reviewed_by = p_id;
    
    IF v_count > 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No se puede eliminar el administrador porque tiene solicitudes revisadas';
    END IF;
    
    -- Eliminar en cascada
    DELETE FROM ADMINISTRATORS WHERE id = p_id;
    
    COMMIT;
END$$


CREATE PROCEDURE sp_get_professors()
BEGIN
    SELECT * FROM vw_professors;
END$$
CREATE PROCEDURE sp_create_professor(
    IN p_name VARCHAR(255),
    IN p_email VARCHAR(255)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;
    
    START TRANSACTION;
    
    IF p_name IS NULL OR TRIM(p_name) = '' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El nombre del profesor es requerido';
    END IF;
    
    IF p_email IS NULL OR TRIM(p_email) = '' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El email del profesor es requerido';
    END IF;
    
    -- Verificar que el email no esté registrado
    IF EXISTS (SELECT 1 FROM PROFESSORS WHERE email = p_email) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El email ya está registrado';
    END IF;
    
    INSERT INTO PROFESSORS (name, email) VALUES (p_name, p_email);
    
    COMMIT;
END$$
CREATE PROCEDURE sp_update_professor(
    IN p_id INT,
    IN p_name VARCHAR(255),
    IN p_email VARCHAR(255)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;
    
    START TRANSACTION;
    
    IF p_id IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El ID del profesor es requerido';
    END IF;
    
    -- Verificar email único
    IF p_email IS NOT NULL AND EXISTS (SELECT 1 FROM PROFESSORS WHERE email = p_email AND id != p_id) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El email ya está registrado';
    END IF;
    
    UPDATE PROFESSORS 
    SET name = COALESCE(p_name, name),
        email = COALESCE(p_email, email)
    WHERE id = p_id;
    
    IF ROW_COUNT() = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Profesor no encontrado';
    END IF;
    
    COMMIT;
END$$

-- =============================================================================
-- 8. PROCEDIMIENTOS DE NOTIFICACIONES
-- =============================================================================


CREATE PROCEDURE sp_get_notifications()
BEGIN
    SELECT * FROM vw_notifications;
END$$
CREATE PROCEDURE sp_get_notification_by_id(IN p_id INT)
BEGIN
    SELECT * FROM vw_notifications WHERE id_notification = p_id;
END$$
CREATE PROCEDURE sp_get_notifications_by_user(IN p_id_user INT)
BEGIN
    SELECT * FROM vw_notifications WHERE id_user = p_id_user;
END$$
CREATE PROCEDURE sp_get_notifications_unread()
BEGIN
    SELECT * FROM vw_notifications WHERE is_read = FALSE;
END$$


CREATE PROCEDURE sp_create_notification(
    IN p_id_user INT,
    IN p_notification_type VARCHAR(50),
    IN p_message TEXT
)
BEGIN
    IF p_id_user IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El ID del usuario es requerido';
    END IF;
    
    IF p_notification_type IS NULL OR TRIM(p_notification_type) = '' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El tipo de notificación es requerido';
    END IF;
    
    IF p_message IS NULL OR TRIM(p_message) = '' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El mensaje es requerido';
    END IF;
    
    -- Verificar que el usuario existe
    IF NOT EXISTS (SELECT 1 FROM USERS WHERE id = p_id_user) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El usuario no existe';
    END IF;
    
    INSERT INTO NOTIFICATIONS (id_user, notification_type, message) 
    VALUES (p_id_user, p_notification_type, p_message);
END$$
CREATE PROCEDURE sp_create_notification_students(
    IN p_notification_type VARCHAR(50),
    IN p_message TEXT
)
BEGIN
    IF p_notification_type IS NULL OR TRIM(p_notification_type) = '' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El tipo de notificación es requerido';
    END IF;
    
    IF p_message IS NULL OR TRIM(p_message) = '' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El mensaje es requerido';
    END IF;
    
    INSERT INTO NOTIFICATIONS (id_user, notification_type, message, is_sent)
    SELECT id, p_notification_type, p_message, 1
    FROM STUDENTS;
END$$
CREATE PROCEDURE sp_create_notification_administrators(
    IN p_notification_type VARCHAR(50),
    IN p_message TEXT
)
BEGIN
    IF p_notification_type IS NULL OR TRIM(p_notification_type) = '' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El tipo de notificación es requerido';
    END IF;
    
    IF p_message IS NULL OR TRIM(p_message) = '' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El mensaje es requerido';
    END IF;
    
    INSERT INTO NOTIFICATIONS (id_user, notification_type, message, is_sent)
    SELECT id, p_notification_type, p_message, 1
    FROM ADMINISTRATORS;
END$$
CREATE PROCEDURE sp_mark_notification_as_read(IN p_id INT)
BEGIN
    IF p_id IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El ID de la notificación es requerido';
    END IF;
    
    UPDATE NOTIFICATIONS 
    SET is_read = TRUE, read_at = NOW() 
    WHERE id = p_id;
    
    IF ROW_COUNT() = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Notificación no encontrada';
    END IF;
END$$
CREATE PROCEDURE sp_mark_notification_as_sent(IN p_id INT)
BEGIN
    IF p_id IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El ID de la notificación es requerido';
    END IF;
    
    UPDATE NOTIFICATIONS 
    SET is_sent = TRUE, sent_at = NOW() 
    WHERE id = p_id;
    
    IF ROW_COUNT() = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Notificación no encontrada';
    END IF;
END$$
CREATE PROCEDURE sp_delete_notification(IN p_id INT)
BEGIN
    IF p_id IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El ID de la notificación es requerido';
    END IF;
    
    DELETE FROM NOTIFICATIONS WHERE id = p_id;
    
    IF ROW_COUNT() = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Notificación no encontrada';
    END IF;
END$$

-- =============================================================================
-- 9. PROCEDIMIENTOS DE TOKENS Y UTILIDADES
-- =============================================================================

CREATE PROCEDURE sp_get_workshop_tokens_active()
BEGIN
    SELECT * FROM vw_workshop_tokens 
    WHERE expiration_at > NOW() AND is_used = FALSE;
END$$
CREATE PROCEDURE sp_get_workshop_tokens_expired()
BEGIN
    SELECT * FROM vw_workshop_tokens 
    WHERE expiration_at <= NOW() OR is_used = TRUE;
END$$
CREATE PROCEDURE sp_create_workshop_token(
    IN p_id_workshop INT,
    IN p_id_professor INT,
    IN p_token VARCHAR(255),
    IN p_expiration_at TIMESTAMP,
    IN p_created_by INT
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;
    
    START TRANSACTION;
    
    IF p_id_workshop IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El ID del taller es requerido';
    END IF;
    
    IF p_id_professor IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El ID del profesor es requerido';
    END IF;
    
    IF p_token IS NULL OR TRIM(p_token) = '' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El token es requerido';
    END IF;
    
    IF p_expiration_at IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La fecha de expiración es requerida';
    END IF;
    
    IF p_created_by IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El ID del creador es requerido';
    END IF;
    
    -- Verificar que el taller existe
    IF NOT EXISTS (SELECT 1 FROM WORKSHOPS WHERE id = p_id_workshop) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El taller no existe';
    END IF;
    
    -- Verificar que el profesor existe
    IF NOT EXISTS (SELECT 1 FROM PROFESSORS WHERE id = p_id_professor) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El profesor no existe';
    END IF;
    
    -- Verificar que el administrador existe
    IF NOT EXISTS (SELECT 1 FROM ADMINISTRATORS WHERE id = p_created_by) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El administrador no existe';
    END IF;
    
    -- Verificar que la fecha de expiración sea futura
    IF p_expiration_at <= NOW() THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La fecha de expiración debe ser futura';
    END IF;
    
    -- Verificar que el token sea único
    IF EXISTS (SELECT 1 FROM WORKSHOPS_TOKENS WHERE token = p_token) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El token ya existe';
    END IF;
    
    INSERT INTO WORKSHOPS_TOKENS (
        id_workshop, id_professor, token, expiration_at, created_by
    ) VALUES (
        p_id_workshop, p_id_professor, p_token, p_expiration_at, p_created_by
    );
    
    COMMIT;
END$$
CREATE PROCEDURE sp_use_workshop_token(IN p_token VARCHAR(255))
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;
    
    START TRANSACTION;
    
    IF p_token IS NULL OR TRIM(p_token) = '' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El token es requerido';
    END IF;
    
    -- Verificar que el token existe y no ha sido usado
    IF NOT EXISTS (SELECT 1 FROM WORKSHOPS_TOKENS WHERE token = p_token AND is_used = FALSE) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Token no válido o ya usado';
    END IF;
    
    -- Verificar que el token no ha expirado
    IF EXISTS (SELECT 1 FROM WORKSHOPS_TOKENS WHERE token = p_token AND expiration_at <= NOW()) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Token expirado';
    END IF;
    
    -- Marcar token como usado
    UPDATE WORKSHOPS_TOKENS 
    SET is_used = TRUE, used_at = NOW() 
    WHERE token = p_token;
    
    COMMIT;
END$$

-- =============================================================================
-- 10. PROCEDIMIENTOS DE ESTADÍSTICAS
-- =============================================================================

SELECT "Procedimientos creados correctamente" AS mensaje;