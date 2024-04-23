DROP PROCEDURE IF EXISTS get_convalidation_by_state;
DROP PROCEDURE IF EXISTS get_convalidation_by_student;
DROP PROCEDURE IF EXISTS get_all_convalidations;
DROP PROCEDURE IF EXISTS set_convalidation;
DELIMITER //

CREATE PROCEDURE get_all_convalidations()
BEGIN
    SELECT
        id,
        rol,
        id_origin_course,
        id_destination_course,
        state,
        comments,
        creation_date,
        approval_date,
        user_approves
    FROM
        CONVALIDATIONS;
END //


CREATE PROCEDURE get_convalidation_by_state(
    IN in_state VARCHAR(50)
)

BEGIN
    -- Verificar si el estado proporcionado es válido
    IF NOT (in_state IN ('En revisión', 'Aceptada por el jefe de carrera', 'Aceptada por dirección de estudio', 'Rechazada', 'Finalizada')) THEN
        SIGNAL SQLSTATE '45002' SET MESSAGE_TEXT = 'El estado especificado no es válido.';
    END IF;

    -- Seleccionamos las convalidaciones por estado
    SELECT
        id,
        rol,
        id_origin_course,
        id_destination_course,
        state,
        comments,
        creation_date,
        approval_date,
        user_approves
    FROM
        CONVALIDATIONS
    WHERE
        state = in_state;
END //




CREATE PROCEDURE get_convalidation_by_student(
    IN in_rol INT
)
BEGIN
     -- Verificamos si el estudiante existe
    IF NOT EXISTS (SELECT 1 FROM STUDENTS WHERE rol = in_rol) THEN
        SIGNAL SQLSTATE '45003' SET MESSAGE_TEXT = 'No se encontró estudiante';
    END IF;

    -- Verificamos si el estudiante tiene convalidaciones
    IF NOT EXISTS (SELECT 1 FROM CONVALIDATIONS WHERE rol = in_rol) THEN
        SIGNAL SQLSTATE '45004' SET MESSAGE_TEXT = 'El estudiante no tiene convalidaciones.';
    END IF;

    -- Seleccionamos las convalidaciones del estudiante
    SELECT
        id,
        rol,
        id_origin_course,
        id_destination_course,
        state,
        comments,
        creation_date,
        approval_date,
        user_approves
    FROM
        CONVALIDATIONS
    WHERE
        rol = in_rol;
END //

CREATE PROCEDURE set_convalidation (
    IN p_convalidation_id INT, 
    IN p_new_status VARCHAR(50), 
    IN p_comments TEXT
)
BEGIN
    DECLARE convalidation_exists INT;

    -- Verificar si la convalidación existe
    SELECT COUNT(*) INTO convalidation_exists FROM CONVALIDATIONS WHERE id = p_convalidation_id;

    IF convalidation_exists = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'La convalidación no existe';
    ELSE
        -- Actualizar el estado, los comentarios y la fecha de aprobación de la convalidación
        UPDATE CONVALIDATIONS 
        SET state = p_new_status, 
            comments = p_comments, 
            approval_date = CURRENT_TIMESTAMP
        WHERE id = p_convalidation_id;
    END IF;
END;



DELIMITER ;