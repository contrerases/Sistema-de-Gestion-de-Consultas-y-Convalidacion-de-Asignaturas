--------------------------------------------------------------------------------------------------------
---------------------------------- PROCEDIMIENTOS ALMACENADOS ------------------------------------------
--------------------------------------------------------------------------------------------------------

-- =============================================================================
-- RESUMEN DE PROCEDIMIENTOS
-- =============================================================================
-- Total de procedimientos: 21
-- CONVALIDACIONES: 4 (sp_get_convalidations, sp_create_convalidation, sp_drop_convalidation_while_no_reviewed_by_id, sp_review_convalidation)
-- DEPARTMENTS: 4 (sp_get_departments, sp_create_department, sp_update_department, sp_delete_department)
-- STUDENTS: 4 (sp_get_students, sp_create_student, sp_update_student, sp_delete_student)
-- SUBJECTS: 4 (sp_get_subjects, sp_create_subject, sp_update_subject, sp_delete_subject)
-- ADMINISTRATORS: 4 (sp_get_administrators, sp_create_administrator, sp_update_administrator, sp_delete_administrator)
-- CURRICULUM_COURSES: 4 (sp_get_curriculum_courses, sp_create_curriculum_course, sp_update_curriculum_course, sp_delete_curriculum_course)

-- =============================================================================
DROP PROCEDURE IF EXISTS sp_get_convalidations;

DROP PROCEDURE IF EXISTS sp_create_convalidation;

DROP PROCEDURE IF EXISTS sp_drop_convalidation_while_no_reviewed_by_id;

DROP PROCEDURE IF EXISTS sp_review_convalidation;

DROP PROCEDURE IF EXISTS sp_get_departments;
DROP PROCEDURE IF EXISTS sp_create_department;
DROP PROCEDURE IF EXISTS sp_update_department;
DROP PROCEDURE IF EXISTS sp_delete_department;

DROP PROCEDURE IF EXISTS sp_get_students;
DROP PROCEDURE IF EXISTS sp_create_student;
DROP PROCEDURE IF EXISTS sp_update_student;
DROP PROCEDURE IF EXISTS sp_delete_student;

DROP PROCEDURE IF EXISTS sp_get_subjects;
DROP PROCEDURE IF EXISTS sp_create_subject;
DROP PROCEDURE IF EXISTS sp_update_subject;
DROP PROCEDURE IF EXISTS sp_delete_subject;

DROP PROCEDURE IF EXISTS sp_get_administrators;
DROP PROCEDURE IF EXISTS sp_create_administrator;
DROP PROCEDURE IF EXISTS sp_update_administrator;
DROP PROCEDURE IF EXISTS sp_delete_administrator;

DROP PROCEDURE IF EXISTS sp_get_curriculum_courses;
DROP PROCEDURE IF EXISTS sp_create_curriculum_course;
DROP PROCEDURE IF EXISTS sp_update_curriculum_course;
DROP PROCEDURE IF EXISTS sp_delete_curriculum_course;



-- =====================================================================================
-- Procedimiento: sp_get_convalidations
-- Descripción: Obtiene convalidaciones según los filtros proporcionados
-- =====================================================================================
DELIMITER / /

