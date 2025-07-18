--------------------------------------------------------------------------------------------------------
---------------------------------- PROCEDIMIENTOS ALMACENADOS ------------------------------------------
--------------------------------------------------------------------------------------------------------

-- =============================================================================
-- TABLA: CONVALIDATIONS (y vistas relacionadas)
-- =============================================================================

-- get_convalidations: Devuelve convalidaciones filtrando por id, estudiante, solicitud, tipo, estado y curso del currículum
DELIMITER $$
CREATE PROCEDURE get_convalidations(
    IN p_id_convalidation INT,
    IN p_id_student INT,
    IN p_id_request INT,
    IN p_id_convalidation_type INT,
    IN p_id_convalidation_state INT,
    IN p_id_curriculum_course INT
)
BEGIN
    SELECT *
    FROM vw_convalidations_full
    WHERE (p_id_convalidation IS NULL OR id_convalidation = p_id_convalidation)
      AND (p_id_student IS NULL OR id_student = p_id_student)
      AND (p_id_request IS NULL OR id_request = p_id_request)
      AND (p_id_convalidation_type IS NULL OR id_convalidation_type = p_id_convalidation_type)
      AND (p_id_convalidation_state IS NULL OR id_convalidation_state = p_id_convalidation_state)
      AND (p_id_curriculum_course IS NULL OR id_curriculum_course = p_id_curriculum_course);
END $$
DELIMITER ;

-- =============================================================================
-- PROCEDIMIENTO: get_convalidation_detail_by_id
-- Descripción: Dado un id de convalidación, retorna el detalle correspondiente desde la vista hija adecuada.
-- No requiere mapeo por tipo, ya que la relación es 1 a 1 y el id es único en las tablas hijas.
-- Parámetro: p_id_convalidation (INT) - id de la convalidación general
-- =============================================================================
DELIMITER $$
CREATE PROCEDURE get_convalidation_detail_by_id(
    IN p_id_convalidation INT
)
BEGIN
    SELECT * FROM vw_convalidation_subjects_full WHERE id_convalidation = p_id_convalidation
    UNION ALL
    SELECT * FROM vw_convalidation_workshops_full WHERE id_convalidation = p_id_convalidation
    UNION ALL
    SELECT * FROM vw_convalidation_certificated_courses_full WHERE id_convalidation = p_id_convalidation
    UNION ALL
    SELECT * FROM vw_convalidation_personal_projects_full WHERE id_convalidation = p_id_convalidation;
END $$
DELIMITER ;

-- =============================================================================
-- PROCEDIMIENTO: set_convalidation_state
-- Descripción: Actualiza el estado de una convalidación al id de estado especificado, si existe en la tabla de estados.
-- Parámetros: p_id_convalidation (INT), p_new_state_id (INT)
-- =============================================================================
DELIMITER $$
CREATE PROCEDURE set_convalidation_state(
    IN p_id_convalidation INT,
    IN p_new_state_id INT
)
BEGIN
    -- Verificar que el estado existe
    IF EXISTS (SELECT 1 FROM CONVALIDATION_STATES WHERE id = p_new_state_id) THEN
        UPDATE CONVALIDATIONS
        SET id_convalidation_state = p_new_state_id
        WHERE id = p_id_convalidation;
    ELSE
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El estado especificado no existe';
    END IF;
END $$
DELIMITER ;


-- =============================================================================
-- PROCEDIMIENTO: set_convalidation_review_comment
-- Descripción: Actualiza el comentario de revisión de una convalidación específica.
-- Parámetros: p_id_convalidation (INT), p_review_comment (TEXT)
-- =============================================================================
DELIMITER $$
CREATE PROCEDURE set_convalidation_review_comment(
    IN p_id_convalidation INT,
    IN p_review_comment TEXT
)
BEGIN
    UPDATE CONVALIDATIONS
    SET review_comments = p_review_comment
    WHERE id = p_id_convalidation;
END $$
DELIMITER ;


-- =============================================================================
-- PROCEDIMIENTO: create_convalidation
-- Descripción: Crea una nueva convalidación con los datos mínimos requeridos.
-- Parámetros:
--   p_id_request (INT) - ID de la solicitud asociada
--   p_id_convalidation_type (INT) - Tipo de convalidación
--   p_id_convalidation_state (INT) - Estado inicial de la convalidación
--   p_id_curriculum_course (INT) - Curso del currículum asociado
--   p_review_comments (TEXT) - Comentario de revisión inicial (opcional)
-- Devuelve: El ID de la nueva convalidación (OUT p_new_id)
-- =============================================================================
DELIMITER $$
CREATE PROCEDURE create_convalidation(
    IN p_id_request INT,
    IN p_id_convalidation_type INT,
    IN p_id_convalidation_state INT,
    IN p_id_curriculum_course INT,
    IN p_review_comments TEXT,
    OUT p_new_id INT
)
BEGIN
    INSERT INTO CONVALIDATIONS (
        id_request,
        id_convalidation_type,
        id_convalidation_state,
        id_curriculum_course,
        review_comments
    ) VALUES (
        p_id_request,
        p_id_convalidation_type,
        p_id_convalidation_state,
        p_id_curriculum_course,
        p_review_comments
    );
    SET p_new_id = LAST_INSERT_ID();
