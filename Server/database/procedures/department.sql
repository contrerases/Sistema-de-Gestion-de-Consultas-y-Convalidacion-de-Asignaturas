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