CREATE PROCEDURE sp_get_convalidations(
    IN p_id_request INT,
    IN p_id_convalidation INT,
    IN p_id_convalidation_type INT,
    IN p_id_convalidation_state INT,
    IN p_id_curriculum_course INT,
    IN p_id_student INT,
    IN p_student_rol VARCHAR(255),
    IN p_student_rut VARCHAR(255),
    IN p_student_name VARCHAR(255),
    IN p_id_reviewed_by INT,
    IN p_id_workshop INT,
    IN p_activity_name VARCHAR(255),
    IN p_file_name VARCHAR(255),
    IN p_file_data LONGBLOB,
    IN p_id_subject INT,
    IN p_id_department INT,
    IN p_student_campus VARCHAR(255)
)
BEGIN

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SIGNAL SQLSTATE '45001' SET MESSAGE_TEXT = 'Error al obtener convalidaciones';
    END;

    START TRANSACTION;

    -- Convalidaciones de asignaturas
    SELECT * FROM vw_convalidation_subjects
    WHERE (p_id_convalidation IS NULL OR id_convalidation = p_id_convalidation)
        AND (p_id_subject IS NULL OR id_subject = p_id_subject)
        AND (p_id_department IS NULL OR department = (SELECT name FROM DEPARTMENTS WHERE id = p_id_department))
        AND (p_id_request IS NULL OR id_request = p_id_request)
        AND (p_id_convalidation_type IS NULL OR id_convalidation_type = p_id_convalidation_type)
        AND (p_id_convalidation_state IS NULL OR id_convalidation_state = p_id_convalidation_state)
        AND (p_id_curriculum_course IS NULL OR id_curriculum_course = p_id_curriculum_course)
        AND (p_id_student IS NULL OR id_student = p_id_student)
        AND (p_id_reviewed_by IS NULL OR id_reviewed_by = p_id_reviewed_by)
        AND (p_student_rol IS NULL OR student_rol = p_student_rol)
        AND (p_student_rut IS NULL OR student_rut = p_student_rut)
        AND (p_student_name IS NULL OR student_name = p_student_name)
        AND (p_id_reviewed_by IS NULL OR id_reviewed_by = p_id_reviewed_by)
        AND (p_student_campus IS NULL OR student_campus = p_student_campus);

    -- Convalidaciones de talleres
    SELECT * FROM vw_convalidation_workshops
    WHERE (p_id_convalidation IS NULL OR id_convalidation = p_id_convalidation)
        AND (p_id_workshop IS NULL OR id_workshop = p_id_workshop)
        AND (p_id_request IS NULL OR id_request = p_id_request)
        AND (p_id_convalidation_type IS NULL OR id_convalidation_type = p_id_convalidation_type)
        AND (p_id_convalidation_state IS NULL OR id_convalidation_state = p_id_convalidation_state)
        AND (p_id_curriculum_course IS NULL OR id_curriculum_course = p_id_curriculum_course)
        AND (p_id_student IS NULL OR id_student = p_id_student)
        AND (p_id_reviewed_by IS NULL OR id_reviewed_by = p_id_reviewed_by)
        AND (p_student_rol IS NULL OR student_rol = p_student_rol)
        AND (p_student_rut IS NULL OR student_rut = p_student_rut)
        AND (p_student_name IS NULL OR student_name = p_student_name)
        AND (p_id_reviewed_by IS NULL OR id_reviewed_by = p_id_reviewed_by)
        AND (p_student_campus IS NULL OR student_campus = p_student_campus);

    -- Convalidaciones de actividades externas
    SELECT * FROM vw_convalidation_external_activities
    WHERE (p_id_convalidation IS NULL OR id_convalidation = p_id_convalidation)
        AND (p_id_request IS NULL OR id_request = p_id_request)
        AND (p_id_convalidation_type IS NULL OR id_convalidation_type = p_id_convalidation_type)
        AND (p_id_convalidation_state IS NULL OR id_convalidation_state = p_id_convalidation_state)
        AND (p_id_curriculum_course IS NULL OR id_curriculum_course = p_id_curriculum_course)
        AND (p_id_student IS NULL OR id_student = p_id_student)
        AND (p_id_reviewed_by IS NULL OR id_reviewed_by = p_id_reviewed_by)
        AND (p_student_rol IS NULL OR student_rol = p_student_rol)
        AND (p_student_rut IS NULL OR student_rut = p_student_rut)
        AND (p_student_name IS NULL OR student_name = p_student_name)
        AND (p_id_reviewed_by IS NULL OR id_reviewed_by = p_id_reviewed_by)
        AND (p_student_campus IS NULL OR student_campus = p_student_campus);

END//

