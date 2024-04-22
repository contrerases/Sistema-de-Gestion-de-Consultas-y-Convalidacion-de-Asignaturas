DROP PROCEDURE IF EXISTS get_all_courses; 
DROP PROCEDURE IF EXISTS add_course;
DROP PROCEDURE IF EXISTS delete_course;
DROP PROCEDURE IF EXISTS update_course;



DELIMITER //

-- Procedimiento para obtener todos los cursos
CREATE PROCEDURE get_all_courses()
BEGIN
    SELECT * FROM COURSES;
END //


CREATE PROCEDURE  add_course(IN p_acronym VARCHAR(255), IN p_name VARCHAR(255))
BEGIN
    DECLARE course_count INT;

    -- Verificar si el curso ya existe
    SELECT COUNT(*) INTO course_count FROM COURSES WHERE acronym = p_acronym;

    IF course_count > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El curso ya existe';
    ELSE
        -- Insertar el curso
        INSERT INTO COURSES (acronym, name) VALUES (p_acronym, p_name);
    END IF;
END //

CREATE PROCEDURE delete_course(IN p_acronym VARCHAR(255))
BEGIN
    DECLARE course_count INT;

    -- Verificar si el curso existe
    SELECT COUNT(*) INTO course_count FROM COURSES WHERE acronym = p_acronym;

    IF course_count = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El curso no existe';
    ELSE
        -- Eliminar el curso
        DELETE FROM COURSES WHERE acronym = p_acronym;
    END IF;
END //

CREATE PROCEDURE update_course(IN p_old_acronym VARCHAR(255), IN p_new_acronym VARCHAR(255), IN p_new_name VARCHAR(255))
BEGIN
    DECLARE course_count INT;

    -- Verificar si el curso existe
    SELECT COUNT(*) INTO course_count FROM COURSES WHERE acronym = p_old_acronym;

    IF course_count = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El curso no existe';
    ELSE
        -- Actualizar el curso
        UPDATE COURSES SET acronym = p_new_acronym, name = p_new_name WHERE acronym = p_old_acronym;
    END IF;
END //

DELIMITER ;

