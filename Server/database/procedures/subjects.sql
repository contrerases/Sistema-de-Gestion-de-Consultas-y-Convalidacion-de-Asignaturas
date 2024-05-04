DELIMITER / / 

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

END / / DELIMITER;