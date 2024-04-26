DELIMITER // 

CREATE PROCEDURE 
    GetProcessedConvalidationData (
        IN convalidation_id INT
    ) 
    
    BEGIN
        SELECT
            cv.id AS id,
            s.rol_student AS rol_student,
            tc.name AS convalidation_type,
            gc.name AS name_generic_course,
            sc.name AS name_specific_course,
            cv.state AS state,
            cv.comments AS comments,
            cv.creation_date AS creation_date,
            cv.revision_date AS revision_date,
            a.first_name AS user_approves_name,
            cv.file_data AS file,
            cv.file_name AS file_name
        FROM
            CONVALIDATIONS cv
            JOIN STUDENTS s ON cv.id_student = s.id
            JOIN TYPES_COURSES tc ON cv.convalidation_type = tc.id
            JOIN GENERIC_COURSES gc ON cv.id_generic_course = gc.id
            JOIN SPECIFIC_COURSES sc ON cv.id_specific_course = sc.id
            JOIN ADMINISTRATORS a ON cv.user_approves = a.id
        WHERE
            cv.id = convalidation_id;

    END // 

DELIMITER ;