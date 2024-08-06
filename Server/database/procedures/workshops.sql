CREATE PROCEDURE GetAllWorkshops()
BEGIN
    SELECT * FROM WORKSHOPS;
END 


CREATE PROCEDURE GetWorkshopsByCurrentlySemester(IN p_year INT, IN p_semester ENUM('1', '2'))
BEGIN
    SELECT * 
    FROM WORKSHOPS
    WHERE year = p_year AND semester = p_semester;
END

CREATE PROCEDURE GetWorkshopsByAvailable(IN p_available BOOLEAN)
BEGIN
    SELECT * 
    FROM WORKSHOPS
    WHERE available = p_available;
END 


CREATE PROCEDURE InsertWorkshop(
    IN p_name VARCHAR(255),
    IN p_semester ENUM('1', '2'),
    IN p_year INT,
    IN p_initial_date TIMESTAMP,
    IN p_file_data LONGBLOB
)
BEGIN
    INSERT INTO WORKSHOPS (name, semester, year, initial_date, file_data)
    VALUES (p_name, p_semester, p_year, p_initial_date, p_file_data);
END


CREATE PROCEDURE UpdateWorkshopAvailable(
    IN p_id INT,
    IN p_available BOOLEAN
)
BEGIN
    UPDATE WORKSHOPS
    SET available = p_available
    WHERE id = p_id;
END