DELIMITER;

-- =====================================================================================
-- Procedimiento: sp_create_convalidation
-- Descripción: Crea una solicitud y convalidación con sus detalles asociados
-- =====================================================================================
DELIMITER / /

CREATE PROCEDURE sp_create_convalidation(
    IN p_id_student INT,
    IN p_id_convalidation_type INT,
    IN p_id_curriculum_course INT,
    IN p_id_workshop INT,
    IN p_activity_name VARCHAR(255),
    IN p_file_name VARCHAR(255),
    IN p_file_data LONGBLOB,
    IN p_id_subject INT,
    IN p_id_department INT
)
BEGIN
    DECLARE v_id_request INT;
    DECLARE v_id_convalidation INT;
    DECLARE v_id_convalidation_state INT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SIGNAL SQLSTATE '45001' SET MESSAGE_TEXT = 'Error al crear convalidación';
    END;

    START TRANSACTION;

    -- Crear solicitud
    INSERT INTO REQUESTS (sent_at, id_student) VALUES (CURRENT_TIMESTAMP, p_id_student);
    SET v_id_request = LAST_INSERT_ID();

    -- Obtener estado ENVIADA
    SELECT id INTO v_id_convalidation_state FROM CONVALIDATION_STATES WHERE name = 'ENVIADA';

    -- Crear convalidación
    INSERT INTO CONVALIDATIONS (id_request, id_convalidation_type, id_convalidation_state, id_curriculum_course)
    VALUES (v_id_request, p_id_convalidation_type, v_id_convalidation_state, p_id_curriculum_course);
    SET v_id_convalidation = LAST_INSERT_ID();

    -- Crear detalles según tipo
    IF p_id_workshop IS NOT NULL THEN
        INSERT INTO CONVALIDATIONS_WORKSHOPS (id_convalidation, id_workshop) VALUES (v_id_convalidation, p_id_workshop);
    END IF;

    IF p_activity_name IS NOT NULL THEN
        INSERT INTO CONVALIDATIONS_EXTERNAL_ACTIVITIES (id_convalidation, activity_name, file_name, file_data)
        VALUES (v_id_convalidation, p_activity_name, p_file_name, p_file_data);
    END IF;

    IF p_id_subject IS NOT NULL THEN
        INSERT INTO CONVALIDATIONS_SUBJECTS (id_convalidation, id_subject) VALUES (v_id_convalidation, p_id_subject);
    END IF;

    COMMIT;

    SELECT 'Convalidación creada exitosamente' AS mensaje;
END//

DELIMITER;

-- =====================================================================================
-- Procedimiento: sp_drop_convalidation_while_no_reviewed_by_id
-- Descripción: Elimina convalidación si está en estado ENVIADA
-- =====================================================================================
DELIMITER / /

CREATE PROCEDURE sp_drop_convalidation_while_no_reviewed_by_id(IN p_id_convalidation INT)
BEGIN
    DECLARE v_convalidation_state INT;
    DECLARE v_enviada_state_id INT;
    DECLARE v_id_request INT;
    DECLARE v_remaining_convalidations INT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SIGNAL SQLSTATE '45001' SET MESSAGE_TEXT = 'Error al eliminar convalidación';
    END;


    SELECT id INTO v_enviada_state_id FROM CONVALIDATION_STATES WHERE name = 'ENVIADA';


    SELECT id_convalidation_state, id_request INTO v_convalidation_state, v_id_request
    FROM CONVALIDATIONS WHERE id = p_id_convalidation;


    START TRANSACTION;
    DELETE FROM CONVALIDATIONS WHERE id = p_id_convalidation;


    SELECT COUNT(*) INTO v_remaining_convalidations FROM CONVALIDATIONS WHERE id_request = v_id_request;
    IF v_remaining_convalidations = 0 THEN
        DELETE FROM REQUESTS WHERE id = v_id_request;
    END IF;

    COMMIT;

    SELECT 'Convalidación eliminada exitosamente' AS mensaje;