END $$
DELIMITER ;

-- =============================================================================
-- PROCEDIMIENTO: create_convalidation_subject
-- Descripción: Crea una convalidación de asignatura asociando una convalidación existente con una asignatura.
-- Parámetros:
--   p_id_convalidation (INT) - ID de la convalidación existente
--   p_id_subject (INT) - ID de la asignatura a asociar
-- =============================================================================
DELIMITER $$
CREATE PROCEDURE create_convalidation_subject(
    IN p_id_convalidation INT,
    IN p_id_subject INT
)
BEGIN
    INSERT INTO CONVALIDATIONS_SUBJECTS (
        id_convalidation,
        id_subject
    ) VALUES (
        p_id_convalidation,
        p_id_subject
    );
END $$
DELIMITER ;

-- =============================================================================
-- PROCEDIMIENTO: create_convalidation_workshop
-- Descripción: Crea una convalidación de taller asociando una convalidación existente con un taller.
-- Parámetros:
--   p_id_convalidation (INT) - ID de la convalidación existente
--   p_id_workshop (INT) - ID del taller a asociar
-- =============================================================================
DELIMITER $$
CREATE PROCEDURE create_convalidation_workshop(
    IN p_id_convalidation INT,
    IN p_id_workshop INT
)
BEGIN
    INSERT INTO CONVALIDATIONS_WORKSHOPS (
        id_convalidation,
        id_workshop
    ) VALUES (
        p_id_convalidation,
        p_id_workshop
    );
END $$
DELIMITER ;

-- =============================================================================
-- PROCEDIMIENTO: create_convalidation_certificated_course
-- Descripción: Crea una convalidación de curso certificado asociando una convalidación existente con los datos del curso certificado.
-- Parámetros:
--   p_id_convalidation (INT) - ID de la convalidación existente
--   p_name (VARCHAR(255)) - Nombre del curso certificado
--   p_file_data (LONGBLOB) - Archivo adjunto (puede ser NULL)
--   p_file_name (VARCHAR(255)) - Nombre del archivo adjunto (puede ser NULL)
-- =============================================================================
DELIMITER $$
CREATE PROCEDURE create_convalidation_certificated_course(
    IN p_id_convalidation INT,
    IN p_name VARCHAR(255),
    IN p_file_data LONGBLOB,
    IN p_file_name VARCHAR(255)
)
BEGIN
    INSERT INTO CONVALIDATIONS_CERTIFICATED_COURSES (
        id_convalidation,
        name,
        file_data,
        file_name
    ) VALUES (
        p_id_convalidation,
        p_name,
        p_file_data,
        p_file_name
    );
END $$
DELIMITER ;

-- =============================================================================
-- PROCEDIMIENTO: create_convalidation_personal_project
-- Descripción: Crea una convalidación de proyecto personal asociando una convalidación existente con los datos del proyecto personal.
-- Parámetros:
--   p_id_convalidation (INT) - ID de la convalidación existente
--   p_name (VARCHAR(255)) - Nombre del proyecto personal
--   p_file_data (LONGBLOB) - Archivo adjunto (puede ser NULL)
--   p_file_name (VARCHAR(255)) - Nombre del archivo adjunto (puede ser NULL)
-- =============================================================================
DELIMITER $$
CREATE PROCEDURE create_convalidation_personal_project(
    IN p_id_convalidation INT,
    IN p_name VARCHAR(255),
    IN p_file_data LONGBLOB,
    IN p_file_name VARCHAR(255)
)
BEGIN
    INSERT INTO CONVALIDATIONS_PERSONAL_PROJECTS (
        id_convalidation,
        name,
        file_data,
        file_name
    ) VALUES (
        p_id_convalidation,
        p_name,
        p_file_data,
        p_file_name
    );
END $$
DELIMITER;

-- =============================================================================
-- PROCEDIMIENTO: delete_convalidation
-- Descripción: Elimina una convalidación y sus registros asociados en tablas hijas.
-- Parámetros:
--   p_id_convalidation (INT) - ID de la convalidación a eliminar
-- =============================================================================
DELIMITER $$
CREATE PROCEDURE delete_convalidation(
    IN p_id_convalidation INT
)
BEGIN
    DELETE FROM CONVALIDATIONS_SUBJECTS
    WHERE id_convalidation = p_id_convalidation;

    DELETE FROM CONVALIDATIONS_WORKSHOPS
    WHERE id_convalidation = p_id_convalidation;

    DELETE FROM CONVALIDATIONS_CERTIFICATED_COURSES
    WHERE id_convalidation = p_id_convalidation;

    DELETE FROM CONVALIDATIONS_PERSONAL_PROJECTS
    WHERE id_convalidation = p_id_convalidation;

    DELETE FROM CONVALIDATIONS
    WHERE id = p_id_convalidation;
END $$
DELIMITER ;



