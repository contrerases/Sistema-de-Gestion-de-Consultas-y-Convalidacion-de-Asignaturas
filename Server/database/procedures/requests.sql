CREATE PROCEDURE GetAllRequestsProcessed () BEGIN
SELECT
    REQUESTS.id,
    REQUESTS.id_student,
    REQUESTS.creation_date,
    REQUESTS.revision_date,
    REQUESTS.comments,
    REQUESTS.id_user_approves,
    STUDENTS.rol_student,
    STUDENTS.rut_student,
    STUDENTS.campus_student
FROM
    REQUESTS
    JOIN STUDENTS ON REQUESTS.id_student = STUDENTS.id;

END 

CREATE PROCEDURE GetRequestByIDProcessed (IN request_id INT) BEGIN
SELECT
    REQUESTS.id,
    REQUESTS.id_student,
    REQUESTS.creation_date,
    REQUESTS.revision_date,
    REQUESTS.comments,
    REQUESTS.id_user_approves,
    STUDENTS.rol_student,
    STUDENTS.rut_student,
    STUDENTS.campus_student
FROM
    REQUESTS
    JOIN STUDENTS ON REQUESTS.id_student = STUDENTS.id
WHERE
    REQUESTS.id = request_id;

END 

CREATE PROCEDURE InsertRequest (
    IN id_student INT,
    IN creation_date DATE,
    IN revision_date DATE,
    IN comments VARCHAR(255),
    IN id_user_approves INT
) BEGIN
INSERT INTO
    REQUESTS (
        id_student,
        creation_date,
        revision_date,
        comments,
        id_user_approves
    )
VALUES
    (
        id_student,
        creation_date,
        revision_date,
        comments,
        id_user_approves
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
    STUDENTS.rol_student,
    STUDENTS.rut_student,
    STUDENTS.campus_student
FROM
    REQUESTS
    JOIN STUDENTS ON REQUESTS.id_student = STUDENTS.id
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
    STUDENTS.rol_student,
    STUDENTS.rut_student,
    STUDENTS.campus_student
FROM
    REQUESTS
    JOIN STUDENTS ON REQUESTS.id_student = STUDENTS.id
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
    STUDENTS.rol_student,
    STUDENTS.rut_student,
    STUDENTS.campus_student
FROM
    REQUESTS
    JOIN STUDENTS ON REQUESTS.id_student = STUDENTS.id
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
    STUDENTS.rol_student,
    STUDENTS.rut_student,
    STUDENTS.campus_student
FROM
    REQUESTS
    JOIN STUDENTS ON REQUESTS.id_student = STUDENTS.id
WHERE
    STUDENTS.campus_student = campus;

END


-- get by state

CREATE PROCEDURE GetRequestsByState (IN state VARCHAR(50)) BEGIN
SELECT
    REQUESTS.id,
    REQUESTS.id_student,
    REQUESTS.creation_date,
    REQUESTS.revision_date,
    REQUESTS.comments,
    REQUESTS.id_user_approves,
    STUDENTS.rol_student,
    STUDENTS.rut_student,
    STUDENTS.campus_student
FROM
    REQUESTS
    JOIN STUDENTS ON REQUESTS.id_student = STUDENTS.id
WHERE
    REQUESTS.state = state;

END

-- get by reques id 

CREATE PROCEDURE GetRequestByID (IN request_id INT) BEGIN
SELECT
    REQUESTS.id,
    REQUESTS.id_student,
    REQUESTS.creation_date,
    REQUESTS.revision_date,
    REQUESTS.comments,
    REQUESTS.id_user_approves,
    STUDENTS.rol_student,
    STUDENTS.rut_student,
    STUDENTS.campus_student
FROM
    REQUESTS
    JOIN STUDENTS ON REQUESTS.id_student = STUDENTS.id
WHERE
    REQUESTS.id = request_id;

END



CREATE PROCEDURE UpdateRequest (
    IN p_request_id INT,
    IN p_comments TEXT,
    IN p_state VARCHAR(50),
    IN p_id_user_approves INT
)
BEGIN
    UPDATE REQUESTS
    SET 
        comments = p_comments,
        state = p_state,
        id_user_approves = p_id_user_approves,
        revision_date = CURRENT_TIMESTAMP
    WHERE 
        id = p_request_id;
END 