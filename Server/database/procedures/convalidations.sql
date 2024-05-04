DELIMITER //
CREATE PROCEDURE GetAllConvalidationsProcessedData()
BEGIN
    SELECT 
        CONVALIDATIONS.id,
        CONCAT(STUDENTS.first_name, ' ', STUDENTS.second_name, ' ', STUDENTS.first_last_name, ' ', STUDENTS.second_last_name) AS 'student_name',
        STUDENTS.rol_student AS 'student_rol',
        TYPES_COURSES.name AS 'convalidation_type',
        CONVALIDATIONS.state,
        CONVALIDATIONS.comments,
        CONVALIDATIONS.creation_date,
        CONVALIDATIONS.revision_date,
        CONCAT(ADMINISTRATORS.first_name, ' ', ADMINISTRATORS.first_last_name) AS 'user_approves_name',
        CURRICULUM_COURSES.name AS 'course_name',
        SUBJECTS.name AS 'subject_name',
        WORKSHOPS.name AS 'workshop_name',
        CONVALIDATIONS.certified_course_name,
        CONVALIDATIONS.personal_project_name,
        CONVALIDATIONS.file_data,
        CONVALIDATIONS.file_name
    FROM CONVALIDATIONS
    INNER JOIN STUDENTS ON CONVALIDATIONS.id_student = STUDENTS.id
    INNER JOIN TYPES_COURSES ON CONVALIDATIONS.id_convalidation_type = TYPES_COURSES.id
    INNER JOIN ADMINISTRATORS ON CONVALIDATIONS.id_user_approves = ADMINISTRATORS.id
    INNER JOIN CURRICULUM_COURSES ON CONVALIDATIONS.id_curriculum_course = CURRICULUM_COURSES.id
    LEFT JOIN SUBJECTS ON CONVALIDATIONS.id_subject_to_convalidate = SUBJECTS.id
    LEFT JOIN WORKSHOPS ON CONVALIDATIONS.id_workshop_to_convalidate = WORKSHOPS.id;
END//

DELIMITER ;