-- =============================================================================
-- PROCEDIMIENTO: review_convalidation
-- Descripción: Actualiza el estado y el comentario de revisión de una convalidación específica usando los procedures existentes.
-- Parámetros: p_id_convalidation (INT), p_new_state_id (INT), p_review_comment (TEXT)
-- =============================================================================
DELIMITER $$
CREATE PROCEDURE review_convalidation(
    IN p_id_convalidation INT,
    IN p_new_state_id INT,
    IN p_review_comment TEXT
)
BEGIN

    CALL set_convalidation_state(p_id_convalidation, p_new_state_id);
    CALL set_convalidation_review_comment(p_id_convalidation, p_review_comment);
END $$
DELIMITER ;

-- =============================================================================
-- TABLA: REQUESTS (y vistas relacionadas)
-- =============================================================================

-- get_requests: Devuelve solicitudes de convalidación filtrando por id, estudiante, revisor, estado y fechas
DELIMITER $$
CREATE PROCEDURE get_requests(
    IN p_id_request INT,
    IN p_id_student INT,
    IN p_id_admin_reviewer INT,
    IN p_id_convalidation_state INT,
    IN p_sent_at_from DATETIME,
    IN p_sent_at_to DATETIME
)
BEGIN
    SELECT *
    FROM vw_requests_full
    WHERE (p_id_request IS NULL OR id_request = p_id_request)
      AND (p_id_student IS NULL OR id_student = p_id_student)
      AND (p_id_admin_reviewer IS NULL OR id_admin_reviewer = p_id_admin_reviewer)
      AND (p_id_convalidation_state IS NULL OR id_convalidation_state = p_id_convalidation_state)
      AND (p_sent_at_from IS NULL OR sent_at >= p_sent_at_from)
      AND (p_sent_at_to IS NULL OR sent_at <= p_sent_at_to);
END $$
DELIMITER ;

-- =============================================================================
-- PROCEDIMIENTO: review_request
-- Descripción: Actualiza el revisor, la fecha de revisión y el estado de todas las convalidaciones asociadas a una solicitud.
-- Parámetros: p_id_request (INT), p_id_admin_reviewer (INT), p_new_state_id (INT)
-- =============================================================================
DELIMITER $$

CREATE PROCEDURE review_request(
    IN p_id_request INT,
    IN p_id_reviewed_by INT,
)
BEGIN
    UPDATE REQUESTS
    SET id_reviewed_by = p_id_reviewed_by,
        reviewed_at = CURRENT_TIMESTAMP
    WHERE id = p_id_request;
END $$
DELIMITER ;



-- =============================================================================
-- TABLA: STUDENTS (y vistas relacionadas)
-- =============================================================================

-- get_students: Devuelve estudiantes filtrando por id, rol, RUT, campus y departamento
DELIMITER $$
CREATE PROCEDURE get_students(
    IN p_id_student INT,
    IN p_rol_student VARCHAR(255),
    IN p_rut_student VARCHAR(255),
    IN p_campus_student VARCHAR(255),
    IN p_id_department INT
)
BEGIN
    SELECT *
    FROM vw_students
    WHERE (p_id_student IS NULL OR id_student = p_id_student)
      AND (p_rol_student IS NULL OR rol_student = p_rol_student)
      AND (p_rut_student IS NULL OR rut_student = p_rut_student)
      AND (p_campus_student IS NULL OR campus_student = p_campus_student);

END $$
DELIMITER ;


-- =============================================================================
-- TABLA: WORKSHOPS (y vistas relacionadas)
-- =============================================================================

-- get_workshops: Devuelve talleres filtrando por id, nombre, año, semestre, profesor, estado y disponibilidad
DELIMITER $$
CREATE PROCEDURE get_workshops(
    IN p_id_workshop INT,
    IN p_name VARCHAR(255),
    IN p_year INT,
    IN p_semester VARCHAR(2),
    IN p_professor VARCHAR(255),
    IN p_id_workshop_state INT,
    IN p_available TINYINT
)
BEGIN
    SELECT *
    FROM vw_workshops
    WHERE (p_id_workshop IS NULL OR id_workshop = p_id_workshop)
      AND (p_name IS NULL OR workshop LIKE CONCAT('%', p_name, '%'))
      AND (p_year IS NULL OR year = p_year)
      AND (p_semester IS NULL OR semester = p_semester)
      AND (p_professor IS NULL OR professor LIKE CONCAT('%', p_professor, '%'))
      AND (p_id_workshop_state IS NULL OR id_workshop_state = p_id_workshop_state)
      AND (p_available IS NULL OR available = p_available);
END $$

DELIMITER ;

-- =============================================================================
-- PROCEDIMIENTO: set_workshop_state
-- Descripción: Actualiza el estado de un taller al id de estado especificado, si existe en la tabla de estados.
-- Parámetros: p_id_workshop (INT), p_new_state_id (INT)
-- =============================================================================
DELIMITER $$
CREATE PROCEDURE set_workshop_state(
    IN p_id_workshop INT,
    IN p_new_state_id INT
)
BEGIN
    UPDATE WORKSHOPS
    SET id_workshop_state = p_new_state_id
    WHERE id = p_id_workshop;
