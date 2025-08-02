-- =============================================================================
-- PROCEDIMIENTOS ALMACENADOS
-- =============================================================================

-- =========================
-- 1. CATÁLOGOS Y ESTADOS
-- =========================
DROP PROCEDURE IF EXISTS sp_get_convalidation_types;
DROP PROCEDURE IF EXISTS sp_get_curriculum_courses_types;
DROP PROCEDURE IF EXISTS sp_get_workshop_states;
DROP PROCEDURE IF EXISTS sp_get_convalidation_states;

-- =========================
-- 2. DEPARTMENTS
-- =========================
DROP PROCEDURE IF EXISTS sp_get_departments;
DROP PROCEDURE IF EXISTS sp_create_department;
DROP PROCEDURE IF EXISTS sp_update_department;
DROP PROCEDURE IF EXISTS sp_delete_department;

-- =========================
-- 3. SUBJECTS
-- =========================
DROP PROCEDURE IF EXISTS sp_get_subjects;
DROP PROCEDURE IF EXISTS sp_create_subject;
DROP PROCEDURE IF EXISTS sp_update_subject;
DROP PROCEDURE IF EXISTS sp_delete_subject;

-- =========================
-- 4. CURRICULUM_COURSES
-- =========================
DROP PROCEDURE IF EXISTS sp_get_curriculum_courses;
DROP PROCEDURE IF EXISTS sp_create_curriculum_course;
DROP PROCEDURE IF EXISTS sp_update_curriculum_course;
DROP PROCEDURE IF EXISTS sp_delete_curriculum_course;
DROP PROCEDURE IF EXISTS sp_get_curriculum_courses_not_convalidated_by_student;

-- =========================
-- 5. CONVALIDACIONES
-- =========================
DROP PROCEDURE IF EXISTS sp_get_convalidations;
DROP PROCEDURE IF EXISTS sp_create_convalidation;
DROP PROCEDURE IF EXISTS sp_drop_convalidation_while_no_reviewed_by_id;
DROP PROCEDURE IF EXISTS sp_review_convalidation;

-- =========================
-- 6. TALLERES
-- =========================
DROP PROCEDURE IF EXISTS sp_get_workshops;
DROP PROCEDURE IF EXISTS sp_update_workshop;
DROP PROCEDURE IF EXISTS sp_delete_workshop;
DROP PROCEDURE IF EXISTS sp_create_workshop;
DROP PROCEDURE IF EXISTS sp_get_workshops_inscriptions;

DROP PROCEDURE IF EXISTS sp_get_workshop_grades;
DROP PROCEDURE IF EXISTS sp_cancel_workshop_inscription;
DROP PROCEDURE IF EXISTS sp_change_workshop_state;
DROP PROCEDURE IF EXISTS sp_create_workshop_inscription;
DROP PROCEDURE IF EXISTS sp_create_workshop_grade;

-- =========================
-- 7. USERS
-- =========================
DROP PROCEDURE IF EXISTS sp_get_students;
DROP PROCEDURE IF EXISTS sp_create_student;
DROP PROCEDURE IF EXISTS sp_update_student;
DROP PROCEDURE IF EXISTS sp_delete_student;
DROP PROCEDURE IF EXISTS sp_get_administrators;
DROP PROCEDURE IF EXISTS sp_create_administrator;
DROP PROCEDURE IF EXISTS sp_update_administrator;
DROP PROCEDURE IF EXISTS sp_delete_administrator;

-- =========================
-- 8. AUTH
-- =========================
DROP PROCEDURE IF EXISTS sp_login;
DROP PROCEDURE IF EXISTS sp_logout;
DROP PROCEDURE IF EXISTS sp_change_password;
DROP PROCEDURE IF EXISTS sp_reset_password;
DROP PROCEDURE IF EXISTS sp_get_user_by_email;

-- =========================
-- 9. NOTIFICACIONES
-- =========================
DROP PROCEDURE IF EXISTS sp_create_notification;
DROP PROCEDURE IF EXISTS sp_get_notifications;
DROP PROCEDURE IF EXISTS sp_mark_notification_read;

-- =========================
-- 10. DASHBOARD STATISTICS
-- =========================
DROP PROCEDURE IF EXISTS sp_get_dashboard_general_stats;
DROP PROCEDURE IF EXISTS sp_get_dashboard_convalidation_stats;
DROP PROCEDURE IF EXISTS sp_get_dashboard_workshop_stats;
DROP PROCEDURE IF EXISTS sp_get_dashboard_student_stats;
DROP PROCEDURE IF EXISTS sp_get_dashboard_activity_stats;

DELIMITER //

-- =========================
-- 1. CATÁLOGOS Y ESTADOS
-- =========================

CREATE PROCEDURE sp_get_convalidation_types()
BEGIN
    SELECT * FROM CONVALIDATION_TYPES;
END//

CREATE PROCEDURE sp_get_curriculum_courses_types()
BEGIN
    SELECT * FROM CURRICULUM_COURSES_TYPES;
END//

CREATE PROCEDURE sp_get_workshop_states()
BEGIN
    SELECT * FROM WORKSHOP_STATES;
END//

CREATE PROCEDURE sp_get_convalidation_states()
BEGIN
    SELECT * FROM CONVALIDATION_STATES;
END//

-- =========================
-- 2. DEPARTMENTS
-- =========================

CREATE PROCEDURE sp_get_departments(IN p_department_id INT)
BEGIN
    SELECT * FROM DEPARTMENTS WHERE (p_department_id IS NULL OR id = p_department_id);
END//

CREATE PROCEDURE sp_create_department(IN p_name VARCHAR(255))
BEGIN
    START TRANSACTION;
    IF NOT EXISTS (SELECT 1 FROM DEPARTMENTS WHERE name = p_name) THEN
        INSERT INTO DEPARTMENTS (name) VALUES (p_name);
    ELSE
        SIGNAL SQLSTATE '45002' SET MESSAGE_TEXT = 'El departamento ya existe';
    END IF;
    COMMIT;
END//

CREATE PROCEDURE sp_update_department(
    IN p_department_id INT,
    IN p_name VARCHAR(255),
    IN p_description TEXT
)
BEGIN
    START TRANSACTION;
    IF NOT EXISTS (SELECT 1 FROM DEPARTMENTS WHERE id = p_department_id) THEN
        SIGNAL SQLSTATE '45002' SET MESSAGE_TEXT = 'El departamento no existe';
    END IF;
    UPDATE DEPARTMENTS
    SET name = COALESCE(p_name, name),
        description = COALESCE(p_description, description)
    WHERE id = p_department_id;
    COMMIT;
END//

CREATE PROCEDURE sp_delete_department(IN p_department_id INT)
BEGIN
    START TRANSACTION;
    IF NOT EXISTS (SELECT 1 FROM DEPARTMENTS WHERE id = p_department_id) THEN
        SIGNAL SQLSTATE '45002' SET MESSAGE_TEXT = 'El departamento no existe';
    END IF;
    DELETE FROM DEPARTMENTS WHERE id = p_department_id;
    COMMIT;
END//

-- =========================
-- 3. SUBJECTS
-- =========================

CREATE PROCEDURE sp_get_subjects(IN p_subject_id INT, IN p_id_department INT)
BEGIN
    SELECT * FROM vw_subjects WHERE (p_subject_id IS NULL OR id_subject = p_subject_id) AND (p_id_department IS NULL OR id_department = p_id_department);
END//

CREATE PROCEDURE sp_create_subject(
    IN p_acronym VARCHAR(255),
    IN p_name VARCHAR(255),
    IN p_id_department INT,
    IN p_credits INT
)
BEGIN
    START TRANSACTION;
    IF NOT EXISTS (SELECT 1 FROM DEPARTMENTS WHERE id = p_id_department) THEN
        SIGNAL SQLSTATE '45002' SET MESSAGE_TEXT = 'El departamento no existe';
    END IF;
    IF NOT EXISTS (SELECT 1 FROM SUBJECTS WHERE acronym = p_acronym AND name = p_name AND id_department = p_id_department) THEN
        INSERT INTO SUBJECTS (acronym, name, id_department, credits) VALUES (p_acronym, p_name, p_id_department, p_credits);
    ELSE
        SIGNAL SQLSTATE '45002' SET MESSAGE_TEXT = 'La asignatura ya existe';
    END IF;
    COMMIT;
END//

