CREATE PROCEDURE GetAllRequestsProcessed()
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

CREATE PROCEDURE InsertRequest(
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
END

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

CREATE PROCEDURE GetFilteredRequests (
    IN p_first_name VARCHAR(255),    -- Nombre del estudiante
    IN p_rut_student VARCHAR(12),    -- RUT del estudiante
    IN p_rol_student VARCHAR(10),    -- Rol del estudiante
    IN p_date_lower_bound DATE,      -- Cota fecha inferior
    IN p_date_upper_bound DATE       -- Cota fecha superior
)
BEGIN
    SELECT
        REQUESTS.ID AS id,
        REQUESTS.id_student,
        REQUESTS.CREATION_DATE AS creation_date,
        REQUESTS.REVISION_DATE AS revision_date,
        REQUESTS.COMMENTS AS comments,
        CONCAT(ADMINISTRATORS.FIRST_NAME, ' ', ADMINISTRATORS.SECOND_NAME, ' ', ADMINISTRATORS.FIRST_LAST_NAME, ' ', ADMINISTRATORS.SECOND_LAST_NAME) AS user_approves,
        STUDENTS.ROL_STUDENT AS rol_student,
        CONCAT(STUDENTS.FIRST_NAME, ' ', STUDENTS.SECOND_NAME, ' ', STUDENTS.FIRST_LAST_NAME, ' ', STUDENTS.SECOND_LAST_NAME) AS name_student,
        STUDENTS.RUT_STUDENT AS rut_student,
        STUDENTS.CAMPUS_STUDENT AS campus_student
    FROM
        REQUESTS
    INNER JOIN STUDENTS ON REQUESTS.ID_STUDENT = STUDENTS.ID
    LEFT JOIN ADMINISTRATORS ON REQUESTS.ID_USER_APPROVES = ADMINISTRATORS.ID
    WHERE
        -- Aplicar filtros opcionales
        (p_first_name IS NULL OR STUDENTS.FIRST_NAME LIKE CONCAT('%', p_first_name, '%'))
        AND (p_rut_student IS NULL OR STUDENTS.RUT_STUDENT = p_rut_student)
        AND (p_rol_student IS NULL OR STUDENTS.ROL_STUDENT = p_rol_student)
        AND (p_date_lower_bound IS NULL OR REQUESTS.CREATION_DATE >= p_date_lower_bound)
        AND (p_date_upper_bound IS NULL OR REQUESTS.CREATION_DATE <= p_date_upper_bound)
        AND NOT EXISTS (
            SELECT 1
            FROM CONVALIDATIONS
            WHERE CONVALIDATIONS.ID_REQUEST = REQUESTS.ID
              AND CONVALIDATIONS.STATE = 'Enviada'
        )
    ORDER BY REQUESTS.CREATION_DATE DESC;
END