END//

DELIMITER;

-- =====================================================================================
-- Procedimiento: sp_review_convalidation
-- Descripción: Revisa una convalidación
-- =====================================================================================
DELIMITER / /

CREATE PROCEDURE sp_review_convalidation(
    IN p_id_convalidation INT,
    IN p_id_reviewed_by INT,
    IN p_review_comments VARCHAR(255),
    IN p_id_new_convalidation_state INT
)
BEGIN
    DECLARE v_id_request INT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SIGNAL SQLSTATE '45001' SET MESSAGE_TEXT = 'Error al revisar convalidación';
    END;

    SELECT id_request INTO v_id_request FROM CONVALIDATIONS WHERE id = p_id_convalidation;

    START TRANSACTION;

    UPDATE CONVALIDATIONS
    SET id_convalidation_state = p_id_new_convalidation_state,
        review_comments = p_review_comments
    WHERE id = p_id_convalidation;

    UPDATE REQUESTS
    SET id_reviewed_by = p_id_reviewed_by,
        reviewed_at = CURRENT_TIMESTAMP
    WHERE id = v_id_request;

    COMMIT;

    SELECT 'Convalidación revisada exitosamente' AS mensaje;
END//


-- ====================================================================================
-- CRUD
-- ====================================================================================


-- =============================================================================
-- PROCEDIMIENTOS CRUD - TABLAS MAESTRAS
-- =============================================================================

-- =====================================================================================
-- DEPARTMENTS CRUD
-- =====================================================================================

DROP PROCEDURE IF EXISTS sp_get_departments;
DROP PROCEDURE IF EXISTS sp_create_department;
DROP PROCEDURE IF EXISTS sp_update_department;
DROP PROCEDURE IF EXISTS sp_delete_department;

DELIMITER //

CREATE PROCEDURE sp_get_departments(IN p_department_id INT)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SIGNAL SQLSTATE '45001' SET MESSAGE_TEXT = 'Error al obtener departamentos';
    END;

    START TRANSACTION;
    IF p_department_id IS NULL THEN
        SELECT * FROM DEPARTMENTS;
    ELSE
        SELECT * FROM DEPARTMENTS WHERE id = p_department_id;
    END IF;
    COMMIT;
END//

CREATE PROCEDURE sp_create_department(IN p_name VARCHAR(255))
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SIGNAL SQLSTATE '45001' SET MESSAGE_TEXT = 'Error al crear departamento';
    END;

    START TRANSACTION;
    INSERT INTO DEPARTMENTS (name) VALUES (p_name);
    COMMIT;
    SELECT 'Departamento creado exitosamente' AS mensaje;
END//

CREATE PROCEDURE sp_update_department(IN p_department_id INT, IN p_name VARCHAR(255))
BEGIN
    DECLARE v_exists INT DEFAULT 0;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SIGNAL SQLSTATE '45001' SET MESSAGE_TEXT = 'Error al actualizar departamento';
    END;

    START TRANSACTION;

    -- Verificar que el departamento existe
    SELECT COUNT(*) INTO v_exists FROM DEPARTMENTS WHERE id = p_department_id;
    IF v_exists = 0 THEN
        SIGNAL SQLSTATE '45002' SET MESSAGE_TEXT = 'El departamento no existe';
    END IF;

    UPDATE DEPARTMENTS SET name = p_name WHERE id = p_department_id;
    COMMIT;
    SELECT 'Departamento actualizado exitosamente' AS mensaje;
END//

CREATE PROCEDURE sp_delete_department(IN p_department_id INT)
BEGIN
    DECLARE v_exists INT DEFAULT 0;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SIGNAL SQLSTATE '45001' SET MESSAGE_TEXT = 'Error al eliminar departamento';
    END;

    START TRANSACTION;

    -- Verificar que el departamento existe
    SELECT COUNT(*) INTO v_exists FROM DEPARTMENTS WHERE id = p_department_id;
    IF v_exists = 0 THEN
        SIGNAL SQLSTATE '45002' SET MESSAGE_TEXT = 'El departamento no existe';
    END IF;

    DELETE FROM DEPARTMENTS WHERE id = p_department_id;
    COMMIT;
    SELECT 'Departamento eliminado exitosamente' AS mensaje;