CREATE PROCEDURE sp_update_subject(
    IN p_subject_id INT,
    IN p_acronym VARCHAR(255),
    IN p_name VARCHAR(255),
    IN p_id_department INT,
    IN p_credits INT
)
BEGIN
    START TRANSACTION;
    IF NOT EXISTS (SELECT 1 FROM SUBJECTS WHERE id = p_subject_id) THEN
        SIGNAL SQLSTATE '45002' SET MESSAGE_TEXT = 'La asignatura no existe';
    END IF;
    IF NOT EXISTS (SELECT 1 FROM DEPARTMENTS WHERE id = p_id_department) THEN
        SIGNAL SQLSTATE '45002' SET MESSAGE_TEXT = 'El departamento no existe';
    END IF;
    UPDATE SUBJECTS SET acronym = p_acronym, name = p_name, id_department = p_id_department, credits = p_credits WHERE id = p_subject_id;
    COMMIT;
END//

CREATE PROCEDURE sp_delete_subject(IN p_subject_id INT)
BEGIN
    START TRANSACTION;
    IF NOT EXISTS (SELECT 1 FROM SUBJECTS WHERE id = p_subject_id) THEN
        SIGNAL SQLSTATE '45002' SET MESSAGE_TEXT = 'La asignatura no existe';
    END IF;
    DELETE FROM SUBJECTS WHERE id = p_subject_id;
    COMMIT;
END//

-- =========================
-- 4. CURRICULUM_COURSES
-- =========================

CREATE PROCEDURE sp_get_curriculum_courses(IN p_curriculum_course_id INT)
BEGIN
    SELECT * FROM vw_curriculum_courses WHERE (p_curriculum_course_id IS NULL OR id_curriculum_course = p_curriculum_course_id);
END//

CREATE PROCEDURE sp_create_curriculum_course(
    IN p_name VARCHAR(255),
    IN p_id_curriculum_course_type INT
)
BEGIN
    START TRANSACTION;
    IF NOT EXISTS (SELECT 1 FROM CURRICULUM_COURSES_TYPES WHERE id = p_id_curriculum_course_type) THEN
        SIGNAL SQLSTATE '45002' SET MESSAGE_TEXT = 'El tipo de curso curricular no existe';
    END IF;
    IF NOT EXISTS (SELECT 1 FROM CURRICULUM_COURSES WHERE name = p_name AND id_curriculum_course_type = p_id_curriculum_course_type) THEN
        INSERT INTO CURRICULUM_COURSES (name, id_curriculum_course_type) VALUES (p_name, p_id_curriculum_course_type);
    ELSE
        SIGNAL SQLSTATE '45002' SET MESSAGE_TEXT = 'El curso curricular ya existe';
    END IF;
    COMMIT;
END//

CREATE PROCEDURE sp_update_curriculum_course(
    IN p_curriculum_course_id INT,
    IN p_name VARCHAR(255),
    IN p_id_curriculum_course_type INT
)
BEGIN
    START TRANSACTION;
    IF NOT EXISTS (SELECT 1 FROM CURRICULUM_COURSES WHERE id = p_curriculum_course_id) THEN
        SIGNAL SQLSTATE '45002' SET MESSAGE_TEXT = 'El curso curricular no existe';
    END IF;
    IF NOT EXISTS (SELECT 1 FROM CURRICULUM_COURSES_TYPES WHERE id = p_id_curriculum_course_type) THEN
        SIGNAL SQLSTATE '45002' SET MESSAGE_TEXT = 'El tipo de curso curricular no existe';
    END IF;
    UPDATE CURRICULUM_COURSES SET name = p_name, id_curriculum_course_type = p_id_curriculum_course_type WHERE id = p_curriculum_course_id;
    COMMIT;
END//

CREATE PROCEDURE sp_delete_curriculum_course(IN p_curriculum_course_id INT)
BEGIN
    START TRANSACTION;
    IF NOT EXISTS (SELECT 1 FROM CURRICULUM_COURSES WHERE id = p_curriculum_course_id) THEN
        SIGNAL SQLSTATE '45002' SET MESSAGE_TEXT = 'El curso curricular no existe';
    END IF;
    DELETE FROM CURRICULUM_COURSES WHERE id = p_curriculum_course_id;
    COMMIT;
END//

-- =============================================================================
-- PROCEDIMIENTO: Cursos curriculares no convalidados por estudiante
-- =============================================================================
CREATE PROCEDURE sp_get_curriculum_courses_not_convalidated_by_student(IN p_id_student INT)
BEGIN
    SELECT * FROM vw_curriculum_courses_not_convalidated_by_student WHERE id_student = p_id_student;
END;

-- =============================================================================
-- 2. CONVALIDACIONES
-- =============================================================================

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
    IN p_id_subject INT,
    IN p_id_department INT,
    IN p_student_campus VARCHAR(255)
)
BEGIN
    -- Convalidaciones de asignaturas
    SELECT *  subject, department FROM vw_convalidation_subjects
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
    START TRANSACTION;
   

    -- Validar existencia de estudiante
    IF NOT EXISTS (SELECT 1 FROM STUDENTS WHERE id = p_id_student) THEN
        SIGNAL SQLSTATE '45001' SET MESSAGE_TEXT = 'El estudiante no existe';
    END IF;

    -- Validar existencia de tipo de convalidación
    IF NOT EXISTS (SELECT 1 FROM CONVALIDATION_TYPES WHERE id = p_id_convalidation_type) THEN
        SIGNAL SQLSTATE '45001' SET MESSAGE_TEXT = 'El tipo de convalidación no existe';
    END IF;

    -- Validar existencia de curso curricular
    IF NOT EXISTS (SELECT 1 FROM CURRICULUM_COURSES WHERE id = p_id_curriculum_course) THEN
        SIGNAL SQLSTATE '45001' SET MESSAGE_TEXT = 'El curso curricular no existe';
    END IF;

    -- Validar existencia de estado ENVIADA
    IF NOT EXISTS (SELECT 1 FROM CONVALIDATION_STATES WHERE name = 'ENVIADA') THEN
        SIGNAL SQLSTATE '45001' SET MESSAGE_TEXT = 'No existe el estado ENVIADA';
    END IF;

    -- Validar existencia de asignatura si corresponde
    IF p_id_subject IS NOT NULL AND NOT EXISTS (SELECT 1 FROM SUBJECTS WHERE id = p_id_subject) THEN
        SIGNAL SQLSTATE '45001' SET MESSAGE_TEXT = 'La asignatura no existe';
    END IF;

    -- Validar existencia de taller si corresponde
    IF p_id_workshop IS NOT NULL AND NOT EXISTS (SELECT 1 FROM WORKSHOPS WHERE id = p_id_workshop) THEN
        SIGNAL SQLSTATE '45001' SET MESSAGE_TEXT = 'El taller no existe';
    END IF;

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
        IF p_file_name IS NULL OR p_file_data IS NULL THEN
            SIGNAL SQLSTATE '45001' SET MESSAGE_TEXT = 'Falta el archivo para la actividad externa';
        END IF;
        INSERT INTO CONVALIDATIONS_EXTERNAL_ACTIVITIES (id_convalidation, activity_name, description, file_name, file_data)
        VALUES (v_id_convalidation, p_activity_name, p_description, p_file_name, p_file_data);
    END IF;

    IF p_id_subject IS NOT NULL THEN
        INSERT INTO CONVALIDATIONS_SUBJECTS (id_convalidation, id_subject) VALUES (v_id_convalidation, p_id_subject);
    END IF;

    COMMIT;
END//

CREATE PROCEDURE sp_drop_convalidation_while_no_reviewed_by_id(IN p_id_convalidation INT)
BEGIN
    DECLARE v_convalidation_state INT;
    DECLARE v_enviada_state_id INT;
    DECLARE v_id_request INT;
    DECLARE v_remaining_convalidations INT;
    START TRANSACTION;
   

    SELECT id INTO v_enviada_state_id FROM CONVALIDATION_STATES WHERE name = 'ENVIADA';

    SELECT id_convalidation_state, id_request INTO v_convalidation_state, v_id_request
    FROM CONVALIDATIONS WHERE id = p_id_convalidation;

    DELETE FROM CONVALIDATIONS WHERE id = p_id_convalidation;

    SELECT COUNT(*) INTO v_remaining_convalidations FROM CONVALIDATIONS WHERE id_request = v_id_request;
    IF v_remaining_convalidations = 0 THEN
        DELETE FROM REQUESTS WHERE id = v_id_request;
    END IF;

    COMMIT;
END//



