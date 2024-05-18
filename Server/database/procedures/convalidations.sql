DELIMITER //

CREATE PROCEDURE GetAllConvalidationsProcessedData()
BEGIN
    SELECT 
        CONVALIDATIONS.id,
        CONCAT(STUDENTS.first_name, ' ', STUDENTS.second_name, ' ', STUDENTS.first_last_name, ' ', STUDENTS.second_last_name) AS student_name,
        STUDENTS.rol_student AS student_rol,
        TYPES_COURSES.name AS convalidation_type,
        CONVALIDATIONS.state,
        CONVALIDATIONS.comments,
        CONVALIDATIONS.creation_date,
        CONVALIDATIONS.revision_date,
        IF(CONVALIDATIONS.id_user_approves IS NOT NULL, CONCAT(ADMINISTRATORS.first_name, ' ', ADMINISTRATORS.first_last_name), NULL) AS user_approves_name,
        CURRICULUM_COURSES.name AS curriculum_course,
        SUBJECTS.name AS subject,
        WORKSHOPS.name AS workshop,
        CONVALIDATIONS.certified_course_name,
        CONVALIDATIONS.personal_project_name,
        CONVALIDATIONS.file_data,
        CONVALIDATIONS.file_name
    FROM CONVALIDATIONS
    INNER JOIN STUDENTS ON CONVALIDATIONS.id_student = STUDENTS.id
    INNER JOIN TYPES_COURSES ON CONVALIDATIONS.id_convalidation_type = TYPES_COURSES.id
    LEFT JOIN ADMINISTRATORS ON CONVALIDATIONS.id_user_approves = ADMINISTRATORS.id
    INNER JOIN CURRICULUM_COURSES ON CONVALIDATIONS.id_curriculum_course = CURRICULUM_COURSES.id
    LEFT JOIN SUBJECTS ON CONVALIDATIONS.id_subject_to_convalidate = SUBJECTS.id
    LEFT JOIN WORKSHOPS ON CONVALIDATIONS.id_workshop_to_convalidate = WORKSHOPS.id;
END //

DELIMITER ;




DELIMITER //
CREATE PROCEDURE GetConvalidationsByState( IN p_state VARCHAR(50) )
BEGIN
    SELECT 
        CONVALIDATIONS.id,
        CONCAT(STUDENTS.first_name, ' ', STUDENTS.second_name, ' ', STUDENTS.first_last_name, ' ', STUDENTS.second_last_name) AS student_name,
        STUDENTS.rol_student AS student_rol,
        TYPES_COURSES.name AS convalidation_type,
        CONVALIDATIONS.state,
        CONVALIDATIONS.comments,
        CONVALIDATIONS.creation_date,
        CONVALIDATIONS.revision_date,
        IF(CONVALIDATIONS.id_user_approves IS NOT NULL, CONCAT(ADMINISTRATORS.first_name, ' ', ADMINISTRATORS.first_last_name), NULL) AS user_approves_name,
        CURRICULUM_COURSES.name AS curriculum_course,
        SUBJECTS.name AS subject,
        WORKSHOPS.name AS workshop,
        CONVALIDATIONS.certified_course_name,
        CONVALIDATIONS.personal_project_name,
        CONVALIDATIONS.file_data,
        CONVALIDATIONS.file_name
    FROM CONVALIDATIONS
    INNER JOIN STUDENTS ON CONVALIDATIONS.id_student = STUDENTS.id
    INNER JOIN TYPES_COURSES ON CONVALIDATIONS.id_convalidation_type = TYPES_COURSES.id
    LEFT JOIN ADMINISTRATORS ON CONVALIDATIONS.id_user_approves = ADMINISTRATORS.id
    INNER JOIN CURRICULUM_COURSES ON CONVALIDATIONS.id_curriculum_course = CURRICULUM_COURSES.id
    LEFT JOIN SUBJECTS ON CONVALIDATIONS.id_subject_to_convalidate = SUBJECTS.id
    LEFT JOIN WORKSHOPS ON CONVALIDATIONS.id_workshop_to_convalidate = WORKSHOPS.id
    WHERE CONVALIDATIONS.state = p_state;
END//

DELIMITER ;