END//

-- =====================================================================================
-- STUDENTS CRUD
-- =====================================================================================

DROP PROCEDURE IF EXISTS sp_get_students;
DROP PROCEDURE IF EXISTS sp_create_student;
DROP PROCEDURE IF EXISTS sp_update_student;
DROP PROCEDURE IF EXISTS sp_delete_student;

CREATE PROCEDURE sp_get_students(IN p_student_id INT)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SIGNAL SQLSTATE '45001' SET MESSAGE_TEXT = 'Error al obtener estudiantes';
    END;

    START TRANSACTION;
    IF p_student_id IS NULL THEN
        SELECT * FROM vw_students;
    ELSE
        SELECT * FROM vw_students WHERE id_student = p_student_id;
    END IF;
    COMMIT;
END//

CREATE PROCEDURE sp_create_student(
    IN p_first_names VARCHAR(255),
    IN p_last_names VARCHAR(255),
    IN p_campus VARCHAR(255),
    IN p_rol_student VARCHAR(11),
    IN p_rut_student VARCHAR(12),
    IN p_campus_student VARCHAR(255),
    IN p_email VARCHAR(255),
    IN p_password_hash VARCHAR(255)
)
BEGIN
    DECLARE v_auth_user_id INT;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SIGNAL SQLSTATE '45001' SET MESSAGE_TEXT = 'Error al crear estudiante';
    END;

    START TRANSACTION;

    -- 1. Crear cuenta de autenticación en AUTH_USERS (tabla principal)
    INSERT INTO AUTH_USERS (email, password_hash) VALUES (p_email, p_password_hash);
    SET v_auth_user_id = LAST_INSERT_ID();

    -- 2. Crear usuario en USERS (tabla hija)
    INSERT INTO USERS (id, first_names, last_names, campus) VALUES (v_auth_user_id, p_first_names, p_last_names, p_campus);

    -- 3. Crear estudiante en STUDENTS (tabla hija)
    INSERT INTO STUDENTS (id, rol_student, rut_student, campus_student) VALUES (v_auth_user_id, p_rol_student, p_rut_student, p_campus_student);

    COMMIT;
    SELECT 'Estudiante creado exitosamente' AS mensaje;
END//

CREATE PROCEDURE sp_update_student(
    IN p_student_id INT,
    IN p_first_names VARCHAR(255),
    IN p_last_names VARCHAR(255),
    IN p_campus VARCHAR(255),
    IN p_rol_student VARCHAR(11),
    IN p_rut_student VARCHAR(12),
    IN p_campus_student VARCHAR(255),
    IN p_email VARCHAR(255),
    IN p_password_hash VARCHAR(255)
)
BEGIN
    DECLARE v_exists INT DEFAULT 0;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SIGNAL SQLSTATE '45001' SET MESSAGE_TEXT = 'Error al actualizar estudiante';
    END;

    START TRANSACTION;

    -- Verificar que el estudiante existe
    SELECT COUNT(*) INTO v_exists FROM STUDENTS WHERE id = p_student_id;
    IF v_exists = 0 THEN
        SIGNAL SQLSTATE '45002' SET MESSAGE_TEXT = 'El estudiante no existe';
    END IF;

    -- Actualizar en orden: principal -> hija -> hija específica
    UPDATE AUTH_USERS SET email = p_email, password_hash = p_password_hash WHERE id = p_student_id;
    UPDATE USERS SET first_names = p_first_names, last_names = p_last_names, campus = p_campus WHERE id = p_student_id;
    UPDATE STUDENTS SET rol_student = p_rol_student, rut_student = p_rut_student, campus_student = p_campus_student WHERE id = p_student_id;
    COMMIT;
    SELECT 'Estudiante actualizado exitosamente' AS mensaje;
