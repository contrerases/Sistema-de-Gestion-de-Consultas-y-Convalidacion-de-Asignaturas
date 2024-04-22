DROP PROCEDURE IF EXISTS get_all_courses; 

DELIMITER //

-- Procedimiento para obtener todos los cursos
CREATE PROCEDURE get_all_courses()
BEGIN
    SELECT * FROM COURSES;
END //


DELIMITER ;

