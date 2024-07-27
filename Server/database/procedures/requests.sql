CREATE PROCEDURE `GetAllRequestsProcessed`()
BEGIN
    SELECT 
        REQUESTS.id,
        REQUESTS.id_student,
        REQUESTS.creation_date,
        REQUESTS.revision_date,
        REQUESTS.comments,
        REQUESTS.id_user_approves,
        IF(REQUESTS.id_user_approves IS NOT NULL, CONCAT(ADMINISTRATORS.first_name, ' ', ADMINISTRATORS.first_last_name), NULL) AS user_approves,
        STUDENTS.rol_student,
        STUDENTS.rut_student,
        CONCAT(STUDENTS.first_name, ' ', STUDENTS.first_last_name) AS name_student,
        STUDENTS.campus_student
    FROM 
        REQUESTS
    INNER JOIN STUDENTS ON REQUESTS.id_student = STUDENTS.id
    LEFT JOIN ADMINISTRATORS ON REQUESTS.id_user_approves = ADMINISTRATORS.id;
END

CREATE PROCEDURE GetRequestByID (IN request_id INT) BEGIN
SELECT 
        REQUESTS.id,
        REQUESTS.id_student,
        REQUESTS.creation_date,
        REQUESTS.revision_date,
        REQUESTS.comments,
        REQUESTS.id_user_approves,
        IF(REQUESTS.id_user_approves IS NOT NULL, CONCAT(ADMINISTRATORS.first_name, ' ', ADMINISTRATORS.first_last_name), NULL) AS user_approves,
        STUDENTS.rol_student,
        STUDENTS.rut_student,
        CONCAT(STUDENTS.first_name, ' ', STUDENTS.first_last_name) AS name_student,
        STUDENTS.campus_student
    FROM 
        REQUESTS
    INNER JOIN STUDENTS ON REQUESTS.id_student = STUDENTS.id
    LEFT JOIN ADMINISTRATORS ON REQUESTS.id_user_approves = ADMINISTRATORS.id
    WHERE
        REQUESTS.id = request_id;

END



CREATE PROCEDURE `InsertRequest`(
    IN p_id_student INT,
    IN p_comments VARCHAR(255),
    IN p_id_user_approves INT
)
BEGIN
    INSERT INTO REQUESTS (
        id_student,
        comments,
        id_user_approves
    )
    VALUES (
        p_id_student,
        p_comments,
        p_id_user_approves
    );
    
    SELECT LAST_INSERT_ID() AS id;
END



CREATE PROCEDURE GetRequestsByStudentRUT (IN student_rut VARCHAR(255)) BEGIN
SELECT 
        REQUESTS.id,
        REQUESTS.id_student,
        REQUESTS.creation_date,
        REQUESTS.revision_date,
        REQUESTS.comments,
        REQUESTS.id_user_approves,
        IF(REQUESTS.id_user_approves IS NOT NULL, CONCAT(ADMINISTRATORS.first_name, ' ', ADMINISTRATORS.first_last_name), NULL) AS user_approves,
        STUDENTS.rol_student,
        STUDENTS.rut_student,
        CONCAT(STUDENTS.first_name, ' ', STUDENTS.first_last_name) AS name_student,
        STUDENTS.campus_student
    FROM 
        REQUESTS
    INNER JOIN STUDENTS ON REQUESTS.id_student = STUDENTS.id
    LEFT JOIN ADMINISTRATORS ON REQUESTS.id_user_approves = ADMINISTRATORS.id
WHERE
    STUDENTS.rut_student = student_rut;

END


CREATE PROCEDURE GetRequestsByStudentRol (IN student_rol VARCHAR(255)) BEGIN
SELECT 
        REQUESTS.id,
        REQUESTS.id_student,
        REQUESTS.creation_date,
        REQUESTS.revision_date,
        REQUESTS.comments,
        REQUESTS.id_user_approves,
        IF(REQUESTS.id_user_approves IS NOT NULL, CONCAT(ADMINISTRATORS.first_name, ' ', ADMINISTRATORS.first_last_name), NULL) AS user_approves,
        STUDENTS.rol_student,
        STUDENTS.rut_student,
        CONCAT(STUDENTS.first_name, ' ', STUDENTS.first_last_name) AS name_student,
        STUDENTS.campus_student
    FROM 
        REQUESTS
    INNER JOIN STUDENTS ON REQUESTS.id_student = STUDENTS.id
    LEFT JOIN ADMINISTRATORS ON REQUESTS.id_user_approves = ADMINISTRATORS.id