END//

CREATE PROCEDURE sp_delete_student(IN p_student_id INT)
BEGIN
    DECLARE v_exists INT DEFAULT 0;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SIGNAL SQLSTATE '45001' SET MESSAGE_TEXT = 'Error al eliminar estudiante';
    END;

    START TRANSACTION;

    -- Verificar que el estudiante existe
    SELECT COUNT(*) INTO v_exists FROM STUDENTS WHERE id = p_student_id;
    IF v_exists = 0 THEN
        SIGNAL SQLSTATE '45002' SET MESSAGE_TEXT = 'El estudiante no existe';
    END IF;

    -- Solo eliminar de AUTH_USERS (tabla principal) - CASCADE eliminará automáticamente USERS y STUDENTS
    DELETE FROM AUTH_USERS WHERE id = p_student_id;
    COMMIT;
    SELECT 'Estudiante eliminado exitosamente' AS mensaje;
END//

-- =====================================================================================
-- SUBJECTS CRUD
-- =====================================================================================

DROP PROCEDURE IF EXISTS sp_get_subjects;
DROP PROCEDURE IF EXISTS sp_create_subject;
DROP PROCEDURE IF EXISTS sp_update_subject;
DROP PROCEDURE IF EXISTS sp_delete_subject;

CREATE PROCEDURE sp_get_subjects(IN p_subject_id INT)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SIGNAL SQLSTATE '45001' SET MESSAGE_TEXT = 'Error al obtener asignaturas';
    END;

    START TRANSACTION;
    IF p_subject_id IS NULL THEN
        SELECT * FROM vw_subjects;
    ELSE
        SELECT * FROM vw_subjects WHERE id_subject = p_subject_id;
    END IF;
    COMMIT;
END//

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
        SIGNAL SQLSTATE '45001' SET MESSAGE_TEXT = 'Error al crear asignatura';
    END;

    START TRANSACTION;
    INSERT INTO SUBJECTS (acronym, name, id_department, credits) VALUES (p_acronym, p_name, p_id_department, p_credits);
    COMMIT;
    SELECT 'Asignatura creada exitosamente' AS mensaje;
END//

CREATE PROCEDURE sp_update_subject(
    IN p_subject_id INT,
    IN p_acronym VARCHAR(255),
    IN p_name VARCHAR(255),
    IN p_id_department INT,
    IN p_credits INT
)
BEGIN
    DECLARE v_exists INT DEFAULT 0;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SIGNAL SQLSTATE '45001' SET MESSAGE_TEXT = 'Error al actualizar asignatura';
    END;

    START TRANSACTION;

    -- Verificar que la asignatura existe
    SELECT COUNT(*) INTO v_exists FROM SUBJECTS WHERE id = p_subject_id;
    IF v_exists = 0 THEN
        SIGNAL SQLSTATE '45002' SET MESSAGE_TEXT = 'La asignatura no existe';
    END IF;

    UPDATE SUBJECTS SET acronym = p_acronym, name = p_name, id_department = p_id_department, credits = p_credits WHERE id = p_subject_id;
    COMMIT;
    SELECT 'Asignatura actualizada exitosamente' AS mensaje;
END//

CREATE PROCEDURE sp_delete_subject(IN p_subject_id INT)
BEGIN
    DECLARE v_exists INT DEFAULT 0;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SIGNAL SQLSTATE '45001' SET MESSAGE_TEXT = 'Error al eliminar asignatura';
    END;

    START TRANSACTION;

    -- Verificar que la asignatura existe
    SELECT COUNT(*) INTO v_exists FROM SUBJECTS WHERE id = p_subject_id;
    IF v_exists = 0 THEN
        SIGNAL SQLSTATE '45002' SET MESSAGE_TEXT = 'La asignatura no existe';
    END IF;

    DELETE FROM SUBJECTS WHERE id = p_subject_id;
    COMMIT;
    SELECT 'Asignatura eliminada exitosamente' AS mensaje;
