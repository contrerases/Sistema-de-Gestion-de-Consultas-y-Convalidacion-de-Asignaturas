CREATE PROCEDURE GetAllSubjectsProcessedData () BEGIN
SELECT
    SUBJECTS.id,
    SUBJECTS.acronym,
    SUBJECTS.name,
    DEPARTMENTS.name AS department_name,
    SUBJECTS.credits
FROM
    SUBJECTS
    INNER JOIN DEPARTMENTS ON SUBJECTS.id_department = DEPARTMENTS.id;

END

CREATE PROCEDURE InsertSubject (
    IN subject_acronym VARCHAR(255),
    IN subject_name VARCHAR(255),
    IN department_id INT,
    IN subject_credits INT
) BEGIN
INSERT INTO
    SUBJECTS (acronym, name, id_department, credits)
VALUES
    (
        subject_acronym,
        subject_name,
        department_id,
        subject_credits
    );

END

CREATE PROCEDURE DeleteSubjectById (IN subject_id INT) BEGIN
DELETE FROM SUBJECTS
WHERE
    id = subject_id;

END

CREATE PROCEDURE UpdateSubjectByID (
    IN p_id INT,
    IN p_acronym VARCHAR(255),
    IN p_name VARCHAR(255),
    IN p_id_department INT,
    IN p_credits INT
) BEGIN
UPDATE SUBJECTS
SET
    acronym = p_acronym,
    name = p_name,
    id_department = p_id_department,
    credits = p_credits
WHERE
    id = p_id;

END