-- =============================================================================
-- PROCEDIMIENTOS ALMACENADOS
-- =============================================================================

-- =============================================================================
-- 1. GENERALES
-- =============================================================================

-- DEPARTMENTS
DROP PROCEDURE IF EXISTS sp_get_departments;
DROP PROCEDURE IF EXISTS sp_create_department;
DROP PROCEDURE IF EXISTS sp_update_department;
DROP PROCEDURE IF EXISTS sp_delete_department;

-- SUBJECTS
DROP PROCEDURE IF EXISTS sp_get_subjects;
DROP PROCEDURE IF EXISTS sp_create_subject;
DROP PROCEDURE IF EXISTS sp_update_subject;
DROP PROCEDURE IF EXISTS sp_delete_subject;

-- CURRICULUM_COURSES
DROP PROCEDURE IF EXISTS sp_get_curriculum_courses;
DROP PROCEDURE IF EXISTS sp_create_curriculum_course;
DROP PROCEDURE IF EXISTS sp_update_curriculum_course;
DROP PROCEDURE IF EXISTS sp_delete_curriculum_course;

DELIMITER //

-- DEPARTMENTS
CREATE PROCEDURE sp_get_departments(IN p_department_id INT)
BEGIN
    SELECT * FROM DEPARTMENTS WHERE (p_department_id IS NULL OR id = p_department_id);
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

-- SUBJECTS
CREATE PROCEDURE sp_get_subjects(IN p_subject_id INT)
BEGIN
    SELECT * FROM vw_subjects WHERE (p_subject_id IS NULL OR id_subject = p_subject_id);
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

-- CURRICULUM_COURSES
CREATE PROCEDURE sp_get_curriculum_courses(IN p_curriculum_course_id INT)
BEGIN
    SELECT * FROM vw_curriculum_courses WHERE (p_curriculum_course_id IS NULL OR id_curriculum_course = p_curriculum_course_id);
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

-- =============================================================================
-- 2. CONVALIDACIONES
-- =============================================================================

DROP PROCEDURE IF EXISTS sp_get_convalidations;
DROP PROCEDURE IF EXISTS sp_create_convalidation;
DROP PROCEDURE IF EXISTS sp_drop_convalidation_while_no_reviewed_by_id;
DROP PROCEDURE IF EXISTS sp_review_convalidation;

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
        AND (p_student_campus IS NULL OR student_campus = p_student_campus);

    -- Convalidaciones de actividades externas
    SELECT * FROM vw_convalidation_external_activities
    WHERE (p_id_convalidation IS NULL OR id_convalidation = p_id_convalidation)
        AND (p_activity_name IS NULL OR activity_name LIKE CONCAT('%', p_activity_name, '%'))
        AND (p_file_name IS NULL OR file_name LIKE CONCAT('%', p_file_name, '%'))
        AND (p_id_request IS NULL OR id_request = p_id_request)
        AND (p_id_convalidation_type IS NULL OR id_convalidation_type = p_id_convalidation_type)
        AND (p_id_convalidation_state IS NULL OR id_convalidation_state = p_id_convalidation_state)
        AND (p_id_curriculum_course IS NULL OR id_curriculum_course = p_id_curriculum_course)
        AND (p_id_student IS NULL OR id_student = p_id_student)
        AND (p_id_reviewed_by IS NULL OR id_reviewed_by = p_id_reviewed_by)
        AND (p_student_rol IS NULL OR student_rol = p_student_rol)
        AND (p_student_rut IS NULL OR student_rut = p_student_rut)
        AND (p_student_name IS NULL OR student_name = p_student_name)
        AND (p_student_campus IS NULL OR student_campus = p_student_campus);

    COMMIT;
END//