END//

-- =====================================================================================
-- ADMINISTRATORS CRUD
-- =====================================================================================

DROP PROCEDURE IF EXISTS sp_get_administrators;
DROP PROCEDURE IF EXISTS sp_create_administrator;
DROP PROCEDURE IF EXISTS sp_update_administrator;
DROP PROCEDURE IF EXISTS sp_delete_administrator;

CREATE PROCEDURE sp_get_administrators(IN p_administrator_id INT)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SIGNAL SQLSTATE '45001' SET MESSAGE_TEXT = 'Error al obtener administradores';
    END;

    START TRANSACTION;
    IF p_administrator_id IS NULL THEN
        SELECT * FROM vw_admins;
    ELSE
        SELECT * FROM vw_admins WHERE id_admin = p_administrator_id;
    END IF;
    COMMIT;
END//

CREATE PROCEDURE sp_create_administrator(
    IN p_first_names VARCHAR(255),
    IN p_last_names VARCHAR(255),
    IN p_campus VARCHAR(255),
    IN p_email VARCHAR(255),
    IN p_password_hash VARCHAR(255)
)
BEGIN
    DECLARE v_auth_user_id INT;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SIGNAL SQLSTATE '45001' SET MESSAGE_TEXT = 'Error al crear administrador';
    END;

    START TRANSACTION;
    -- 1. Crear cuenta de autenticación en AUTH_USERS (tabla principal)
    INSERT INTO AUTH_USERS (email, password_hash) VALUES (p_email, p_password_hash);
    SET v_auth_user_id = LAST_INSERT_ID();

    -- 2. Crear usuario en USERS (tabla hija)
    INSERT INTO USERS (id, first_names, last_names, campus) VALUES (v_auth_user_id, p_first_names, p_last_names, p_campus);

    -- 3. Crear administrador en ADMINISTRATORS (tabla hija)
    INSERT INTO ADMINISTRATORS (id) VALUES (v_auth_user_id);
    COMMIT;
    SELECT 'Administrador creado exitosamente' AS mensaje;
END//

CREATE PROCEDURE sp_update_administrator(
    IN p_administrator_id INT,
    IN p_first_names VARCHAR(255),
    IN p_last_names VARCHAR(255),
    IN p_campus VARCHAR(255),
    IN p_email VARCHAR(255),
    IN p_password_hash VARCHAR(255)
)
BEGIN
    DECLARE v_exists INT DEFAULT 0;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SIGNAL SQLSTATE '45001' SET MESSAGE_TEXT = 'Error al actualizar administrador';
    END;

    START TRANSACTION;

    -- Verificar que el administrador existe
    SELECT COUNT(*) INTO v_exists FROM ADMINISTRATORS WHERE id = p_administrator_id;
    IF v_exists = 0 THEN
        SIGNAL SQLSTATE '45002' SET MESSAGE_TEXT = 'El administrador no existe';
    END IF;

    -- Actualizar en orden: principal -> hija
    UPDATE AUTH_USERS SET email = p_email, password_hash = p_password_hash WHERE id = p_administrator_id;
    UPDATE USERS SET first_names = p_first_names, last_names = p_last_names, campus = p_campus WHERE id = p_administrator_id;
    COMMIT;
    SELECT 'Administrador actualizado exitosamente' AS mensaje;
END//