END $$
DELIMITER ;
-- =============================================================================
-- PROCEDIMIENTO: set_workshop_available
-- Descripción: Actualiza el campo available de un taller según su id.
-- Parámetro: p_id_workshop (INT), p_available (TINYINT)
-- =============================================================================
DELIMITER $$
CREATE PROCEDURE set_workshop_available(
    IN p_id_workshop INT,
    IN p_available TINYINT
)
BEGIN
    UPDATE WORKSHOPS
    SET available = p_available
    WHERE id = p_id_workshop;
END $$
DELIMITER ;

-- =============================================================================
-- PROCEDIMIENTO: enroll_student_in_workshop
-- Descripción: Inscribe a un estudiante en un taller, registrando el curso del currículum asociado.
-- Parámetros: p_id_student (INT), p_id_workshop (INT), p_id_curriculum_course (INT)
-- =============================================================================
DELIMITER $$
CREATE PROCEDURE enroll_student_in_workshop(
    IN p_id_student INT,
    IN p_id_workshop INT,
    IN p_id_curriculum_course INT
)
BEGIN
    INSERT INTO WORKSHOPS_INSCRIPTIONS (
        id_student,
        id_workshop,
        id_curriculum_course,
        inscription_date,
        is_convalidated
    ) VALUES (
        p_id_student,
        p_id_workshop,
        p_id_curriculum_course,
        NOW(),
        0
    );
END $$
DELIMITER ;

-- =============================================================================
-- PROCEDIMIENTO: unenroll_student_from_workshop
-- Descripción: Elimina la inscripción de un estudiante de un taller.
-- Parámetros: p_id_student (INT), p_id_workshop (INT)
-- =============================================================================
DELIMITER $$
CREATE PROCEDURE unenroll_student_from_workshop(
    IN p_id_student INT,
    IN p_id_workshop INT
)
BEGIN
    DELETE FROM WORKSHOPS_INSCRIPTIONS
    WHERE id_student = p_id_student
      AND id_workshop = p_id_workshop;
END $$
DELIMITER ;









-- =============================================================================
-- TABLA: WORKSHOPS_INSCRIPTIONS
-- =============================================================================

-- get_workshops_inscriptions: Devuelve inscripciones a talleres filtrando por estudiante, taller, curso e indicador de convalidación
DELIMITER $$
CREATE PROCEDURE get_workshops_inscriptions(
    IN p_id_student INT,
    IN p_id_workshop INT,
    IN p_id_curriculum_course INT,
    IN p_is_convalidated TINYINT
)
BEGIN
    SELECT *
    FROM vw_workshops_inscriptions
    WHERE (p_id_student IS NULL OR id_student = p_id_student)
      AND (p_id_workshop IS NULL OR id_workshop = p_id_workshop)
      AND (p_id_curriculum_course IS NULL OR id_curriculum_course = p_id_curriculum_course)
      AND (p_is_convalidated IS NULL OR is_convalidated = p_is_convalidated);
END $$
DELIMITER ;


-- =============================================================================
-- TABLA: AUDIT_LOG (y vistas relacionadas)
-- =============================================================================

-- get_audit_log: Devuelve el log de auditoría filtrando por id, usuario, acción, tabla, registro y fechas
DELIMITER $$
CREATE PROCEDURE get_audit_log(
    IN p_id INT,
    IN p_id_auth_user INT,
    IN p_id_audit_action INT,
    IN p_id_audit_table INT,
    IN p_id_record INT,
    IN p_timestamp_from DATETIME,
    IN p_timestamp_to DATETIME
)
BEGIN
    SELECT *
    FROM vw_audit_log
    WHERE (p_id IS NULL OR id = p_id)
      AND (p_id_auth_user IS NULL OR id_auth_user = p_id_auth_user)
      AND (p_id_audit_action IS NULL OR id_audit_action = p_id_audit_action)
      AND (p_id_audit_table IS NULL OR id_audit_table = p_id_audit_table)
      AND (p_id_record IS NULL OR id_record = p_id_record)
      AND (p_timestamp_from IS NULL OR timestamp >= p_timestamp_from)
      AND (p_timestamp_to IS NULL OR timestamp <= p_timestamp_to);
END $$
DELIMITER ;

-- =============================================================================
-- TABLA: NOTIFICATIONS (y vistas relacionadas)
-- =============================================================================

-- get_notifications: Devuelve notificaciones filtrando por usuario y estado de lectura
DELIMITER $$
CREATE PROCEDURE get_notifications(
    IN p_id_auth_user INT,
    IN p_is_read TINYINT
)
BEGIN
    SELECT *
    FROM vw_notifications_user
    WHERE (p_id_auth_user IS NULL OR id_auth_user = p_id_auth_user)
      AND (p_is_read IS NULL OR is_read = p_is_read);
END $$
DELIMITER ;

-- =============================================================================
-- TABLA: ADMINISTRATORS (y vistas relacionadas)
-- =============================================================================

-- get_admins: Devuelve administradores filtrando por departamento
DELIMITER $$
CREATE PROCEDURE get_admins(
    IN p_id_department INT
)
BEGIN
    SELECT *
    FROM vw_admins
    -- Agrega filtro por departamento si la vista lo incluye
    WHERE (p_id_department IS NULL OR id_department = p_id_department);
END $$
DELIMITER ;