DELIMITER //
CREATE PROCEDURE GetConvalidationsByStudentRol( IN p_rol_student VARCHAR(50) )
BEGIN
    SELECT 
        CONVALIDATIONS.id,
        CONCAT(STUDENTS.first_name, ' ', STUDENTS.second_name, ' ', STUDENTS.first_last_name, ' ', STUDENTS.second_last_name) AS student_name,
        STUDENTS.rol_student AS student_rol,
        TYPES_COURSES.name AS convalidation_type,
        CONVALIDATIONS.state,
        CONVALIDATIONS.comments,
        CONVALIDATIONS.creation_date,
        CONVALIDATIONS.revision_date,
        IF(CONVALIDATIONS.id_user_approves IS NOT NULL, CONCAT(ADMINISTRATORS.first_name, ' ', ADMINISTRATORS.first_last_name), NULL) AS user_approves_name,
        CURRICULUM_COURSES.name AS curriculum_course,
        SUBJECTS.name AS subject,
        WORKSHOPS.name AS workshop,
        CONVALIDATIONS.certified_course_name,
        CONVALIDATIONS.personal_project_name,
        CONVALIDATIONS.file_data,
        CONVALIDATIONS.file_name
    FROM CONVALIDATIONS
    INNER JOIN STUDENTS ON CONVALIDATIONS.id_student = STUDENTS.id
    INNER JOIN TYPES_COURSES ON CONVALIDATIONS.id_convalidation_type = TYPES_COURSES.id
    LEFT JOIN ADMINISTRATORS ON CONVALIDATIONS.id_user_approves = ADMINISTRATORS.id
    INNER JOIN CURRICULUM_COURSES ON CONVALIDATIONS.id_curriculum_course = CURRICULUM_COURSES.id
    LEFT JOIN SUBJECTS ON CONVALIDATIONS.id_subject_to_convalidate = SUBJECTS.id
    LEFT JOIN WORKSHOPS ON CONVALIDATIONS.id_workshop_to_convalidate = WORKSHOPS.id
    WHERE STUDENTS.rol_student = p_rol_student;
END//



DELIMITER //
CREATE PROCEDURE GetConvalidationById( IN p_id INT )
BEGIN
    SELECT 
        CONVALIDATIONS.id,
        CONCAT(STUDENTS.first_name, ' ', STUDENTS.second_name, ' ', STUDENTS.first_last_name, ' ', STUDENTS.second_last_name) AS student_name,
        STUDENTS.rol_student AS student_rol,
        TYPES_COURSES.name AS convalidation_type,
        CONVALIDATIONS.state,
        CONVALIDATIONS.comments,
        CONVALIDATIONS.creation_date,
        CONVALIDATIONS.revision_date,
        IF(CONVALIDATIONS.id_user_approves IS NOT NULL, CONCAT(ADMINISTRATORS.first_name, ' ', ADMINISTRATORS.first_last_name), NULL) AS user_approves_name,
        CURRICULUM_COURSES.name AS curriculum_course,
        SUBJECTS.name AS subject,
        WORKSHOPS.name AS workshop,
        CONVALIDATIONS.certified_course_name,
        CONVALIDATIONS.personal_project_name,
        CONVALIDATIONS.file_data,
        CONVALIDATIONS.file_name
    FROM CONVALIDATIONS
    INNER JOIN STUDENTS ON CONVALIDATIONS.id_student = STUDENTS.id
    INNER JOIN TYPES_COURSES ON CONVALIDATIONS.id_convalidation_type = TYPES_COURSES.id
    LEFT JOIN ADMINISTRATORS ON CONVALIDATIONS.id_user_approves = ADMINISTRATORS.id
    INNER JOIN CURRICULUM_COURSES ON CONVALIDATIONS.id_curriculum_course = CURRICULUM_COURSES.id
    LEFT JOIN SUBJECTS ON CONVALIDATIONS.id_subject_to_convalidate = SUBJECTS.id
    LEFT JOIN WORKSHOPS ON CONVALIDATIONS.id_workshop_to_convalidate = WORKSHOPS.id
    WHERE CONVALIDATIONS.id = p_id;
END//


DELIMITER //
CREATE PROCEDURE InsertConvalidation(
    IN p_id_student INT,
    IN p_id_convalidation_type INT,
    IN p_id_user_approves INT,
    IN p_id_curriculum_course INT,
    IN p_id_subject_to_convalidate INT,
    IN p_id_workshop_to_convalidate INT,
    IN p_certified_course_name VARCHAR(255),
    IN p_personal_project_name VARCHAR(255),
    IN p_file_data LONGBLOB,
    IN p_file_name VARCHAR(255),
    IN p_creation_date TIMESTAMP,
    IN p_revision_date TIMESTAMP
)
BEGIN
    INSERT INTO CONVALIDATIONS (
        id_student,
        id_convalidation_type,
        state,
        id_user_approves,
        id_curriculum_course,
        id_subject_to_convalidate,
        id_workshop_to_convalidate,
        certified_course_name,
        personal_project_name,
        file_data,
        file_name,
        creation_date,
        revision_date
    ) VALUES (
        p_id_student,
        p_id_convalidation_type,
        'Enviada', -- Estado por defecto
        p_id_user_approves,
        p_id_curriculum_course,
        p_id_subject_to_convalidate,
        p_id_workshop_to_convalidate,
        p_certified_course_name,
        p_personal_project_name,
        p_file_data,
        p_file_name,
        p_creation_date,
        p_revision_date
    );
END //
DELIMITER ;



DELIMITER //

CREATE PROCEDURE ModifyConvalidation(
    IN p_id INT,
    IN p_state VARCHAR(50),
    IN p_comments TEXT
)
BEGIN
    UPDATE CONVALIDATIONS
    SET state = p_state, comments = p_comments
    WHERE id = p_id;
END //

DELIMITER ;


