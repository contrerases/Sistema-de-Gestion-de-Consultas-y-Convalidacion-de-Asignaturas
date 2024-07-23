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