WHERE
    STUDENTS.rol_student = student_rol;

END

CREATE PROCEDURE GetRequestsByDateRangeCreation (IN start_date DATE, IN end_date DATE) BEGIN
SELECT 
        REQUESTS.id,
        REQUESTS.id_student,
        REQUESTS.creation_date,
        REQUESTS.revision_date,
        REQUESTS.comments,
        REQUESTS.id_user_approves,
        IF(REQUESTS.id_user_approves IS NOT NULL, CONCAT(ADMINISTRATORS.first_name, ' ', ADMINISTRATORS.first_last_name), NULL) AS user_approves,
        STUDENTS.rol_student,
        STUDENTS.rut_student,
        CONCAT(STUDENTS.first_name, ' ', STUDENTS.first_last_name) AS name_student,
        STUDENTS.campus_student
    FROM 
        REQUESTS
    INNER JOIN STUDENTS ON REQUESTS.id_student = STUDENTS.id
    LEFT JOIN ADMINISTRATORS ON REQUESTS.id_user_approves = ADMINISTRATORS.id
WHERE
    REQUESTS.creation_date BETWEEN start_date AND end_date;

END


-- fitler by campus 

CREATE PROCEDURE GetRequestsByCampus (IN campus VARCHAR(255)) BEGIN
SELECT 
        REQUESTS.id,
        REQUESTS.id_student,
        REQUESTS.creation_date,
        REQUESTS.revision_date,
        REQUESTS.comments,
        REQUESTS.id_user_approves,
        IF(REQUESTS.id_user_approves IS NOT NULL, CONCAT(ADMINISTRATORS.first_name, ' ', ADMINISTRATORS.first_last_name), NULL) AS user_approves,
        STUDENTS.rol_student,
        STUDENTS.rut_student,
        CONCAT(STUDENTS.first_name, ' ', STUDENTS.first_last_name) AS name_student,
        STUDENTS.campus_student
    FROM 
        REQUESTS
    INNER JOIN STUDENTS ON REQUESTS.id_student = STUDENTS.id
    LEFT JOIN ADMINISTRATORS ON REQUESTS.id_user_approves = ADMINISTRATORS.id
WHERE
    STUDENTS.campus_student = campus;

END


-- get by state

CREATE PROCEDURE GetRequestsByState (IN p_state VARCHAR(50))
BEGIN
SELECT 
        REQUESTS.id,
        REQUESTS.id_student,
        REQUESTS.creation_date,
        REQUESTS.revision_date,
        REQUESTS.comments,
        REQUESTS.id_user_approves,
        IF(REQUESTS.id_user_approves IS NOT NULL, CONCAT(ADMINISTRATORS.first_name, ' ', ADMINISTRATORS.first_last_name), NULL) AS user_approves,
        STUDENTS.rol_student,
        STUDENTS.rut_student,
        CONCAT(STUDENTS.first_name, ' ', STUDENTS.first_last_name) AS name_student,
        STUDENTS.campus_student
    FROM 
        REQUESTS
    INNER JOIN STUDENTS ON REQUESTS.id_student = STUDENTS.id
    LEFT JOIN ADMINISTRATORS ON REQUESTS.id_user_approves = ADMINISTRATORS.id
    WHERE 
        REQUESTS.id IN (
            SELECT 
                id_request 
            FROM 
                CONVALIDATIONS 
            WHERE 
                state = 'Enviada'
        );
END;


-- get by reques id 




CREATE PROCEDURE UpdateRequest (
    IN p_request_id INT,
    IN p_comments TEXT,
    IN p_id_user_approves INT
)
BEGIN
    UPDATE REQUESTS
    SET 
        comments = p_comments,
        id_user_approves = p_id_user_approves,
        revision_date = CURRENT_TIMESTAMP
    WHERE 
        id = p_request_id;
END 