CREATE PROCEDURE sp_review_convalidation(
    IN p_id_convalidation INT,
    IN p_id_convalidation_state INT,
    IN p_review_comments TEXT(1000),
    IN p_id_reviewed_by INT
)
BEGIN
    DECLARE v_id_request INT;
    START TRANSACTION;

    -- Validar existencia de convalidación
    IF NOT EXISTS (SELECT 1 FROM CONVALIDATIONS WHERE id = p_id_convalidation) THEN
        SIGNAL SQLSTATE '45001' SET MESSAGE_TEXT = 'La convalidación no existe';
    END IF;

    -- Validar existencia de estado
    IF NOT EXISTS (SELECT 1 FROM CONVALIDATION_STATES WHERE id = p_id_convalidation_state) THEN
        SIGNAL SQLSTATE '45001' SET MESSAGE_TEXT = 'El estado de convalidación no existe';
    END IF;

    -- Validar existencia de revisor
    IF NOT EXISTS (SELECT 1 FROM ADMINISTRATORS WHERE id = p_id_reviewed_by) THEN
        SIGNAL SQLSTATE '45001' SET MESSAGE_TEXT = 'El revisor no existe';
    END IF;

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
END//

-- =============================================================================
-- 3. TALLERES
-- =============================================================================

CREATE PROCEDURE sp_get_workshops(
    IN p_id_workshop INT,
    IN p_workshop_state_id INT,
    IN p_professor VARCHAR(255),
    IN p_year INT,
    IN p_semester ENUM('1', '2')
)
BEGIN
    START TRANSACTION;
    SELECT *
    FROM vw_workshops
    WHERE (p_workshop_state_id IS NULL OR id_workshop_state = p_workshop_state_id)
      AND (p_professor IS NULL OR professor = p_professor)
      AND (p_id_workshop IS NULL OR id_workshop = p_id_workshop)
      AND (p_year IS NULL OR year = p_year)
      AND (p_semester IS NULL OR semester = p_semester);
    COMMIT;
END//

CREATE PROCEDURE sp_get_workshops_inscriptions(
    IN p_workshop_id INT,
    IN p_student_id INT,
    IN p_is_convalidated TINYINT(1),
    IN p_curriculum_course_id INT
)
BEGIN 
    START TRANSACTION;
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
    COMMIT;
END//

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
    START TRANSACTION;
    IF NOT EXISTS (SELECT 1 FROM WORKSHOP_STATES WHERE id = p_id_workshop_state) THEN
        SIGNAL SQLSTATE '45002' SET MESSAGE_TEXT = 'El estado del taller no existe';
    END IF;
    IF NOT EXISTS (SELECT 1 FROM WORKSHOPS WHERE name = p_name AND semester = p_semester AND year = p_year AND professor = p_professor AND description = p_description AND inscription_start_date = p_inscription_start_date AND inscription_end_date = p_inscription_end_date AND course_start_date = p_course_start_date AND course_end_date = p_course_end_date AND available = p_available AND limit_inscriptions = p_limit_inscriptions AND id_workshop_state = p_id_workshop_state) THEN
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
    ELSE
        SIGNAL SQLSTATE '45002' SET MESSAGE_TEXT = 'El taller ya existe';
    END IF;
    COMMIT;
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
    IF NOT EXISTS (SELECT 1 FROM WORKSHOPS WHERE id = p_workshop_id) THEN
        SIGNAL SQLSTATE '45002' SET MESSAGE_TEXT = 'El taller no existe';
    END IF;
    IF NOT EXISTS (SELECT 1 FROM WORKSHOP_STATES WHERE id = p_workshop_state_id) THEN
        SIGNAL SQLSTATE '45002' SET MESSAGE_TEXT = 'El estado del taller no existe';
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
END//

CREATE PROCEDURE sp_delete_workshop(IN p_workshop_id INT)
BEGIN
    START TRANSACTION;
    IF NOT EXISTS (SELECT 1 FROM WORKSHOPS WHERE id = p_workshop_id) THEN
        SIGNAL SQLSTATE '45002' SET MESSAGE_TEXT = 'El taller no existe';
    END IF;
    -- Eliminar taller (CASCADE eliminará automáticamente inscripciones y calificaciones)
    DELETE FROM WORKSHOPS WHERE id = p_workshop_id;
    COMMIT;
END//

CREATE PROCEDURE sp_get_workshop_grades(
    IN p_workshop_id INT,
    IN p_student_id INT,
    IN p_min_grade INT,
    IN p_max_grade INT
)
BEGIN
    START TRANSACTION;
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
    COMMIT;
END//

-- =============================================================================
-- 4. USERS
-- =============================================================================

CREATE PROCEDURE sp_get_students(IN p_student_id INT, IN p_rol_student VARCHAR(11), IN p_rut_student VARCHAR(12), IN p_first_names VARCHAR(255), IN p_last_names VARCHAR(255))
BEGIN
    SELECT * FROM vw_students WHERE (p_student_id IS NULL OR id_student = p_student_id)
        AND (p_rol_student IS NULL OR rol_student = p_rol_student)
        AND (p_rut_student IS NULL OR rut_student = p_rut_student)
        AND (p_first_names IS NULL OR first_names = p_first_names)
        AND (p_last_names IS NULL OR last_names = p_last_names);
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
    DECLARE v_msg VARCHAR(255);
    START TRANSACTION;
    IF EXISTS (SELECT 1 FROM AUTH_USERS WHERE email = p_email) THEN
        SIGNAL SQLSTATE '45002' SET MESSAGE_TEXT = 'El email ya existe';
    END IF;
    INSERT INTO AUTH_USERS (email, password_hash) VALUES (p_email, p_password_hash);
    SET v_auth_user_id = LAST_INSERT_ID();
    INSERT INTO USERS (id, first_names, last_names, campus) VALUES (v_auth_user_id, p_first_names, p_last_names, p_campus);
    INSERT INTO STUDENTS (id, rol_student, rut_student, campus_student) VALUES (v_auth_user_id, p_rol_student, p_rut_student, p_campus_student);
    COMMIT;
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
    START TRANSACTION;
    IF NOT EXISTS (SELECT 1 FROM STUDENTS WHERE id = p_student_id) THEN
        SIGNAL SQLSTATE '45002' SET MESSAGE_TEXT = 'El estudiante no existe';
    END IF;
    IF EXISTS (SELECT 1 FROM AUTH_USERS WHERE email = p_email AND id != p_student_id) THEN
        SIGNAL SQLSTATE '45002' SET MESSAGE_TEXT = 'El email ya existe';
    END IF;
    UPDATE AUTH_USERS SET email = p_email, password_hash = p_password_hash WHERE id = p_student_id;
    UPDATE USERS SET first_names = p_first_names, last_names = p_last_names, campus = p_campus WHERE id = p_student_id;
    UPDATE STUDENTS SET rol_student = p_rol_student, rut_student = p_rut_student, campus_student = p_campus_student WHERE id = p_student_id;
    COMMIT;
END//

CREATE PROCEDURE sp_delete_student(IN p_student_id INT)
BEGIN
    START TRANSACTION;
    IF NOT EXISTS (SELECT 1 FROM STUDENTS WHERE id = p_student_id) THEN
        SIGNAL SQLSTATE '45002' SET MESSAGE_TEXT = 'El estudiante no existe';
    END IF;
    -- Solo eliminar de AUTH_USERS (tabla principal) - CASCADE eliminará automáticamente USERS y STUDENTS
    DELETE FROM AUTH_USERS WHERE id = p_student_id;
    COMMIT;
END//

CREATE PROCEDURE sp_get_administrators(IN p_administrator_id INT, IN p_campus VARCHAR(255), IN p_email VARCHAR(255))
BEGIN
    SELECT * FROM vw_admins WHERE (p_administrator_id IS NULL OR id_admin = p_administrator_id)
        AND (p_campus IS NULL OR campus = p_campus)
        AND (p_email IS NULL OR email = p_email);
END//

CREATE PROCEDURE sp_create_administrator(
    IN p_first_names VARCHAR(255),
    IN p_last_names VARCHAR(255),
    IN p_campus VARCHAR(255),
    IN p_email VARCHAR(255),
    IN p_password_hash VARCHAR(255)
)
BEGIN
    -- Para todos los procedures que no se usan en triggers (excepto sp_create_notification):
    -- Agregar START TRANSACTION al inicio y COMMIT al final, sin handler general, y dejando solo los SIGNAL SQLSTATE de errores específicos.
    START TRANSACTION;

    -- Validación: ¿ya existe el email?
    IF EXISTS (SELECT 1 FROM AUTH_USERS WHERE email = p_email) THEN
        ROLLBACK;
        SIGNAL SQLSTATE '45002' SET MESSAGE_TEXT = 'El email ya existe';
    END IF;

    INSERT INTO AUTH_USERS (email, password_hash) VALUES (p_email, p_password_hash);
    SET @id = LAST_INSERT_ID();
    INSERT INTO USERS (id, first_names, last_names, campus) VALUES (@id, p_first_names, p_last_names, p_campus);
    INSERT INTO ADMINISTRATORS (id) VALUES (@id);

    COMMIT;
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
    START TRANSACTION;
    IF NOT EXISTS (SELECT 1 FROM ADMINISTRATORS WHERE id = p_administrator_id) THEN
        SIGNAL SQLSTATE '45002' SET MESSAGE_TEXT = 'El administrador no existe';
    END IF;
    IF EXISTS (SELECT 1 FROM AUTH_USERS WHERE email = p_email AND id != p_administrator_id) THEN
        SIGNAL SQLSTATE '45002' SET MESSAGE_TEXT = 'El email ya existe';
    END IF;
    UPDATE AUTH_USERS SET email = p_email, password_hash = p_password_hash WHERE id = p_administrator_id;
    UPDATE USERS SET first_names = p_first_names, last_names = p_last_names, campus = p_campus WHERE id = p_administrator_id;
    COMMIT;
