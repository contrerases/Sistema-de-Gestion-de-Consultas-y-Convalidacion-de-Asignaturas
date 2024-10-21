DELIMITER //

CREATE PROCEDURE GetAllDepartments()
BEGIN
    SELECT * FROM DEPARTMENTS;
END //

DELIMITER ;


DELIMITER //

CREATE PROCEDURE DeleteDepartmentByID(IN dept_id INT)
BEGIN
    DELETE FROM DEPARTMENTS WHERE id = dept_id;
END //

DELIMITER ;


DELIMITER //

CREATE PROCEDURE InsertDepartment(IN dept_name VARCHAR(255))
BEGIN
    INSERT INTO DEPARTMENTS (name) VALUES (dept_name);
END //

DELIMITER ;



DELIMITER $$

CREATE PROCEDURE UpdateDepartmentByID(
    IN p_department_id INT,
    IN p_new_name VARCHAR(255)
)
BEGIN
    -- Verifica si el departamento con el ID dado existe
    IF EXISTS (SELECT 1 FROM DEPARTMENTS WHERE id = p_department_id) THEN
        -- Actualiza el nombre del departamento
        UPDATE DEPARTMENTS
        SET name = p_new_name
        WHERE id = p_department_id;
    ELSE
        -- Lanza un error si el departamento no existe
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'El departamento con el ID proporcionado no existe.';
    END IF;
END $$

DELIMITER ;