-- =============================================================================
-- TABLA: SUBJECTS (y vistas relacionadas)
-- =============================================================================

-- get_subjects: Devuelve asignaturas filtrando por departamento
DELIMITER $$
CREATE PROCEDURE get_subjects(
    IN p_id_department INT
)
BEGIN
    SELECT *
    FROM vw_subjects
    WHERE (p_id_department IS NULL OR id_department = p_id_department);
END $$
DELIMITER ;

-- =============================================================================
-- TABLA: CURRICULUM_COURSES (y vistas relacionadas)
-- =============================================================================

-- get_curriculum_courses: Devuelve cursos del currículum filtrando por tipo
DELIMITER $$
CREATE PROCEDURE get_curriculum_courses(
    IN p_id_curriculum_course_type INT
)
BEGIN
    SELECT *
    FROM vw_curriculum_courses
    WHERE (p_id_curriculum_course_type IS NULL OR id_curriculum_course_type = p_id_curriculum_course_type);
END $$
DELIMITER ;

-- =============================================================================
-- ESTADÍSTICAS DE SOLICITUDES Y CONVALIDACIONES
-- =============================================================================

-- =============================================================================
-- Estadística: Total de solicitudes realizadas por un estudiante
-- =============================================================================
DELIMITER $$
CREATE PROCEDURE stats_total_requests_by_student(IN p_id_student INT)
BEGIN
    SELECT COUNT(*) AS total_requests
    FROM REQUESTS
    WHERE id_student = p_id_student;
END $$
DELIMITER ;

-- =============================================================================
-- Estadística: Total de convalidaciones realizadas por un estudiante
-- =============================================================================
DELIMITER $$
CREATE PROCEDURE stats_total_convalidations_by_student(IN p_id_student INT)
BEGIN
    SELECT COUNT(*) AS total_convalidations
    FROM CONVALIDATIONS
    JOIN REQUESTS ON CONVALIDATIONS.id_request = REQUESTS.id
    WHERE REQUESTS.id_student = p_id_student;
END $$
DELIMITER ;

-- =============================================================================
-- Estadística: Promedio de convalidaciones por solicitud
-- =============================================================================
DELIMITER $$
CREATE PROCEDURE stats_avg_convalidations_per_request()
BEGIN
    SELECT AVG(convalidations_count) AS avg_convalidations_per_request
    FROM (
        SELECT COUNT(*) AS convalidations_count
        FROM CONVALIDATIONS
        GROUP BY id_request
    ) AS sub;
END $$
DELIMITER ;

-- =============================================================================
-- Estadística: Convalidaciones por tipo dentro de una solicitud
-- =============================================================================
DELIMITER $$
CREATE PROCEDURE stats_convalidations_by_type_in_request(IN p_id_request INT)
BEGIN
    SELECT
        CONVALIDATION_TYPES.name AS convalidation_type,
        COUNT(*) AS total
    FROM CONVALIDATIONS
    JOIN CONVALIDATION_TYPES ON CONVALIDATIONS.id_convalidation_type = CONVALIDATION_TYPES.id
    WHERE CONVALIDATIONS.id_request = p_id_request
    GROUP BY CONVALIDATION_TYPES.name;
END $$
DELIMITER ;

-- =============================================================================
-- Estadística: Detalle de todas las convalidaciones de una solicitud
-- =============================================================================
DELIMITER $$
CREATE PROCEDURE get_convalidations_detail_by_request(IN p_id_request INT)
BEGIN
    SELECT * FROM vw_convalidation_subjects_full WHERE id_request = p_id_request
    UNION ALL
    SELECT * FROM vw_convalidation_workshops_full WHERE id_request = p_id_request
    UNION ALL
    SELECT * FROM vw_convalidation_certificated_courses_full WHERE id_request = p_id_request
    UNION ALL
    SELECT * FROM vw_convalidation_personal_projects_full WHERE id_request = p_id_request;
END $$
DELIMITER ;

-- =============================================================================
-- PROCEDIMIENTOS ESPECÍFICOS DE NEGOCIO (Opcionales y recomendados)
-- =============================================================================

-- =============================================================================
-- PROCEDIMIENTO: approve_all_convalidations_by_request
-- Descripción: Cambia el estado de todas las convalidaciones de una solicitud a un estado final (ej: APROBADA_DE).
-- Parámetros: p_id_request (INT), p_new_state_id (INT)
-- =============================================================================
DELIMITER $$
CREATE PROCEDURE approve_all_convalidations_by_request(
    IN p_id_request INT,
    IN p_new_state_id INT
)
BEGIN
    UPDATE CONVALIDATIONS
    SET id_convalidation_state = p_new_state_id
    WHERE id_request = p_id_request;
END $$
DELIMITER ;

-- =============================================================================
-- PROCEDIMIENTO: reject_all_convalidations_by_request
-- Descripción: Cambia el estado de todas las convalidaciones de una solicitud a un estado final de rechazo (ej: RECHAZADA_DE).
-- Parámetros: p_id_request (INT), p_new_state_id (INT)
-- =============================================================================
DELIMITER $$
CREATE PROCEDURE reject_all_convalidations_by_request(
    IN p_id_request INT,
    IN p_new_state_id INT
)
BEGIN
    UPDATE CONVALIDATIONS
    SET id_convalidation_state = p_new_state_id
    WHERE id_request = p_id_request;