END//


CREATE PROCEDURE sp_delete_administrator(IN p_administrator_id INT)
BEGIN
    START TRANSACTION;
    IF NOT EXISTS (SELECT 1 FROM ADMINISTRATORS WHERE id = p_administrator_id) THEN
        SIGNAL SQLSTATE '45002' SET MESSAGE_TEXT = 'El administrador no existe';
    END IF;
    -- Solo eliminar de AUTH_USERS (tabla principal) - CASCADE eliminará automáticamente USERS y ADMINISTRATORS
    DELETE FROM AUTH_USERS WHERE id = p_administrator_id;
    COMMIT;
END//

-- =============================================================================
-- 5. AUTH
-- =============================================================================
CREATE PROCEDURE sp_login(
    IN p_email VARCHAR(255),
    IN p_password_hash VARCHAR(255)
)
BEGIN
    START TRANSACTION;
    SELECT * FROM vw_auth_users WHERE email = p_email AND password_hash = p_password_hash;
    COMMIT;
END//

CREATE PROCEDURE sp_logout(
    IN p_user_id INT
)
BEGIN
    START TRANSACTION;
    
    COMMIT;
    
END//

CREATE PROCEDURE sp_change_password(
    IN p_id_auth_user INT,
    IN p_current_password_hash VARCHAR(255),
    IN p_new_password_hash VARCHAR(255)
)
BEGIN
    
    START TRANSACTION;
        UPDATE AUTH_USERS SET password_hash = p_new_password_hash WHERE id = p_id_auth_user AND password_hash = p_current_password_hash;
        COMMIT;
    
END//

CREATE PROCEDURE sp_reset_password(
    IN p_email VARCHAR(255),
    IN p_new_password_hash VARCHAR(255)
)
BEGIN
    
    START TRANSACTION;
    UPDATE AUTH_USERS SET password_hash = p_new_password_hash WHERE email = p_email;
    COMMIT;
END //

    

CREATE PROCEDURE sp_get_user_by_email(
    IN p_email VARCHAR(255)
)
BEGIN
    
    START TRANSACTION;
    SELECT * FROM vw_auth_users WHERE email = p_email;
    COMMIT;
    
END//

-- =============================================================================
-- 6. NOTIFICACIONES
-- =============================================================================
CREATE PROCEDURE sp_create_notification(
    IN p_user_type VARCHAR(20),
    IN p_notification_type VARCHAR(50),
    IN p_message TEXT(1000)
)
BEGIN
    DECLARE v_done INT DEFAULT FALSE;
    DECLARE v_user_id INT;
    DECLARE v_notification_count INT DEFAULT 0;

   
    DECLARE user_cursor CURSOR FOR
        SELECT id_auth_user
        FROM vw_auth_users
        WHERE (p_user_type IS NULL OR user_type = p_user_type);

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET v_done = TRUE;

   

    OPEN user_cursor;

    read_loop: LOOP
        FETCH user_cursor INTO v_user_id;
        IF v_done THEN
            LEAVE read_loop;
        END IF;


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
END//

CREATE PROCEDURE sp_get_notifications(
    IN p_id_auth_user INT,
    IN p_notification_type VARCHAR(50),
    IN p_is_read TINYINT(1),
    IN p_is_sent TINYINT(1),
    IN p_user_type VARCHAR(20),
    IN p_limit INT
)
BEGIN
    DECLARE v_limit INT DEFAULT 50;
   

    IF p_limit IS NOT NULL THEN
        SET v_limit = p_limit;
    END IF;

    START TRANSACTION;
    SELECT * FROM vw_notifications_detailed
    WHERE (p_id_auth_user IS NULL OR id_auth_user = p_id_auth_user)
        AND (p_notification_type IS NULL OR notification_type = p_notification_type)
        AND (p_is_read IS NULL OR is_read = p_is_read)
        AND (p_is_sent IS NULL OR is_sent = p_is_sent)
        AND (p_user_type IS NULL OR user_type = p_user_type)
    ORDER BY created_at DESC
    LIMIT v_limit;
    COMMIT;
END//

CREATE PROCEDURE sp_mark_notification_read(
    IN p_id_notification INT,
    IN p_id_auth_user INT
)
BEGIN
    START TRANSACTION;
    UPDATE NOTIFICATIONS SET is_read = 1, read_at = CURRENT_TIMESTAMP WHERE id = p_id_notification AND id_user = p_id_auth_user;
    COMMIT;
END//

-- =============================================================================
-- PROCEDIMIENTO: Cancelar inscripción a taller
-- =============================================================================
CREATE PROCEDURE sp_cancel_workshop_inscription(
    IN p_id_inscription INT,
    IN p_id_student INT
)
BEGIN
    DECLARE v_nombre_taller VARCHAR(255);
    DECLARE v_fecha_inicio DATETIME;
    DECLARE v_msg VARCHAR(255);

  

    START TRANSACTION;

    -- Obtener el nombre del taller y la fecha de inicio para el mensaje de error y validación
    SELECT WORKSHOPS.NAME, WORKSHOPS.COURSE_START_DATE INTO v_nombre_taller, v_fecha_inicio
    FROM WORKSHOPS_INSCRIPTIONS
    JOIN WORKSHOPS ON WORKSHOPS_INSCRIPTIONS.ID_WORKSHOP = WORKSHOPS.ID
    WHERE WORKSHOPS_INSCRIPTIONS.ID = p_id_inscription AND WORKSHOPS_INSCRIPTIONS.ID_STUDENT = p_id_student
    LIMIT 1;

    -- Verificar si el taller ya inició
    IF v_fecha_inicio IS NOT NULL AND v_fecha_inicio <= CURRENT_TIMESTAMP THEN
        ROLLBACK;
        SET v_msg = CONCAT_WS(' ', 'No se puede cancelar inscripción, el taller ya inició:', IFNULL(v_nombre_taller, ''));
        SIGNAL SQLSTATE '45001' SET MESSAGE_TEXT = v_msg;
    END IF;

    -- Eliminar la inscripción
    DELETE FROM WORKSHOPS_INSCRIPTIONS WHERE ID = p_id_inscription AND ID_STUDENT = p_id_student;

    COMMIT;
    
END//

-- =============================================================================
-- PROCEDIMIENTO: Cambiar estado de taller con validaciones de transición
-- =============================================================================
CREATE PROCEDURE sp_change_workshop_state(
    IN p_id_workshop INT,
    IN p_new_state_id INT,
    IN p_new_inscription_start_date TIMESTAMP,
    IN p_new_inscription_end_date TIMESTAMP,
    IN p_new_course_start_date TIMESTAMP,
    IN p_new_course_end_date TIMESTAMP
)
BEGIN
    DECLARE v_current_state_id INT;
    DECLARE v_nombre_taller VARCHAR(255) DEFAULT 'DESCONOCIDO';
    DECLARE v_msg VARCHAR(255);
    
    START TRANSACTION;
    SELECT id_workshop_state, workshop INTO v_current_state_id, v_nombre_taller FROM vw_workshops WHERE id_workshop = p_id_workshop LIMIT 1;
    IF v_current_state_id IS NULL THEN
        SET v_nombre_taller = 'DESCONOCIDO';
        SET v_msg = CONCAT_WS(' ', 'No se pudo cambiar el estado del taller:', v_nombre_taller);
        SIGNAL SQLSTATE '45001' SET MESSAGE_TEXT = v_msg;
    END IF;
    IF (v_current_state_id = 3 AND p_new_state_id = 2) OR (v_current_state_id = 4 AND p_new_state_id IN (1,2,3)) OR (v_current_state_id = 5) THEN
        SET v_msg = CONCAT_WS(' ', 'No se pudo cambiar el estado del taller:', v_nombre_taller);
        SIGNAL SQLSTATE '45001' SET MESSAGE_TEXT = v_msg;
    END IF;
    UPDATE WORKSHOPS SET
        id_workshop_state = p_new_state_id,
        inscription_start_date = p_new_inscription_start_date,
        inscription_end_date = p_new_inscription_end_date,
        course_start_date = p_new_course_start_date,
        course_end_date = p_new_course_end_date
    WHERE id = p_id_workshop;
    COMMIT;

