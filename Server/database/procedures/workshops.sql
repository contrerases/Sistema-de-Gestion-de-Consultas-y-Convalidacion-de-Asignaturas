DROP PROCEDURE IF EXISTS GetAllWorkshops;

DROP PROCEDURE IF EXISTS GetWorkshopsByAvailable;

DROP PROCEDURE IF EXISTS GetWorkshopsByCurrentlySemester;

DROP PROCEDURE IF EXISTS InsertWorkshop;

DROP PROCEDURE IF EXISTS UpdateWorkshopAvailable;

DROP PROCEDURE IF EXISTS GetCompletedWorkshopsByStudent;

DROP PROCEDURE IF EXISTS GetAvailableWorkshopsNotEnrolledByStudent;

DROP PROCEDURE IF EXISTS GetEnrolledAvailableWorkshopsByStudent;

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
    IN p_professor VARCHAR(255),
    IN p_initial_date TIMESTAMP,
    IN p_inscription_deadline TIMESTAMP,
    IN p_file_data LONGBLOB
)
BEGIN
    INSERT INTO WORKSHOPS (name, semester, year, professor, initial_date,inscription_deadline, file_data)
    VALUES (p_name, p_semester, p_year, p_professor, p_initial_date,p_inscription_deadline, p_file_data);
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

CREATE PROCEDURE GetCompletedWorkshopsByStudent(
    IN student_id INT
)
BEGIN
    SELECT 
        WORKSHOPS.id,
        WORKSHOPS.name,
        WORKSHOPS.semester,
        WORKSHOPS.year,
        WORKSHOPS.professor,
        WORKSHOPS.initial_date,
        WORKSHOPS.inscription_deadline,
        WORKSHOPS.file_data,
        WORKSHOPS.available,
        WORKSHOPS.state
    FROM 
        WORKSHOPS
    JOIN 
        WORKSHOPS_INSCRIPTIONS ON WORKSHOPS.id = WORKSHOPS_INSCRIPTIONS.id_workshop
    WHERE 
        WORKSHOPS_INSCRIPTIONS.id_student = student_id
        AND WORKSHOPS.available = FALSE;
END

CREATE PROCEDURE GetAvailableWorkshopsNotEnrolledByStudent(
    IN student_id INT
)
BEGIN
    SELECT 
        WORKSHOPS.id,
        WORKSHOPS.name,
        WORKSHOPS.semester,
        WORKSHOPS.year,
        WORKSHOPS.professor,
        WORKSHOPS.initial_date,
        WORKSHOPS.inscription_deadline,
        WORKSHOPS.file_data,
        WORKSHOPS.available,
        WORKSHOPS.state
    FROM 
        WORKSHOPS
    WHERE 
        WORKSHOPS.available = TRUE
        AND WORKSHOPS.id NOT IN (
            SELECT 
                WORKSHOPS_INSCRIPTIONS.id_workshop
            FROM 
                WORKSHOPS_INSCRIPTIONS
            WHERE 
                WORKSHOPS_INSCRIPTIONS.id_student = student_id
        );
END

CREATE PROCEDURE GetEnrolledAvailableWorkshopsByStudent(
    IN student_id INT
)
BEGIN
    SELECT 
        WORKSHOPS.id,
        WORKSHOPS.name,
        WORKSHOPS.semester,
        WORKSHOPS.year,
        WORKSHOPS.professor,
        WORKSHOPS.initial_date,
        WORKSHOPS.inscription_deadline,
        WORKSHOPS.file_data,
        WORKSHOPS.available,
        WORKSHOPS.state
    FROM 
        WORKSHOPS
    JOIN 
        WORKSHOPS_INSCRIPTIONS ON WORKSHOPS.id = WORKSHOPS_INSCRIPTIONS.id_workshop
    WHERE 
        WORKSHOPS_INSCRIPTIONS.id_student = student_id
        AND WORKSHOPS.available = TRUE;
END