END $$
DELIMITER ;

-- =============================================================================
-- CRUD PARA TABLAS DE CATÁLOGOS
-- =============================================================================

-- =====================
-- CONVALIDATION_TYPES
-- =====================
-- CREATE
DELIMITER $$
CREATE PROCEDURE create_convalidation_type(IN p_name VARCHAR(255))
BEGIN
    INSERT INTO CONVALIDATION_TYPES (name) VALUES (p_name);
END $$
DELIMITER ;
-- READ
DELIMITER $$
CREATE PROCEDURE get_convalidation_types()
BEGIN
    SELECT * FROM CONVALIDATION_TYPES;
END $$
DELIMITER ;
-- UPDATE
DELIMITER $$
CREATE PROCEDURE update_convalidation_type(IN p_id INT, IN p_name VARCHAR(255))
BEGIN
    UPDATE CONVALIDATION_TYPES SET name = p_name WHERE id = p_id;
END $$
DELIMITER ;
-- DELETE
DELIMITER $$
CREATE PROCEDURE delete_convalidation_type(IN p_id INT)
BEGIN
    DELETE FROM CONVALIDATION_TYPES WHERE id = p_id;
END $$
DELIMITER ;

-- =====================
-- CURRICULUM_COURSES_TYPES
-- =====================
DELIMITER $$
CREATE PROCEDURE create_curriculum_course_type(IN p_name VARCHAR(255))
BEGIN
    INSERT INTO CURRICULUM_COURSES_TYPES (name) VALUES (p_name);
END $$
DELIMITER ;
DELIMITER $$
CREATE PROCEDURE get_curriculum_course_types()
BEGIN
    SELECT * FROM CURRICULUM_COURSES_TYPES;
END $$
DELIMITER ;
DELIMITER $$
CREATE PROCEDURE update_curriculum_course_type(IN p_id INT, IN p_name VARCHAR(255))
BEGIN
    UPDATE CURRICULUM_COURSES_TYPES SET name = p_name WHERE id = p_id;
END $$
DELIMITER ;
DELIMITER $$
CREATE PROCEDURE delete_curriculum_course_type(IN p_id INT)
BEGIN
    DELETE FROM CURRICULUM_COURSES_TYPES WHERE id = p_id;
END $$
DELIMITER ;

-- =====================
-- WORKSHOP_STATES
-- =====================
DELIMITER $$
CREATE PROCEDURE create_workshop_state(IN p_name VARCHAR(255), IN p_description TEXT, IN p_is_active TINYINT)
BEGIN
    INSERT INTO WORKSHOP_STATES (name, description, is_active) VALUES (p_name, p_description, p_is_active);
END $$
DELIMITER ;
DELIMITER $$
CREATE PROCEDURE get_workshop_states()
BEGIN
    SELECT * FROM WORKSHOP_STATES;
END $$
DELIMITER ;
DELIMITER $$
CREATE PROCEDURE update_workshop_state(IN p_id INT, IN p_name VARCHAR(255), IN p_description TEXT, IN p_is_active TINYINT)
BEGIN
    UPDATE WORKSHOP_STATES SET name = p_name, description = p_description, is_active = p_is_active WHERE id = p_id;
END $$
DELIMITER ;
DELIMITER $$
CREATE PROCEDURE delete_workshop_state(IN p_id INT)
BEGIN
    DELETE FROM WORKSHOP_STATES WHERE id = p_id;
END $$
DELIMITER ;

-- =====================
-- CONVALIDATION_STATES
-- =====================
DELIMITER $$
CREATE PROCEDURE create_convalidation_state(IN p_name VARCHAR(255), IN p_description TEXT, IN p_is_active TINYINT)
BEGIN
    INSERT INTO CONVALIDATION_STATES (name, description, is_active) VALUES (p_name, p_description, p_is_active);
END $$
DELIMITER ;
DELIMITER $$
CREATE PROCEDURE get_convalidation_states()
BEGIN
    SELECT * FROM CONVALIDATION_STATES;
END $$
DELIMITER ;
DELIMITER $$
CREATE PROCEDURE update_convalidation_state(IN p_id INT, IN p_name VARCHAR(255), IN p_description TEXT, IN p_is_active TINYINT)
BEGIN
    UPDATE CONVALIDATION_STATES SET name = p_name, description = p_description, is_active = p_is_active WHERE id = p_id;
END $$
DELIMITER ;
DELIMITER $$
CREATE PROCEDURE delete_convalidation_state(IN p_id INT)
BEGIN
    DELETE FROM CONVALIDATION_STATES WHERE id = p_id;
END $$
DELIMITER ;

-- =====================
-- AUDIT_ACTIONS
-- =====================
DELIMITER $$
CREATE PROCEDURE create_audit_action(IN p_name VARCHAR(255), IN p_description TEXT)
BEGIN
    INSERT INTO AUDIT_ACTIONS (name, description) VALUES (p_name, p_description);