END;

-- =============================================================================
-- DASHBOARD STATISTICS
-- =============================================================================

-- -----------------------------------------------------------------------------
-- 1. GENERAL STATISTICS
-- -----------------------------------------------------------------------------
CREATE PROCEDURE sp_get_dashboard_general_stats()
BEGIN
    SELECT
        COUNT(*) AS total_convalidations,
        SUM(CONVALIDATIONS.id_convalidation_state IN (
            SELECT CONVALIDATION_STATES.id 
            FROM CONVALIDATION_STATES 
            WHERE CONVALIDATION_STATES.name IN ('APROBADA_DI', 'APROBADA_DE', 'ENVIADA_DE')
        )) AS approved_convalidations,
        SUM(CONVALIDATIONS.id_convalidation_state IN (
            SELECT CONVALIDATION_STATES.id 
            FROM CONVALIDATION_STATES 
            WHERE CONVALIDATION_STATES.name IN ('RECHAZADA_DI', 'RECHAZADA_DE')
        )) AS rejected_convalidations,
        SUM(CONVALIDATIONS.id_convalidation_state = (
            SELECT CONVALIDATION_STATES.id 
            FROM CONVALIDATION_STATES 
            WHERE CONVALIDATION_STATES.name = 'ENVIADA'
            LIMIT 1
        )) AS pending_convalidations,
        (SELECT COUNT(*) FROM WORKSHOPS WHERE WORKSHOPS.id_workshop_state = (
            SELECT WORKSHOP_STATES.id FROM WORKSHOP_STATES WHERE WORKSHOP_STATES.name = 'EN_CURSO' LIMIT 1
        )) AS workshops_in_progress,
        (SELECT COUNT(*) FROM WORKSHOPS WHERE WORKSHOPS.id_workshop_state = (
            SELECT WORKSHOP_STATES.id FROM WORKSHOP_STATES WHERE WORKSHOP_STATES.name = 'FINALIZADO' LIMIT 1
        )) AS workshops_finished,
        SUM(
            YEAR(REQUESTS.sent_at) = YEAR(CURDATE()) 
            AND MONTH(REQUESTS.sent_at) = MONTH(CURDATE())
        ) AS convalidations_this_month
    FROM CONVALIDATIONS
    LEFT JOIN REQUESTS ON CONVALIDATIONS.id_request = REQUESTS.id;
END;

-- -----------------------------------------------------------------------------
-- 2. CONVALIDATION STATISTICS
-- -----------------------------------------------------------------------------
CREATE PROCEDURE sp_get_dashboard_convalidation_stats()
BEGIN
    -- Convalidations by type
    SELECT CONVALIDATION_TYPES.name AS convalidation_type, COUNT(*) AS total
    FROM CONVALIDATIONS
    JOIN CONVALIDATION_TYPES ON CONVALIDATIONS.id_convalidation_type = CONVALIDATION_TYPES.id
    GROUP BY CONVALIDATION_TYPES.name;

    -- Convalidations by state
    SELECT CONVALIDATION_STATES.name AS convalidation_state, COUNT(*) AS total
    FROM CONVALIDATIONS
    JOIN CONVALIDATION_STATES ON CONVALIDATIONS.id_convalidation_state = CONVALIDATION_STATES.id
    GROUP BY CONVALIDATION_STATES.name;

    -- Convalidations by department (using SUBJECTS and DEPARTMENTS via CURRICULUM_COURSES)
    SELECT DEPARTMENTS.name AS department, COUNT(*) AS total
    FROM CONVALIDATIONS
    JOIN CURRICULUM_COURSES ON CONVALIDATIONS.id_curriculum_course = CURRICULUM_COURSES.id
    JOIN SUBJECTS ON CURRICULUM_COURSES.name = SUBJECTS.name
    JOIN DEPARTMENTS ON SUBJECTS.id_department = DEPARTMENTS.id
    GROUP BY DEPARTMENTS.name;

    -- Convalidations by month/year
    SELECT YEAR(REQUESTS.sent_at) AS year, MONTH(REQUESTS.sent_at) AS month, COUNT(*) AS total
    FROM CONVALIDATIONS
    JOIN REQUESTS ON CONVALIDATIONS.id_request = REQUESTS.id
    GROUP BY year, month
    ORDER BY year DESC, month DESC;

    -- Average resolution time (in days)
    SELECT AVG(TIMESTAMPDIFF(DAY, REQUESTS.sent_at, REQUESTS.reviewed_at)) AS avg_resolution_days
    FROM CONVALIDATIONS
    JOIN REQUESTS ON CONVALIDATIONS.id_request = REQUESTS.id
    WHERE REQUESTS.reviewed_at IS NOT NULL;
END;

-- -----------------------------------------------------------------------------
-- 3. WORKSHOP STATISTICS
-- -----------------------------------------------------------------------------
CREATE PROCEDURE sp_get_dashboard_workshop_stats()
BEGIN
    -- Workshops by state
    SELECT WORKSHOP_STATES.name AS workshop_state, COUNT(*) AS total
    FROM WORKSHOPS
    JOIN WORKSHOP_STATES ON WORKSHOPS.id_workshop_state = WORKSHOP_STATES.id
    WHERE WORKSHOP_STATES.name IN ('EN_CURSO', 'FINALIZADO', 'INSCRIPCION', 'CERRADO', 'CANCELADO')
    GROUP BY WORKSHOP_STATES.name;
END;

-- -----------------------------------------------------------------------------
-- 4. STUDENT STATISTICS
-- -----------------------------------------------------------------------------
CREATE PROCEDURE sp_get_dashboard_student_stats()
BEGIN
    
    -- Students with most workshops
    SELECT STUDENTS.id AS id_student, USERS.first_names, USERS.last_names, COUNT(*) AS total_workshops
    FROM STUDENTS
    JOIN USERS ON STUDENTS.id = USERS.id
    JOIN WORKSHOPS_INSCRIPTIONS ON WORKSHOPS_INSCRIPTIONS.id_student = STUDENTS.id
    GROUP BY STUDENTS.id, USERS.first_names, USERS.last_names
    ORDER BY total_workshops DESC
    LIMIT 10;
END;

-- -----------------------------------------------------------------------------
-- 5. ACTIVITY STATISTICS
-- -----------------------------------------------------------------------------
CREATE PROCEDURE sp_get_dashboard_activity_stats()
BEGIN
    -- New requests in last week
    SELECT COUNT(*) AS requests_last_week
    FROM REQUESTS
    WHERE sent_at >= DATE_SUB(CURDATE(), INTERVAL 7 DAY);

    -- New requests in last month
    SELECT COUNT(*) AS requests_last_month
    FROM REQUESTS
    WHERE sent_at >= DATE_SUB(CURDATE(), INTERVAL 1 MONTH);

    -- Activity peaks by day (top 7 days)
    SELECT DATE(sent_at) AS day, COUNT(*) AS total
    FROM REQUESTS
    GROUP BY day
    ORDER BY total DESC
    LIMIT 7;
END;

-- =============================================================================
-- 11. WORKSHOPS_INSCRIPTIONS
-- =============================================================================

CREATE PROCEDURE sp_create_workshop_inscription(
    IN p_id_student INT,
    IN p_id_workshop INT,
    IN p_id_curriculum_course INT,
    IN p_is_convalidated TINYINT(1)
)
BEGIN
    START TRANSACTION;
    -- Validar existencia de estudiante y taller
    IF NOT EXISTS (SELECT 1 FROM STUDENTS WHERE id = p_id_student) THEN
        SIGNAL SQLSTATE '45002' SET MESSAGE_TEXT = 'El estudiante no existe';
    END IF;
    IF NOT EXISTS (SELECT 1 FROM WORKSHOPS WHERE id = p_id_workshop) THEN
        SIGNAL SQLSTATE '45002' SET MESSAGE_TEXT = 'El taller no existe';
    END IF;
    -- Validar que no exista inscripción previa
    IF EXISTS (SELECT 1 FROM WORKSHOPS_INSCRIPTIONS WHERE id_student = p_id_student AND id_workshop = p_id_workshop) THEN
        SIGNAL SQLSTATE '45002' SET MESSAGE_TEXT = 'La inscripción ya existe';
    END IF;
    -- Insertar inscripción
    INSERT INTO WORKSHOPS_INSCRIPTIONS (id_student, id_workshop, id_curriculum_course, is_convalidated)
    VALUES (p_id_student, p_id_workshop, p_id_curriculum_course, p_is_convalidated);
    COMMIT;
