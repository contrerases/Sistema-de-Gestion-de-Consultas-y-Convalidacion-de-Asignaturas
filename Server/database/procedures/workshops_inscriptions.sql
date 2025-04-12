

CREATE PROCEDURE GetWorkshopsInscriptionsByWorkshopID(
    IN workshop_id INT
)
BEGIN
    SELECT 
        WORKSHOPS_INSCRIPTIONS.id AS id,
        WORKSHOPS_INSCRIPTIONS.id_student AS id_student,
        CONCAT(STUDENTS.first_name, ' ', STUDENTS.first_last_name) AS name_student,
        STUDENTS.rut_student AS rut_student,
        WORKSHOPS_INSCRIPTIONS.id_workshop AS id_workshop,
        WORKSHOPS.name AS workshop,
        WORKSHOPS_INSCRIPTIONS.id_curriculum_course AS id_curriculum_course,
        CURRICULUM_COURSES.name AS curriculum_course,
        WORKSHOPS_INSCRIPTIONS.is_convalidated AS is_convalidated
    FROM 
        WORKSHOPS_INSCRIPTIONS
    JOIN 
        STUDENTS ON WORKSHOPS_INSCRIPTIONS.id_student = STUDENTS.id
    JOIN 
        WORKSHOPS ON WORKSHOPS_INSCRIPTIONS.id_workshop = WORKSHOPS.id
    LEFT JOIN 
        CURRICULUM_COURSES ON WORKSHOPS_INSCRIPTIONS.id_curriculum_course = CURRICULUM_COURSES.id
    WHERE 
        WORKSHOPS_INSCRIPTIONS.id_workshop = workshop_id;
END 




CREATE PROCEDURE GetEnrolledAvailableWorkshopsByStudent(
    IN student_id INT
)
BEGIN
    SELECT 
        WORKSHOPS.id,
        WORKSHOPS.name,
        WORKSHOPS.semester,
        WORKSHOPS.year,
        WORKSHOPS.professor,
        WORKSHOPS.initial_date,
        WORKSHOPS.file_data,
        WORKSHOPS.available
    FROM 
        WORKSHOPS
    JOIN 
        WORKSHOPS_INSCRIPTIONS ON WORKSHOPS.id = WORKSHOPS_INSCRIPTIONS.id_workshop
    WHERE 
        WORKSHOPS_INSCRIPTIONS.id_student = student_id
        AND WORKSHOPS.available = TRUE;
END

 ;



-- workshops_inscriptions.sql
CREATE PROCEDURE GetWorkshopsInscriptionsByWorkshopID(
 IN workshop_id INT
)
BEGIN
 SELECT 
 WORKSHOPS_INSCRIPTIONS.id AS id,
 WORKSHOPS_INSCRIPTIONS.id_student AS id_student,
 CONCAT(STUDENTS.first_name, ' ', STUDENTS.first_last_name) AS name_student,
 STUDENTS.rut_student AS rut_student,
 WORKSHOPS_INSCRIPTIONS.id_workshop AS id_workshop,
 WORKSHOPS.name AS workshop,
 WORKSHOPS_INSCRIPTIONS.id_curriculum_course AS id_curriculum_course,
 CURRICULUM_COURSES.name AS curriculum_course,
 WORKSHOPS_INSCRIPTIONS.is_convalidated AS is_convalidated
 FROM 
 WORKSHOPS_INSCRIPTIONS
 JOIN 
 STUDENTS ON WORKSHOPS_INSCRIPTIONS.id_student = STUDENTS.id
 JOIN 
 WORKSHOPS ON WORKSHOPS_INSCRIPTIONS.id_workshop = WORKSHOPS.id
 LEFT JOIN 
 CURRICULUM_COURSES ON WORKSHOPS_INSCRIPTIONS.id_curriculum_course = CURRICULUM_COURSES.id
 WHERE 
 WORKSHOPS_INSCRIPTIONS.id_workshop = workshop_id;
END;


CREATE PROCEDURE GetEnrolledAvailableWorkshopsByStudent(
 IN student_id INT
)
BEGIN
 SELECT 
 WORKSHOPS.id,
 WORKSHOPS.name,
 WORKSHOPS.semester,
 WORKSHOPS.year,
 WORKSHOPS.professor,
 WORKSHOPS.initial_date,
 WORKSHOPS.file_data,
 WORKSHOPS.available
 FROM 
 WORKSHOPS
 JOIN 
 WORKSHOPS_INSCRIPTIONS ON WORKSHOPS.id = WORKSHOPS_INSCRIPTIONS.id_workshop
 WHERE 
 WORKSHOPS_INSCRIPTIONS.id_student = student_id
 AND WORKSHOPS.available = TRUE;
END
 