END $$
DELIMITER ;
DELIMITER $$
CREATE PROCEDURE get_audit_actions()
BEGIN
    SELECT * FROM AUDIT_ACTIONS;
END $$
DELIMITER ;
DELIMITER $$
CREATE PROCEDURE update_audit_action(IN p_id INT, IN p_name VARCHAR(255), IN p_description TEXT)
BEGIN
    UPDATE AUDIT_ACTIONS SET name = p_name, description = p_description WHERE id = p_id;
END $$
DELIMITER ;
DELIMITER $$
CREATE PROCEDURE delete_audit_action(IN p_id INT)
BEGIN
    DELETE FROM AUDIT_ACTIONS WHERE id = p_id;
END $$
DELIMITER ;

-- =====================
-- AUDIT_FIELDS
-- =====================
DELIMITER $$
CREATE PROCEDURE create_audit_field(IN p_name VARCHAR(255), IN p_description TEXT)
BEGIN
    INSERT INTO AUDIT_FIELDS (name, description) VALUES (p_name, p_description);
END $$
DELIMITER ;
DELIMITER $$
CREATE PROCEDURE get_audit_fields()
BEGIN
    SELECT * FROM AUDIT_FIELDS;
END $$
DELIMITER ;
DELIMITER $$
CREATE PROCEDURE update_audit_field(IN p_id INT, IN p_name VARCHAR(255), IN p_description TEXT)
BEGIN
    UPDATE AUDIT_FIELDS SET name = p_name, description = p_description WHERE id = p_id;
END $$
DELIMITER ;
DELIMITER $$
CREATE PROCEDURE delete_audit_field(IN p_id INT)
BEGIN
    DELETE FROM AUDIT_FIELDS WHERE id = p_id;
END $$
DELIMITER ;

-- =====================
-- NOTIFICATION_TYPES
-- =====================
DELIMITER $$
CREATE PROCEDURE create_notification_type(IN p_name VARCHAR(255), IN p_description TEXT, IN p_is_active TINYINT)
BEGIN
    INSERT INTO NOTIFICATION_TYPES (name, description, is_active) VALUES (p_name, p_description, p_is_active);
END $$
DELIMITER ;
DELIMITER $$
CREATE PROCEDURE get_notification_types()
BEGIN
    SELECT * FROM NOTIFICATION_TYPES;
END $$
DELIMITER ;
DELIMITER $$
CREATE PROCEDURE update_notification_type(IN p_id INT, IN p_name VARCHAR(255), IN p_description TEXT, IN p_is_active TINYINT)
BEGIN
    UPDATE NOTIFICATION_TYPES SET name = p_name, description = p_description, is_active = p_is_active WHERE id = p_id;
END $$
DELIMITER ;
DELIMITER $$
CREATE PROCEDURE delete_notification_type(IN p_id INT)
BEGIN
    DELETE FROM NOTIFICATION_TYPES WHERE id = p_id;
END $$
DELIMITER ;

-- =====================
-- AUDIT_TABLES
-- =====================
DELIMITER $$
CREATE PROCEDURE create_audit_table(IN p_name VARCHAR(255), IN p_description TEXT)
BEGIN
    INSERT INTO AUDIT_TABLES (name, description) VALUES (p_name, p_description);
END $$
DELIMITER ;
DELIMITER $$
CREATE PROCEDURE get_audit_tables()
BEGIN
    SELECT * FROM AUDIT_TABLES;
END $$
DELIMITER ;
DELIMITER $$
CREATE PROCEDURE update_audit_table(IN p_id INT, IN p_name VARCHAR(255), IN p_description TEXT)
BEGIN
    UPDATE AUDIT_TABLES SET name = p_name, description = p_description WHERE id = p_id;
END $$
DELIMITER ;
DELIMITER $$
CREATE PROCEDURE delete_audit_table(IN p_id INT)
BEGIN
    DELETE FROM AUDIT_TABLES WHERE id = p_id;
END $$
DELIMITER ;

-- =============================================================================
-- CRUD PARA TABLAS MAESTRAS
-- =============================================================================

-- =====================
-- DEPARTMENTS
-- =====================
DELIMITER $$
CREATE PROCEDURE create_department(IN p_name VARCHAR(255))
BEGIN
    INSERT INTO DEPARTMENTS (name) VALUES (p_name);
END $$
DELIMITER ;
DELIMITER $$
CREATE PROCEDURE get_departments()
BEGIN
    SELECT * FROM DEPARTMENTS;
END $$
DELIMITER ;
DELIMITER $$
CREATE PROCEDURE update_department(IN p_id INT, IN p_name VARCHAR(255))
BEGIN
    UPDATE DEPARTMENTS SET name = p_name WHERE id = p_id;
END $$
DELIMITER ;
DELIMITER $$
CREATE PROCEDURE delete_department(IN p_id INT)
BEGIN
    DELETE FROM DEPARTMENTS WHERE id = p_id;
END $$
DELIMITER ;