END//

-- =============================================================================
-- 12. WORKSHOPS_GRADES
-- =============================================================================

CREATE PROCEDURE sp_create_workshop_grade(
    IN p_id_workshop INT,
    IN p_id_student INT,
    IN p_grade INT
)
BEGIN
    START TRANSACTION;
    -- Validar existencia de inscripción
    IF NOT EXISTS (SELECT 1 FROM WORKSHOPS_INSCRIPTIONS WHERE id_student = p_id_student AND id_workshop = p_id_workshop) THEN
        SIGNAL SQLSTATE '45002' SET MESSAGE_TEXT = 'El estudiante no está inscrito en el taller';
    END IF;
    -- Validar que no exista calificación previa
    IF EXISTS (SELECT 1 FROM WORKSHOPS_GRADES WHERE id_student = p_id_student AND id_workshop = p_id_workshop) THEN
        SIGNAL SQLSTATE '45002' SET MESSAGE_TEXT = 'La calificación ya existe';
    END IF;
    -- Insertar calificación
    INSERT INTO WORKSHOPS_GRADES (id_student, id_workshop, grade)
    VALUES (p_id_student, p_id_workshop, p_grade);
    COMMIT;
END//

-- =============================================================================
-- PROCEDURES ESPECÍFICOS PARA LA API
-- =============================================================================

-- =============================================================================
-- 1. PROCEDURES DE ESTUDIANTES
-- =============================================================================

-- Obtener estudiantes para preview (listas)
DROP PROCEDURE IF EXISTS sp_get_students_preview;
DELIMITER //
CREATE PROCEDURE sp_get_students_preview()
BEGIN
    SELECT * FROM vw_students_preview;
END //
DELIMITER ;

-- Obtener estudiantes completos
DROP PROCEDURE IF EXISTS sp_get_students_complete;
DELIMITER //
CREATE PROCEDURE sp_get_students_complete()
BEGIN
    SELECT * FROM vw_students_essential;
END //
DELIMITER ;

-- Obtener estudiante por RUT
DROP PROCEDURE IF EXISTS sp_get_student_by_rut;
DELIMITER //
CREATE PROCEDURE sp_get_student_by_rut(IN p_rut VARCHAR(20))
BEGIN
    SELECT * FROM vw_students_essential WHERE rut_student = p_rut;
END //
DELIMITER ;

-- Obtener estudiante por nombre
DROP PROCEDURE IF EXISTS sp_get_student_by_name;
DELIMITER //
CREATE PROCEDURE sp_get_student_by_name(IN p_name VARCHAR(100))
BEGIN
    SELECT * FROM vw_students_essential WHERE name_student LIKE CONCAT('%', p_name, '%');
END //
DELIMITER ;

-- Obtener estudiante por rol
DROP PROCEDURE IF EXISTS sp_get_student_by_rol;
DELIMITER //
CREATE PROCEDURE sp_get_student_by_rol(IN p_rol VARCHAR(50))
BEGIN
    SELECT * FROM vw_students_essential WHERE rol_student = p_rol;
END //
DELIMITER ;

-- =============================================================================
-- 2. PROCEDURES DE ADMINISTRADORES
-- =============================================================================

-- Obtener administradores para preview
DROP PROCEDURE IF EXISTS sp_get_admins_preview;
DELIMITER //
CREATE PROCEDURE sp_get_admins_preview()
BEGIN
    SELECT * FROM vw_admins_preview;
END //
DELIMITER ;

-- Obtener administradores completos
DROP PROCEDURE IF EXISTS sp_get_admins_complete;
DELIMITER //
CREATE PROCEDURE sp_get_admins_complete()
BEGIN
    SELECT * FROM vw_admins_essential;
END //
DELIMITER ;

-- Obtener administrador por ID
DROP PROCEDURE IF EXISTS sp_get_admin_by_id;
DELIMITER //
CREATE PROCEDURE sp_get_admin_by_id(IN p_id INT)
BEGIN
    SELECT * FROM vw_admins_essential WHERE id_admin = p_id;
END //
DELIMITER ;

-- Obtener administradores por campus
DROP PROCEDURE IF EXISTS sp_get_admins_by_campus;
DELIMITER //
CREATE PROCEDURE sp_get_admins_by_campus(IN p_campus VARCHAR(50))
BEGIN
    SELECT * FROM vw_admins_essential WHERE campus_admin = p_campus;
END //
DELIMITER ;

-- Obtener administrador por email
DROP PROCEDURE IF EXISTS sp_get_admin_by_email;
DELIMITER //
CREATE PROCEDURE sp_get_admin_by_email(IN p_email VARCHAR(100))
BEGIN
    SELECT * FROM vw_admins_essential WHERE email_admin = p_email;
END //
DELIMITER ;

-- =============================================================================
-- 3. PROCEDURES DE TALLERES
-- =============================================================================

-- Obtener talleres para preview (listas)
DROP PROCEDURE IF EXISTS sp_get_workshops_preview;
DELIMITER //
CREATE PROCEDURE sp_get_workshops_preview()
BEGIN
    SELECT * FROM vw_workshops_preview;
END //
DELIMITER ;

-- Obtener talleres completos
DROP PROCEDURE IF EXISTS sp_get_workshops_complete;
DELIMITER //
CREATE PROCEDURE sp_get_workshops_complete()
BEGIN
    SELECT * FROM vw_workshops_complete;
END //
DELIMITER ;

-- Obtener taller por ID
DROP PROCEDURE IF EXISTS sp_get_workshop_by_id;
DELIMITER //
CREATE PROCEDURE sp_get_workshop_by_id(IN p_id INT)
BEGIN
    SELECT * FROM vw_workshops_complete WHERE id_workshop = p_id;
END //
DELIMITER ;

-- Obtener talleres por estado
DROP PROCEDURE IF EXISTS sp_get_workshops_by_state;
DELIMITER //
CREATE PROCEDURE sp_get_workshops_by_state(IN p_state_id INT)
BEGIN
    SELECT * FROM vw_workshops_complete WHERE id_workshop_state = p_state_id;
END //
DELIMITER ;

-- Obtener talleres por profesor
DROP PROCEDURE IF EXISTS sp_get_workshops_by_professor;
DELIMITER //
CREATE PROCEDURE sp_get_workshops_by_professor(IN p_professor VARCHAR(100))
BEGIN
    SELECT * FROM vw_workshops_complete WHERE professor_name LIKE CONCAT('%', p_professor, '%');
END //
DELIMITER ;

-- Buscar talleres
DROP PROCEDURE IF EXISTS sp_search_workshops;
DELIMITER //
CREATE PROCEDURE sp_search_workshops(IN p_search VARCHAR(100))
BEGIN
    SELECT * FROM vw_workshops_complete 
    WHERE workshop_name LIKE CONCAT('%', p_search, '%')
    OR professor_name LIKE CONCAT('%', p_search, '%')
    OR description LIKE CONCAT('%', p_search, '%');
END //
DELIMITER ;

-- =============================================================================
-- 4. PROCEDURES DE INSCRIPCIONES
-- =============================================================================

-- Obtener inscripciones para preview
DROP PROCEDURE IF EXISTS sp_get_workshop_inscriptions_preview;
DELIMITER //
CREATE PROCEDURE sp_get_workshop_inscriptions_preview()
BEGIN
    SELECT * FROM vw_workshop_inscriptions_preview;
END //
DELIMITER ;

-- Obtener inscripciones completas
DROP PROCEDURE IF EXISTS sp_get_workshop_inscriptions_complete;
DELIMITER //
CREATE PROCEDURE sp_get_workshop_inscriptions_complete()
BEGIN
    SELECT * FROM vw_workshop_inscriptions_complete;
END //
DELIMITER ;

-- Obtener inscripción por ID
DROP PROCEDURE IF EXISTS sp_get_workshop_inscription_by_id;
DELIMITER //
CREATE PROCEDURE sp_get_workshop_inscription_by_id(IN p_id INT)
BEGIN
    SELECT * FROM vw_workshop_inscriptions_complete WHERE id_inscription = p_id;
END //
DELIMITER ;

