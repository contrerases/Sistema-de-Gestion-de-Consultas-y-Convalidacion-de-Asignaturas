USE SGC;

-- Cambio del delimitador para evitar problemas con la sintaxis
DELIMITER //

-- Procedimiento para obtener todos los cursos
CREATE PROCEDURE get_all_courses()
BEGIN
    SELECT * FROM COURSES;
END //

-- Procedimiento para obtener todas las materias
CREATE PROCEDURE get_all_subjects()
BEGIN
    SELECT * FROM SUBJECTS;
END //

-- Procedimiento para obtener todas las convalidaciones
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





-- Procedimiento para obtener todas las convalidaciones por estado

DELIMITER //

DROP PROCEDURE IF EXISTS get_convalidation_by_state;

DELIMITER //

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

DELIMITER ;


-- Procedimiento para obtener todas las convalidaciones por estudiante


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

-- Restauramos el delimitador a su valor predeterminado
DELIMITER ;