-- =====================
-- SUBJECTS
-- =====================
-- CREATE, UPDATE, DELETE: sobre la tabla SUBJECTS
-- READ: usar la vista vw_subjects
DELIMITER $$
CREATE PROCEDURE create_subject(IN p_acronym VARCHAR(255), IN p_name VARCHAR(255), IN p_id_department INT, IN p_credits INT)
BEGIN
    INSERT INTO SUBJECTS (acronym, name, id_department, credits) VALUES (p_acronym, p_name, p_id_department, p_credits);
END $$
DELIMITER ;
DELIMITER $$
CREATE PROCEDURE get_subjects_all()
BEGIN
    SELECT * FROM vw_subjects;
END $$
DELIMITER ;
DELIMITER $$
CREATE PROCEDURE update_subject(IN p_id INT, IN p_acronym VARCHAR(255), IN p_name VARCHAR(255), IN p_id_department INT, IN p_credits INT)
BEGIN
    UPDATE SUBJECTS SET acronym = p_acronym, name = p_name, id_department = p_id_department, credits = p_credits WHERE id = p_id;
END $$
DELIMITER ;
DELIMITER $$
CREATE PROCEDURE delete_subject(IN p_id INT)
BEGIN
    DELETE FROM SUBJECTS WHERE id = p_id;
END $$
DELIMITER ;

-- =====================
-- CURRICULUM_COURSES
-- =====================
-- CREATE, UPDATE, DELETE: sobre la tabla CURRICULUM_COURSES
-- READ: usar la vista vw_curriculum_courses
DELIMITER $$
CREATE PROCEDURE create_curriculum_course(IN p_name VARCHAR(255), IN p_id_curriculum_course_type INT)
BEGIN
    INSERT INTO CURRICULUM_COURSES (name, id_curriculum_course_type) VALUES (p_name, p_id_curriculum_course_type);
END $$
DELIMITER ;
DELIMITER $$
CREATE PROCEDURE get_curriculum_courses_all()
BEGIN
    SELECT * FROM vw_curriculum_courses;
END $$
DELIMITER ;
DELIMITER $$
CREATE PROCEDURE update_curriculum_course(IN p_id INT, IN p_name VARCHAR(255), IN p_id_curriculum_course_type INT)
BEGIN
    UPDATE CURRICULUM_COURSES SET name = p_name, id_curriculum_course_type = p_id_curriculum_course_type WHERE id = p_id;
END $$
DELIMITER ;
DELIMITER $$
CREATE PROCEDURE delete_curriculum_course(IN p_id INT)
BEGIN
    DELETE FROM CURRICULUM_COURSES WHERE id = p_id;
END $$
DELIMITER ;

-- =====================
-- WORKSHOPS
-- =====================
-- CREATE, UPDATE, DELETE: sobre la tabla WORKSHOPS
-- READ: usar la vista vw_workshops
DELIMITER $$
CREATE PROCEDURE create_workshop(
    IN p_name VARCHAR(255),
    IN p_semester ENUM('1', '2'),
    IN p_year INT,
    IN p_professor VARCHAR(255),
    IN p_description TEXT,
    IN p_inscription_start_date TIMESTAMP,
    IN p_inscription_end_date TIMESTAMP,
    IN p_course_start_date TIMESTAMP,
    IN p_course_end_date TIMESTAMP,
    IN p_syllabus_data LONGBLOB,
    IN p_available TINYINT,
    IN p_id_workshop_state INT
)
BEGIN
    INSERT INTO WORKSHOPS (name, semester, year, professor, description, inscription_start_date, inscription_end_date, course_start_date, course_end_date, syllabus_data, available, id_workshop_state)
    VALUES (p_name, p_semester, p_year, p_professor, p_description, p_inscription_start_date, p_inscription_end_date, p_course_start_date, p_course_end_date, p_syllabus_data, p_available, p_id_workshop_state);
END $$
DELIMITER ;
DELIMITER $$
CREATE PROCEDURE get_workshops_all()
BEGIN
    SELECT * FROM vw_workshops;
END $$
DELIMITER ;
DELIMITER $$
CREATE PROCEDURE update_workshop(
    IN p_id INT,
    IN p_name VARCHAR(255),
    IN p_semester ENUM('1', '2'),
    IN p_year INT,
    IN p_professor VARCHAR(255),
    IN p_description TEXT,
    IN p_inscription_start_date TIMESTAMP,
    IN p_inscription_end_date TIMESTAMP,
    IN p_course_start_date TIMESTAMP,
    IN p_course_end_date TIMESTAMP,
    IN p_syllabus_data LONGBLOB,
    IN p_available TINYINT,
    IN p_id_workshop_state INT
)
BEGIN
    UPDATE WORKSHOPS SET name = p_name, semester = p_semester, year = p_year, professor = p_professor, description = p_description, inscription_start_date = p_inscription_start_date, inscription_end_date = p_inscription_end_date, course_start_date = p_course_start_date, course_end_date = p_course_end_date, syllabus_data = p_syllabus_data, available = p_available, id_workshop_state = p_id_workshop_state WHERE id = p_id;
END $$
DELIMITER ;
DELIMITER $$
CREATE PROCEDURE delete_workshop(IN p_id INT)
BEGIN
    DELETE FROM WORKSHOPS WHERE id = p_id;
END $$
DELIMITER ;