-- Obtener inscripciones por taller
DROP PROCEDURE IF EXISTS sp_get_workshop_inscriptions_by_workshop;
DELIMITER //
CREATE PROCEDURE sp_get_workshop_inscriptions_by_workshop(IN p_workshop_id INT)
BEGIN
    SELECT * FROM vw_workshop_inscriptions_complete WHERE id_workshop = p_workshop_id;
END //
DELIMITER ;

-- Obtener inscripciones por estudiante
DROP PROCEDURE IF EXISTS sp_get_workshop_inscriptions_by_student;
DELIMITER //
CREATE PROCEDURE sp_get_workshop_inscriptions_by_student(IN p_student_id INT)
BEGIN
    SELECT * FROM vw_workshop_inscriptions_complete WHERE id_student = p_student_id;
END //
DELIMITER ;

-- Obtener inscripciones por RUT de estudiante
DROP PROCEDURE IF EXISTS sp_get_workshop_inscriptions_by_student_rut;
DELIMITER //
CREATE PROCEDURE sp_get_workshop_inscriptions_by_student_rut(IN p_rut VARCHAR(20))
BEGIN
    SELECT * FROM vw_workshop_inscriptions_complete WHERE rut_student = p_rut;
END //
DELIMITER ;

-- Obtener inscripciones por nombre de estudiante
DROP PROCEDURE IF EXISTS sp_get_workshop_inscriptions_by_student_name;
DELIMITER //
CREATE PROCEDURE sp_get_workshop_inscriptions_by_student_name(IN p_name VARCHAR(100))
BEGIN
    SELECT * FROM vw_workshop_inscriptions_complete WHERE student_name LIKE CONCAT('%', p_name, '%');
END //
DELIMITER ;

-- Obtener inscripciones por rol de estudiante
DROP PROCEDURE IF EXISTS sp_get_workshop_inscriptions_by_student_rol;
DELIMITER //
CREATE PROCEDURE sp_get_workshop_inscriptions_by_student_rol(IN p_rol VARCHAR(50))
BEGIN
    SELECT * FROM vw_workshop_inscriptions_complete WHERE rol_student = p_rol;
END //
DELIMITER ;

-- Obtener inscripciones por curso curricular
DROP PROCEDURE IF EXISTS sp_get_workshop_inscriptions_by_curriculum_course;
DELIMITER //
CREATE PROCEDURE sp_get_workshop_inscriptions_by_curriculum_course(IN p_curriculum_course_id INT)
BEGIN
    SELECT * FROM vw_workshop_inscriptions_complete WHERE id_curriculum_course = p_curriculum_course_id;
END //
DELIMITER ;

-- =============================================================================
-- 5. PROCEDURES DE CALIFICACIONES
-- =============================================================================

-- Obtener calificaciones para preview
DROP PROCEDURE IF EXISTS sp_get_workshop_grades_preview;
DELIMITER //
CREATE PROCEDURE sp_get_workshop_grades_preview()
BEGIN
    SELECT * FROM vw_workshop_grades_preview;
END //
DELIMITER ;

-- Obtener calificaciones completas
DROP PROCEDURE IF EXISTS sp_get_workshop_grades_complete;
DELIMITER //
CREATE PROCEDURE sp_get_workshop_grades_complete()
BEGIN
    SELECT * FROM vw_workshop_grades_complete;
END //
DELIMITER ;

-- Obtener calificación por ID
DROP PROCEDURE IF EXISTS sp_get_workshop_grade_by_id;
DELIMITER //
CREATE PROCEDURE sp_get_workshop_grade_by_id(IN p_id INT)
BEGIN
    SELECT * FROM vw_workshop_grades_complete WHERE id_grade = p_id;
END //
DELIMITER ;

-- Obtener calificaciones por taller
DROP PROCEDURE IF EXISTS sp_get_workshop_grades_by_workshop;
DELIMITER //
CREATE PROCEDURE sp_get_workshop_grades_by_workshop(IN p_workshop_id INT)
BEGIN
    SELECT * FROM vw_workshop_grades_complete WHERE id_workshop = p_workshop_id;
END //
DELIMITER ;

-- Obtener calificaciones por estudiante
DROP PROCEDURE IF EXISTS sp_get_workshop_grades_by_student;
DELIMITER //
CREATE PROCEDURE sp_get_workshop_grades_by_student(IN p_student_id INT)
BEGIN
    SELECT * FROM vw_workshop_grades_complete WHERE id_student = p_student_id;
END //
DELIMITER ;

-- =============================================================================
-- 6. PROCEDURES DE CONVALIDACIONES
-- =============================================================================

-- Obtener convalidaciones para preview
DROP PROCEDURE IF EXISTS sp_get_convalidations_preview;
DELIMITER //
CREATE PROCEDURE sp_get_convalidations_preview()
BEGIN
    SELECT * FROM vw_convalidations_preview;
END //
DELIMITER ;

-- Obtener convalidaciones completas
DROP PROCEDURE IF EXISTS sp_get_convalidations_complete;
DELIMITER //
CREATE PROCEDURE sp_get_convalidations_complete()
BEGIN
    SELECT * FROM vw_convalidations_complete;
END //
DELIMITER ;

-- Obtener convalidación por ID
DROP PROCEDURE IF EXISTS sp_get_convalidation_by_id;
DELIMITER //
CREATE PROCEDURE sp_get_convalidation_by_id(IN p_id INT)
BEGIN
    SELECT * FROM vw_convalidations_complete WHERE id_convalidation = p_id;
END //
DELIMITER ;

-- Obtener convalidaciones pendientes
DROP PROCEDURE IF EXISTS sp_get_convalidations_pending;
DELIMITER //
CREATE PROCEDURE sp_get_convalidations_pending()
BEGIN
    SELECT * FROM vw_convalidations_complete WHERE id_convalidation_state = 1;
END //
DELIMITER ;

-- Obtener convalidaciones por estudiante
DROP PROCEDURE IF EXISTS sp_get_convalidations_by_student;
DELIMITER //
CREATE PROCEDURE sp_get_convalidations_by_student(IN p_student_id INT)
BEGIN
    SELECT * FROM vw_convalidations_complete WHERE id_student = p_student_id;
END //
DELIMITER ;

-- Obtener convalidaciones por RUT de estudiante
DROP PROCEDURE IF EXISTS sp_get_convalidations_by_student_rut;
DELIMITER //
CREATE PROCEDURE sp_get_convalidations_by_student_rut(IN p_rut VARCHAR(20))
BEGIN
    SELECT * FROM vw_convalidations_complete WHERE rut_student = p_rut;
END //
DELIMITER ;

-- Obtener convalidaciones por rol de estudiante
DROP PROCEDURE IF EXISTS sp_get_convalidations_by_student_rol;
DELIMITER //
CREATE PROCEDURE sp_get_convalidations_by_student_rol(IN p_rol VARCHAR(50))
BEGIN
    SELECT * FROM vw_convalidations_complete WHERE rol_student = p_rol;
END //
DELIMITER ;

-- Obtener convalidaciones por nombre de estudiante
DROP PROCEDURE IF EXISTS sp_get_convalidations_by_student_name;
DELIMITER //
CREATE PROCEDURE sp_get_convalidations_by_student_name(IN p_name VARCHAR(100))
BEGIN
    SELECT * FROM vw_convalidations_complete WHERE student_name LIKE CONCAT('%', p_name, '%');
END //
DELIMITER ;

-- Obtener convalidaciones por revisor
DROP PROCEDURE IF EXISTS sp_get_convalidations_by_reviewed_by;
DELIMITER //
CREATE PROCEDURE sp_get_convalidations_by_reviewed_by(IN p_reviewer_id INT)
BEGIN
    SELECT * FROM vw_convalidations_complete WHERE reviewer_id = p_reviewer_id;
END //
DELIMITER ;

-- Obtener convalidaciones por curso curricular
DROP PROCEDURE IF EXISTS sp_get_convalidations_by_curriculum_course;
DELIMITER //
CREATE PROCEDURE sp_get_convalidations_by_curriculum_course(IN p_curriculum_course_id INT)
BEGIN
    SELECT * FROM vw_convalidations_complete WHERE id_curriculum_course = p_curriculum_course_id;
END //
DELIMITER ;

-- Obtener convalidaciones por taller
DROP PROCEDURE IF EXISTS sp_get_convalidations_by_workshop;
DELIMITER //
CREATE PROCEDURE sp_get_convalidations_by_workshop(IN p_workshop_id INT)
BEGIN
    SELECT * FROM vw_convalidation_workshops WHERE id_workshop = p_workshop_id;
END //
DELIMITER ;

