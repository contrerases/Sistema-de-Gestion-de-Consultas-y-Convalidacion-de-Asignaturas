CREATE PROCEDURE GetConvalidationsByRequestId (IN request_id INT)
BEGIN
    SELECT
        CONVALIDATIONS.id,
        CONVALIDATIONS.id_request,
        CONVALIDATIONS.state,
        CONVALIDATIONS.id_convalidation_type,
        TYPES_COURSES.name AS convalidation_type,
        CONVALIDATIONS.id_curriculum_course,
        CURRICULUM_COURSES.name AS curriculum_course,
        CONVALIDATIONS.id_subject_to_convalidate,
        SUBJECTS.name AS subject,
        CONVALIDATIONS.id_workshop_to_convalidate,
        WORKSHOPS.name AS workshop,
        CONVALIDATIONS.certified_course_name,
        CONVALIDATIONS.personal_project_name,
        CONVALIDATIONS.file_data,
        CONVALIDATIONS.file_name
    FROM
        CONVALIDATIONS
    LEFT JOIN 
        TYPES_COURSES ON CONVALIDATIONS.id_convalidation_type = TYPES_COURSES.id
    LEFT JOIN 
        CURRICULUM_COURSES ON CONVALIDATIONS.id_curriculum_course = CURRICULUM_COURSES.id
    LEFT JOIN 
        SUBJECTS ON CONVALIDATIONS.id_subject_to_convalidate = SUBJECTS.id
    LEFT JOIN 
        WORKSHOPS ON CONVALIDATIONS.id_workshop_to_convalidate = WORKSHOPS.id
    WHERE
        CONVALIDATIONS.id_request = request_id;
END;


CREATE PROCEDURE InsertConvalidation (
    IN id_request INT,
    IN id_convalidation_type INT,
    IN state VARCHAR(255),
    IN id_curriculum_course INT,
    IN id_subject_to_convalidate INT,
    IN id_workshop_to_convalidate INT,
    IN certified_course_name VARCHAR(255),
    IN personal_project_name VARCHAR(255),
    IN file_data BLOB,
    IN file_name VARCHAR(255)
) BEGIN
INSERT INTO
    CONVALIDATIONS (
        id_request,
        id_convalidation_type,
        state,
        id_curriculum_course,
        id_subject_to_convalidate,
        id_workshop_to_convalidate,
        certified_course_name,
        personal_project_name,
        file_data,
        file_name
    )
VALUES
    (
        id_request,
        id_convalidation_type,
        state,
        id_curriculum_course,
        id_subject_to_convalidate,
        id_workshop_to_convalidate,
        certified_course_name,
        personal_project_name,
        file_data,
        file_name
    );

END




CREATE PROCEDURE UpdateConvalidation(
    IN p_id_convalidation INT,
    IN p_state ENUM('Enviada', 'Rechazada', 'Aprobada por DI', 'En espera de DE', 'Aprobada por DE')
)
BEGIN
    UPDATE CONVALIDATIONS
    SET state = p_state
    WHERE id = p_id_convalidation;
END