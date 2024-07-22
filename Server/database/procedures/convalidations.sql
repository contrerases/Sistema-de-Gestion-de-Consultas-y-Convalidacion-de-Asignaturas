CREATE PROCEDURE GetConvalidationsByRequestId (IN request_id INT) BEGIN
SELECT
    CONVALIDATIONS.id AS convalidation_id,
    CONVALIDATIONS.id_request,
    CONVALIDATIONS.id_convalidation_type,
    CONVALIDATIONS.state,
    CONVALIDATIONS.id_curriculum_course,
    CONVALIDATIONS.id_subject_to_convalidate,
    CONVALIDATIONS.id_workshop_to_convalidate,
    CONVALIDATIONS.certified_course_name,
    CONVALIDATIONS.personal_project_name,
    CONVALIDATIONS.file_data,
    CONVALIDATIONS.file_name
FROM
    CONVALIDATIONS
WHERE
    CONVALIDATIONS.id_request = request_id;

END 

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