-- Obtener convalidaciones por actividad
DROP PROCEDURE IF EXISTS sp_get_convalidations_by_activity;
DELIMITER //
CREATE PROCEDURE sp_get_convalidations_by_activity(IN p_activity_id INT)
BEGIN
    SELECT * FROM vw_convalidation_external_activities WHERE id_convalidation = p_activity_id;
END //
DELIMITER ;

-- Obtener convalidaciones por tipo
DROP PROCEDURE IF EXISTS sp_get_convalidations_by_type;
DELIMITER //
CREATE PROCEDURE sp_get_convalidations_by_type(IN p_type_id INT)
BEGIN
    SELECT * FROM vw_convalidations_complete WHERE id_convalidation_type = p_type_id;
END //
DELIMITER ;

-- Obtener convalidaciones por estado
DROP PROCEDURE IF EXISTS sp_get_convalidations_by_state;
DELIMITER //
CREATE PROCEDURE sp_get_convalidations_by_state(IN p_state_id INT)
BEGIN
    SELECT * FROM vw_convalidations_complete WHERE id_convalidation_state = p_state_id;
END //
DELIMITER ;

-- Filtrar convalidaciones
DROP PROCEDURE IF EXISTS sp_filter_convalidations;
DELIMITER //
CREATE PROCEDURE sp_filter_convalidations(
    IN p_student_name VARCHAR(100),
    IN p_convalidation_type INT,
    IN p_convalidation_state INT,
    IN p_curriculum_course INT
)
BEGIN
    SELECT * FROM vw_convalidations_complete 
    WHERE (p_student_name IS NULL OR student_name LIKE CONCAT('%', p_student_name, '%'))
    AND (p_convalidation_type IS NULL OR id_convalidation_type = p_convalidation_type)
    AND (p_convalidation_state IS NULL OR id_convalidation_state = p_convalidation_state)
    AND (p_curriculum_course IS NULL OR id_curriculum_course = p_curriculum_course);
END //
DELIMITER ;

-- =============================================================================
-- 7. PROCEDURES DE NOTIFICACIONES
-- =============================================================================

-- Obtener notificaciones para preview
DROP PROCEDURE IF EXISTS sp_get_notifications_preview;
DELIMITER //
CREATE PROCEDURE sp_get_notifications_preview()
BEGIN
    SELECT * FROM vw_notifications_preview;
END //
DELIMITER ;

-- Obtener notificaciones completas
DROP PROCEDURE IF EXISTS sp_get_notifications_complete;
DELIMITER //
CREATE PROCEDURE sp_get_notifications_complete()
BEGIN
    SELECT * FROM vw_notifications_complete;
END //
DELIMITER ;

-- Obtener notificaciones por usuario
DROP PROCEDURE IF EXISTS sp_get_notifications_by_user;
DELIMITER //
CREATE PROCEDURE sp_get_notifications_by_user(IN p_user_id INT)
BEGIN
    SELECT * FROM vw_notifications_complete WHERE id_user = p_user_id;
END //
DELIMITER ;

-- Obtener notificaciones no leídas por usuario
DROP PROCEDURE IF EXISTS sp_get_notifications_not_read_by_user;
DELIMITER //
CREATE PROCEDURE sp_get_notifications_not_read_by_user(IN p_user_id INT)
BEGIN
    SELECT * FROM vw_notifications_complete WHERE id_user = p_user_id AND is_read = FALSE;
END //
DELIMITER ;

-- =============================================================================
-- 8. PROCEDURES DE CATÁLOGOS
-- =============================================================================

-- Obtener departamentos
DROP PROCEDURE IF EXISTS sp_get_departments;
DELIMITER //
CREATE PROCEDURE sp_get_departments()
BEGIN
    SELECT * FROM vw_departments;
END //
DELIMITER ;

-- Obtener asignaturas
DROP PROCEDURE IF EXISTS sp_get_subjects;
DELIMITER //
CREATE PROCEDURE sp_get_subjects()
BEGIN
    SELECT * FROM vw_subjects;
END //
DELIMITER ;

-- Obtener asignaturas por departamento
DROP PROCEDURE IF EXISTS sp_get_subjects_by_department;
DELIMITER //
CREATE PROCEDURE sp_get_subjects_by_department(IN p_department_id INT)
BEGIN
    SELECT * FROM vw_subjects WHERE id_department = p_department_id;
END //
DELIMITER ;

-- Obtener cursos curriculares
DROP PROCEDURE IF EXISTS sp_get_curriculum_courses;
DELIMITER //
CREATE PROCEDURE sp_get_curriculum_courses()
BEGIN
    SELECT * FROM vw_curriculum_courses;
END //
DELIMITER ;

-- Obtener cursos curriculares por tipo
DROP PROCEDURE IF EXISTS sp_get_curriculum_courses_by_type;
DELIMITER //
CREATE PROCEDURE sp_get_curriculum_courses_by_type(IN p_type_id INT)
BEGIN
    SELECT * FROM vw_curriculum_courses WHERE id_curriculum_course_type = p_type_id;
END //
DELIMITER ;

-- Obtener cursos curriculares no convalidados por estudiante
DROP PROCEDURE IF EXISTS sp_get_curriculum_courses_not_convalidated_by_student;
DELIMITER //
CREATE PROCEDURE sp_get_curriculum_courses_not_convalidated_by_student(IN p_student_id INT)
BEGIN
    SELECT * FROM vw_curriculum_courses 
    WHERE id NOT IN (
        SELECT id_curriculum_course FROM vw_convalidations_complete 
        WHERE id_student = p_student_id
    );
END //
DELIMITER ;

-- Obtener tipos de convalidación
DROP PROCEDURE IF EXISTS sp_get_convalidation_types;
DELIMITER //
CREATE PROCEDURE sp_get_convalidation_types()
BEGIN
    SELECT * FROM vw_convalidation_types;
END //
DELIMITER ;

-- Obtener estados de convalidación
DROP PROCEDURE IF EXISTS sp_get_convalidation_states;
DELIMITER //
CREATE PROCEDURE sp_get_convalidation_states()
BEGIN
    SELECT * FROM vw_convalidation_states;
END //
DELIMITER ;

-- Obtener estados de talleres
DROP PROCEDURE IF EXISTS sp_get_workshop_states;
DELIMITER //
CREATE PROCEDURE sp_get_workshop_states()
BEGIN
    SELECT * FROM vw_workshop_states;
END //
DELIMITER ;

-- Obtener tipos de cursos curriculares
DROP PROCEDURE IF EXISTS sp_get_curriculum_course_types;
DELIMITER //
CREATE PROCEDURE sp_get_curriculum_course_types()
BEGIN
    SELECT * FROM vw_curriculum_course_types;
END //
DELIMITER ;

-- =============================================================================
-- 9. PROCEDURES DE ESTADÍSTICAS
-- =============================================================================

-- Obtener estadísticas generales
DROP PROCEDURE IF EXISTS sp_get_stats_general;
DELIMITER //
CREATE PROCEDURE sp_get_stats_general()
BEGIN
    SELECT * FROM vw_stats_general;
END //
DELIMITER ;

-- Obtener estadísticas de talleres
DROP PROCEDURE IF EXISTS sp_get_stats_workshops;
DELIMITER //
CREATE PROCEDURE sp_get_stats_workshops()
BEGIN
    SELECT * FROM vw_stats_workshops;
END //
DELIMITER ;

-- Obtener estadísticas de convalidaciones
DROP PROCEDURE IF EXISTS sp_get_stats_convalidations;
DELIMITER //
CREATE PROCEDURE sp_get_stats_convalidations()
BEGIN
    SELECT * FROM vw_stats_convalidations;
END //
DELIMITER ;

-- =============================================================================
-- 10. PROCEDURES DE NUEVAS FUNCIONALIDADES
-- =============================================================================

-- Obtener tokens activos
DROP PROCEDURE IF EXISTS sp_get_workshop_tokens_active;
DELIMITER //
CREATE PROCEDURE sp_get_workshop_tokens_active()
BEGIN
    SELECT * FROM vw_workshop_tokens_active;
END //
DELIMITER ;

-- Obtener profesores activos
DROP PROCEDURE IF EXISTS sp_get_professors_active;
DELIMITER //
CREATE PROCEDURE sp_get_professors_active()
BEGIN
    SELECT * FROM vw_professors_active;
END //
DELIMITER ;

-- Obtener tokens expirados
DROP PROCEDURE IF EXISTS sp_get_workshop_tokens_expired;
DELIMITER //
CREATE PROCEDURE sp_get_workshop_tokens_expired()
BEGIN
    SELECT * FROM vw_workshop_tokens_expired;
END //
DELIMITER ;

SELECT "Procedures específicos completos creados correctamente" AS mensaje;