CREATE PROCEDURE sp_create_convalidation(
    IN p_id_student INT,
    IN p_id_convalidation_type INT,
    IN p_id_curriculum_course INT,
    IN p_id_workshop INT,
    IN p_activity_name VARCHAR(255),
    IN p_description VARCHAR(255),
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
        INSERT INTO CONVALIDATIONS_EXTERNAL_ACTIVITIES (id_convalidation, activity_name, description, file_name, file_data)
        VALUES (v_id_convalidation, p_activity_name, p_description, p_file_name, p_file_data);
    END IF;

    IF p_id_subject IS NOT NULL THEN
        INSERT INTO CONVALIDATIONS_SUBJECTS (id_convalidation, id_subject) VALUES (v_id_convalidation, p_id_subject);
    END IF;

    COMMIT;
    SELECT 'Convalidación creada exitosamente' AS mensaje;
END//

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

CREATE PROCEDURE sp_review_convalidation(
    IN p_id_convalidation INT,
    IN p_id_convalidation_state INT,
    IN p_review_comments TEXT(1000),
    IN p_id_reviewed_by INT
)
BEGIN
    DECLARE v_id_request INT;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SIGNAL SQLSTATE '45001' SET MESSAGE_TEXT = 'Error al revisar convalidación';
    END;

    START TRANSACTION;

    -- Obtener id_request de la convalidación
    SELECT id_request INTO v_id_request FROM CONVALIDATIONS WHERE id = p_id_convalidation;

    -- Actualizar convalidación
    UPDATE CONVALIDATIONS SET
        id_convalidation_state = p_id_convalidation_state,
        review_comments = p_review_comments
    WHERE id = p_id_convalidation;

    -- Actualizar solicitud
    UPDATE REQUESTS SET
        id_reviewed_by = p_id_reviewed_by,
        reviewed_at = CURRENT_TIMESTAMP
    WHERE id = v_id_request;

    COMMIT;
    SELECT 'Convalidación revisada exitosamente' AS mensaje;
END//

-- =============================================================================
-- 3. TALLERES
-- =============================================================================

DROP PROCEDURE IF EXISTS sp_get_workshops;
DROP PROCEDURE IF EXISTS sp_update_workshop;
DROP PROCEDURE IF EXISTS sp_delete_workshop;
DROP PROCEDURE IF EXISTS sp_create_workshop;
DROP PROCEDURE IF EXISTS sp_get_workshops_inscriptions;
DROP PROCEDURE IF EXISTS sp_unregister_workshop_after_start;
DROP PROCEDURE IF EXISTS sp_get_workshop_grades;

CREATE PROCEDURE sp_get_workshops(
    IN p_semester ENUM('1', '2'),
    IN p_year INT,
    IN p_available TINYINT(1),
    IN p_workshop_state_id INT
)
BEGIN
    SELECT * , (SELECT COUNT(*) FROM WORKSHOPS_INSCRIPTIONS
    WHERE WORKSHOPS_INSCRIPTIONS.id_workshop = vw_workshops.id_workshop) AS inscriptions_count
    FROM vw_workshops
    WHERE (p_semester IS NULL OR vw_workshops.semester = p_semester)
        AND (p_year IS NULL OR vw_workshops.year = p_year)
        AND (p_available IS NULL OR vw_workshops.available = p_available)
        AND (p_workshop_state_id IS NULL OR vw_workshops.id_workshop_state = p_workshop_state_id)
    ORDER BY vw_workshops.year DESC, vw_workshops.semester DESC, vw_workshops.workshop;
END//

CREATE PROCEDURE sp_get_workshops_inscriptions(
    IN p_workshop_id INT,
    IN p_student_id INT,
    IN p_is_convalidated TINYINT(1),
    IN p_curriculum_course_id INT
)
BEGIN
    SELECT
        WORKSHOPS_INSCRIPTIONS.id AS id_inscription,
        vw_workshops_inscriptions.*
    FROM vw_workshops_inscriptions
    JOIN WORKSHOPS_INSCRIPTIONS ON vw_workshops_inscriptions.id_student = WORKSHOPS_INSCRIPTIONS.id_student
        AND vw_workshops_inscriptions.id_workshop = WORKSHOPS_INSCRIPTIONS.id_workshop
    WHERE (p_workshop_id IS NULL OR vw_workshops_inscriptions.id_workshop = p_workshop_id)
        AND (p_student_id IS NULL OR vw_workshops_inscriptions.id_student = p_student_id)
        AND (p_is_convalidated IS NULL OR vw_workshops_inscriptions.is_convalidated = p_is_convalidated)
        AND (p_curriculum_course_id IS NULL OR vw_workshops_inscriptions.id_curriculum_course = p_curriculum_course_id)
    ORDER BY vw_workshops_inscriptions.year DESC, vw_workshops_inscriptions.semester DESC, vw_workshops_inscriptions.workshop, vw_workshops_inscriptions.name_student;
END//

DROP PROCEDURE IF EXISTS sp_create_workshop;
CREATE PROCEDURE sp_create_workshop(
    IN p_name VARCHAR(255),
    IN p_semester ENUM('1', '2'),
    IN p_year INT,
    IN p_professor VARCHAR(255),
    IN p_description TEXT(1000),
    IN p_inscription_start_date TIMESTAMP,
    IN p_inscription_end_date TIMESTAMP,
    IN p_course_start_date TIMESTAMP,
    IN p_course_end_date TIMESTAMP,
    IN p_available TINYINT(1),
    IN p_limit_inscriptions INT,
    IN p_id_workshop_state INT
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SIGNAL SQLSTATE '45001' SET MESSAGE_TEXT = 'Error al crear taller';
    END;

    START TRANSACTION;
    INSERT INTO WORKSHOPS (
        name, semester, year, professor, description,
        inscription_start_date, inscription_end_date,
        course_start_date, course_end_date,
        available, limit_inscriptions, id_workshop_state
    ) VALUES (
        p_name, p_semester, p_year, p_professor, p_description,
        p_inscription_start_date, p_inscription_end_date,
        p_course_start_date, p_course_end_date,
        p_available, p_limit_inscriptions, p_id_workshop_state
    );
    COMMIT;
    SELECT 'Taller creado exitosamente' AS mensaje;
END//

CREATE PROCEDURE sp_update_workshop(
    IN p_workshop_id INT,
    IN p_name VARCHAR(255),
    IN p_semester ENUM('1', '2'),
    IN p_year INT,
    IN p_professor VARCHAR(255),
    IN p_description TEXT(1000),
    IN p_inscription_start_date TIMESTAMP,
    IN p_inscription_end_date TIMESTAMP,
    IN p_course_start_date TIMESTAMP,
    IN p_course_end_date TIMESTAMP,
    IN p_available TINYINT(1),
    IN p_limit_inscriptions INT,
    IN p_workshop_state_id INT
)
BEGIN
    DECLARE v_exists INT DEFAULT 0;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SIGNAL SQLSTATE '45001' SET MESSAGE_TEXT = 'Error al actualizar taller';
    END;

    START TRANSACTION;

    -- Verificar que el taller existe
    SELECT COUNT(*) INTO v_exists FROM WORKSHOPS WHERE id = p_workshop_id;
    IF v_exists = 0 THEN
        SIGNAL SQLSTATE '45002' SET MESSAGE_TEXT = 'El taller no existe';
    END IF;

    UPDATE WORKSHOPS SET
        name = p_name,
        semester = p_semester,
        year = p_year,
        professor = p_professor,
        description = p_description,
        inscription_start_date = p_inscription_start_date,
        inscription_end_date = p_inscription_end_date,
        course_start_date = p_course_start_date,
        course_end_date = p_course_end_date,
        available = p_available,
        limit_inscriptions = p_limit_inscriptions,
        id_workshop_state = p_workshop_state_id
    WHERE id = p_workshop_id;

    COMMIT;
    SELECT 'Taller actualizado exitosamente' AS mensaje;
END//

CREATE PROCEDURE sp_delete_workshop(IN p_workshop_id INT)
BEGIN
    DECLARE v_exists INT DEFAULT 0;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SIGNAL SQLSTATE '45001' SET MESSAGE_TEXT = 'Error al eliminar taller';
    END;

    START TRANSACTION;

    -- Verificar que el taller existe
    SELECT COUNT(*) INTO v_exists FROM WORKSHOPS WHERE id = p_workshop_id;
    IF v_exists = 0 THEN
        SIGNAL SQLSTATE '45002' SET MESSAGE_TEXT = 'El taller no existe';
    END IF;

    -- Eliminar taller (CASCADE eliminará automáticamente inscripciones y calificaciones)
    DELETE FROM WORKSHOPS WHERE id = p_workshop_id;

    COMMIT;
    SELECT 'Taller eliminado exitosamente' AS mensaje;
END//

CREATE PROCEDURE sp_get_workshop_grades(
    IN p_workshop_id INT,
    IN p_student_id INT,
    IN p_min_grade INT,
    IN p_max_grade INT
)
BEGIN
    SELECT
        WORKSHOPS_GRADES.id AS id_workshop_grade,
        vw_workshops_grades.*
    FROM vw_workshops_grades
    JOIN WORKSHOPS_GRADES ON vw_workshops_grades.id_student = WORKSHOPS_GRADES.id_student
        AND vw_workshops_grades.id_workshop = WORKSHOPS_GRADES.id_workshop
    WHERE (p_workshop_id IS NULL OR vw_workshops_grades.id_workshop = p_workshop_id)
        AND (p_student_id IS NULL OR vw_workshops_grades.id_student = p_student_id)
        AND (p_min_grade IS NULL OR vw_workshops_grades.grade >= p_min_grade)
        AND (p_max_grade IS NULL OR vw_workshops_grades.grade <= p_max_grade)
    ORDER BY vw_workshops_grades.year DESC, vw_workshops_grades.semester DESC, vw_workshops_grades.workshop, vw_workshops_grades.name_student;
END//

-- =============================================================================
-- 4. USERS
-- =============================================================================

DROP PROCEDURE IF EXISTS sp_get_students;
DROP PROCEDURE IF EXISTS sp_create_student;
DROP PROCEDURE IF EXISTS sp_update_student;
DROP PROCEDURE IF EXISTS sp_delete_student;

DROP PROCEDURE IF EXISTS sp_get_administrators;
DROP PROCEDURE IF EXISTS sp_create_administrator;
DROP PROCEDURE IF EXISTS sp_update_administrator;
DROP PROCEDURE IF EXISTS sp_delete_administrator;

CREATE PROCEDURE sp_get_students(IN p_student_id INT)
BEGIN
    SELECT * FROM vw_students WHERE (p_student_id IS NULL OR id_student = p_student_id);
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
    -- Crear en orden: principal -> hija -> hija específica
    INSERT INTO AUTH_USERS (email, password_hash) VALUES (p_email, p_password_hash);
    SET v_auth_user_id = LAST_INSERT_ID();
    INSERT INTO USERS (id, first_names, last_names, campus) VALUES (v_auth_user_id, p_first_names, p_last_names, p_campus);
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

CREATE PROCEDURE sp_get_administrators(IN p_administrator_id INT)
BEGIN
    SELECT * FROM vw_admins WHERE (p_administrator_id IS NULL OR id_admin = p_administrator_id);
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
    -- Crear en orden: principal -> hija -> hija específica
    INSERT INTO AUTH_USERS (email, password_hash) VALUES (p_email, p_password_hash);
    SET v_auth_user_id = LAST_INSERT_ID();
    INSERT INTO USERS (id, first_names, last_names, campus) VALUES (v_auth_user_id, p_first_names, p_last_names, p_campus);
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

-- =============================================================================
-- 5. AUTH
-- =============================================================================
DROP PROCEDURE IF EXISTS sp_login;
DROP PROCEDURE IF EXISTS sp_logout;
DROP PROCEDURE IF EXISTS sp_change_password;
DROP PROCEDURE IF EXISTS sp_reset_password;
DROP PROCEDURE IF EXISTS sp_get_user_by_email;

CREATE PROCEDURE sp_login(
    IN p_email VARCHAR(255),
    IN p_password_hash VARCHAR(255)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SELECT 'Error al iniciar sesión' AS mensaje;
    END;
    START TRANSACTION;
    SELECT * FROM vw_auth_users WHERE email = p_email AND password_hash = p_password_hash;
    COMMIT;
    SELECT 'Login exitoso' AS mensaje;
END//

CREATE PROCEDURE sp_logout(
    IN p_user_id INT
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SELECT 'Error al cerrar sesión' AS mensaje;
    END;
    START TRANSACTION;
    -- Aquí podrías registrar el logout si lo deseas
    COMMIT;
    SELECT 'Logout exitoso' AS mensaje;
END//

CREATE PROCEDURE sp_change_password(
    IN p_user_id INT,
    IN p_current_password_hash VARCHAR(255),
    IN p_new_password_hash VARCHAR(255)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SELECT 'Error al cambiar contraseña' AS mensaje;
    END;
    START TRANSACTION;
    UPDATE AUTH_USERS SET password_hash = p_new_password_hash WHERE id = p_user_id AND password_hash = p_current_password_hash;
    COMMIT;
    SELECT 'Contraseña cambiada exitosamente' AS mensaje;
END//

CREATE PROCEDURE sp_reset_password(
    IN p_email VARCHAR(255),
    IN p_new_password_hash VARCHAR(255)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SELECT 'Error al resetear contraseña' AS mensaje;
    END;
    START TRANSACTION;
    UPDATE AUTH_USERS SET password_hash = p_new_password_hash WHERE email = p_email;
    COMMIT;
    SELECT 'Contraseña reseteada exitosamente' AS mensaje;
END//

CREATE PROCEDURE sp_get_user_by_email(
    IN p_email VARCHAR(255)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SELECT 'Error al obtener usuario' AS mensaje;
    END;
    START TRANSACTION;
    SELECT * FROM vw_auth_users WHERE email = p_email;
    COMMIT;
    SELECT 'Usuario obtenido exitosamente' AS mensaje;
END//

-- =============================================================================
-- 6. NOTIFICACIONES
-- =============================================================================
DROP PROCEDURE IF EXISTS sp_create_notification;
DROP PROCEDURE IF EXISTS sp_get_notifications;
DROP PROCEDURE IF EXISTS sp_mark_notification_read;

CREATE PROCEDURE sp_create_notification(
    IN p_user_type VARCHAR(20),
    IN p_notification_type VARCHAR(50),
    IN p_message TEXT(1000)
)
BEGIN
    DECLARE v_done INT DEFAULT FALSE;
    DECLARE v_user_id INT;
    DECLARE v_notification_count INT DEFAULT 0;

    -- Cursor para usuarios específicos por tipo o todos si es null
    DECLARE user_cursor CURSOR FOR
        SELECT id_auth_user
        FROM vw_auth_users
        WHERE (p_user_type IS NULL OR user_type = p_user_type);

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET v_done = TRUE;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SIGNAL SQLSTATE '45001' SET MESSAGE_TEXT = 'Error al crear notificación por tipo de usuario';
    END;

    START TRANSACTION;

    OPEN user_cursor;

    read_loop: LOOP
        FETCH user_cursor INTO v_user_id;
        IF v_done THEN
            LEAVE read_loop;
        END IF;

        -- Crear notificación para cada usuario del tipo especificado o todos
        INSERT INTO NOTIFICATIONS (
            id_user,
            notification_type,
            message,
            is_read,
            is_sent,
            id_notification_related_table,
            created_at
        ) VALUES (
            v_user_id,
            p_notification_type,
            p_message,
            0,
            0,
            NULL,
            CURRENT_TIMESTAMP
        );

        SET v_notification_count = v_notification_count + 1;
    END LOOP;

    CLOSE user_cursor;

    COMMIT;
    SELECT CONCAT('Notificaciones creadas exitosamente para usuarios tipo ', IFNULL(p_user_type, 'TODOS'), ': ', v_notification_count, ' notificaciones') AS mensaje;
END//

CREATE PROCEDURE sp_get_notifications(
    IN p_id_user INT,
    IN p_notification_type VARCHAR(50),
    IN p_is_read TINYINT(1),
    IN p_is_sent TINYINT(1),
    IN p_user_type VARCHAR(20),
    IN p_limit INT
)
BEGIN
    DECLARE v_limit INT DEFAULT 50;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SELECT 'Error al obtener notificaciones' AS mensaje;
    END;

    IF p_limit IS NOT NULL THEN
        SET v_limit = p_limit;
    END IF;

    START TRANSACTION;
    SELECT * FROM vw_notifications_detailed
    WHERE (p_id_user IS NULL OR id_user = p_id_user)
        AND (p_notification_type IS NULL OR notification_type = p_notification_type)
        AND (p_is_read IS NULL OR is_read = p_is_read)
        AND (p_is_sent IS NULL OR is_sent = p_is_sent)
        AND (p_user_type IS NULL OR user_type = p_user_type)
    ORDER BY created_at DESC
    LIMIT v_limit;
    COMMIT;
    SELECT 'Notificaciones obtenidas exitosamente' AS mensaje;
END//

CREATE PROCEDURE sp_mark_notification_read(
    IN p_id_notification INT,
    IN p_id_user INT
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SELECT 'Error al marcar notificación como leída' AS mensaje;
    END;
    START TRANSACTION;
    UPDATE NOTIFICATIONS SET is_read = 1, read_at = CURRENT_TIMESTAMP WHERE id = p_id_notification AND id_user = p_id_user;
    COMMIT;
    SELECT 'Notificación marcada como leída exitosamente' AS mensaje;
END//