CREATE PROCEDURE sp_delete_administrator(IN p_administrator_id INT)
BEGIN
    DECLARE v_exists INT DEFAULT 0;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SIGNAL SQLSTATE '45001' SET MESSAGE_TEXT = 'Error al eliminar administrador';
    END;

    START TRANSACTION;

    -- Verificar que el administrador existe
    SELECT COUNT(*) INTO v_exists FROM ADMINISTRATORS WHERE id = p_administrator_id;
    IF v_exists = 0 THEN
        SIGNAL SQLSTATE '45002' SET MESSAGE_TEXT = 'El administrador no existe';
    END IF;

    -- Solo eliminar de AUTH_USERS (tabla principal) - CASCADE eliminará automáticamente USERS y ADMINISTRATORS
    DELETE FROM AUTH_USERS WHERE id = p_administrator_id;
    COMMIT;
    SELECT 'Administrador eliminado exitosamente' AS mensaje;
END//

-- =====================================================================================
-- CURRICULUM_COURSES CRUD
-- =====================================================================================

DROP PROCEDURE IF EXISTS sp_get_curriculum_courses;
DROP PROCEDURE IF EXISTS sp_create_curriculum_course;
DROP PROCEDURE IF EXISTS sp_update_curriculum_course;
DROP PROCEDURE IF EXISTS sp_delete_curriculum_course;


CREATE PROCEDURE sp_get_curriculum_courses(IN p_curriculum_course_id INT)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SIGNAL SQLSTATE '45001' SET MESSAGE_TEXT = 'Error al obtener cursos curriculares';
    END;

    START TRANSACTION;
    IF p_curriculum_course_id IS NULL THEN
        SELECT * FROM vw_curriculum_courses;
    ELSE
        SELECT * FROM vw_curriculum_courses WHERE id_curriculum_course = p_curriculum_course_id;
    END IF;
    COMMIT;
END//

CREATE PROCEDURE sp_create_curriculum_course(
    IN p_name VARCHAR(255),
    IN p_id_curriculum_course_type INT
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SIGNAL SQLSTATE '45001' SET MESSAGE_TEXT = 'Error al crear curso curricular';
    END;

    START TRANSACTION;
    INSERT INTO CURRICULUM_COURSES (name, id_curriculum_course_type) VALUES (p_name, p_id_curriculum_course_type);
    COMMIT;
    SELECT 'Curso curricular creado exitosamente' AS mensaje;
END//

CREATE PROCEDURE sp_update_curriculum_course(
    IN p_curriculum_course_id INT,
    IN p_name VARCHAR(255),
    IN p_id_curriculum_course_type INT
)
BEGIN
    DECLARE v_exists INT DEFAULT 0;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SIGNAL SQLSTATE '45001' SET MESSAGE_TEXT = 'Error al actualizar curso curricular';
    END;

    START TRANSACTION;

    -- Verificar que el curso curricular existe
    SELECT COUNT(*) INTO v_exists FROM CURRICULUM_COURSES WHERE id = p_curriculum_course_id;
    IF v_exists = 0 THEN
        SIGNAL SQLSTATE '45002' SET MESSAGE_TEXT = 'El curso curricular no existe';
    END IF;

    UPDATE CURRICULUM_COURSES SET name = p_name, id_curriculum_course_type = p_id_curriculum_course_type WHERE id = p_curriculum_course_id;
    COMMIT;
    SELECT 'Curso curricular actualizado exitosamente' AS mensaje;
END//

CREATE PROCEDURE sp_delete_curriculum_course(IN p_curriculum_course_id INT)
BEGIN
    DECLARE v_exists INT DEFAULT 0;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SIGNAL SQLSTATE '45001' SET MESSAGE_TEXT = 'Error al eliminar curso curricular';
    END;

    START TRANSACTION;

    -- Verificar que el curso curricular existe
    SELECT COUNT(*) INTO v_exists FROM CURRICULUM_COURSES WHERE id = p_curriculum_course_id;
    IF v_exists = 0 THEN
        SIGNAL SQLSTATE '45002' SET MESSAGE_TEXT = 'El curso curricular no existe';
    END IF;

    DELETE FROM CURRICULUM_COURSES WHERE id = p_curriculum_course_id;
    COMMIT;
    SELECT 'Curso curricular eliminado exitosamente' AS mensaje;
END//
