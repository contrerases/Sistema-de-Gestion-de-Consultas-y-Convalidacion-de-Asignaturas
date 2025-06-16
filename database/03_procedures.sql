-- TYPES_CONVALIDATIONS

DROP PROCEDURE IF EXISTS GetAllTypesConvalidations;

-- TYPES_CURRICULUM_COURSES

DROP PROCEDURE IF EXISTS GetAllTypesCurriculumCourses;

-- DEPARTMENT

DROP PROCEDURE IF EXISTS GetAllDepartments;

DROP PROCEDURE IF EXISTS InsertDepartment;

DROP PROCEDURE IF EXISTS UpdateDepartmentByID;

-- CURRICULUM_COURSES

DROP PROCEDURE IF EXISTS GetAllCurriculumCourses;

DROP PROCEDURE IF EXISTS InsertCurriculumCourse;

DROP PROCEDURE IF EXISTS UpdateCurriculumCourseByID;

--  SUBJECTS

DROP PROCEDURE IF EXISTS GetAllSubjectsProcessedData;

DROP PROCEDURE IF EXISTS InsertSubject;

DROP PROCEDURE IF EXISTS DeleteSubjectById;

DROP PROCEDURE IF EXISTS UpdateSubjectByID;

-- WORKSHOPS

DROP PROCEDURE IF EXISTS GetAllWorkshops;

DROP PROCEDURE IF EXISTS GetWorkshopsByAvailable;

DROP PROCEDURE IF EXISTS GetWorkshopsByCurrentlySemester;

DROP PROCEDURE IF EXISTS InsertWorkshop;

DROP PROCEDURE IF EXISTS UpdateWorkshopAvailable;

DROP PROCEDURE IF EXISTS GetCompletedWorkshopsByStudent;

DROP PROCEDURE IF EXISTS GetAvailableWorkshopsNotEnrolledByStudent;

DROP PROCEDURE IF EXISTS GetEnrolledAvailableWorkshopsByStudent;

-- REQUESTS

DROP PROCEDURE IF EXISTS GetAllRequestsProcessed;

DROP PROCEDURE IF EXISTS GetRequestByID;

DROP PROCEDURE IF EXISTS InsertRequest;

DROP PROCEDURE IF EXISTS GetRequestsByStudentRUT;

DROP PROCEDURE IF EXISTS GetRequestsByStudentRol;

DROP PROCEDURE IF EXISTS GetRequestsByDateRangeCreation;

DROP PROCEDURE IF EXISTS GetRequestsByCampus;

DROP PROCEDURE IF EXISTS GetRequestsByState;

DROP PROCEDURE IF EXISTS UpdateRequest;

DROP PROCEDURE IF EXISTS GetFilteredRequests;

-- CONVALIDATIONS

DROP PROCEDURE IF EXISTS GetConvalidationsByRequestId;

DROP PROCEDURE IF EXISTS InsertConvalidation;

DROP PROCEDURE IF EXISTS UpdateConvalidation;

-- WORKSHOPS_INSCRIPTIONS

DROP PROCEDURE IF EXISTS GetWorkshopsInscriptionsByWorkshopID;



-- WORKSHOPS_GRADES

DROP PROCEDURE IF EXISTS GetWorkshopGradeByStudentID;

DROP PROCEDURE IF EXISTS GetWorkshopGradeByWorkshopID;

DROP PROCEDURE IF EXISTS InsertWorkshopGrade;

-- Cambiar el delimitador para permitir la creación de procedimientos
DELIMITER //

--------------------------------------------------------------------------
---------------------- TYPES_CONVALIDATIONS ------------------------------
--------------------------------------------------------------------------

-- Obtiene todos los tipos de convalidaciones
CREATE PROCEDURE GetAllTypesConvalidations()
BEGIN
    SELECT TYPES_CONVALIDATIONS.id, TYPES_CONVALIDATIONS.name 
    FROM TYPES_CONVALIDATIONS;
END //

--------------------------------------------------------------------------
---------------------- TYPES_CURRICULUM_COURSES --------------------------
--------------------------------------------------------------------------

-- Obtiene todos los tipos de cursos del currículum
CREATE PROCEDURE GetAllTypesCurriculumCourses()
BEGIN
    SELECT TYPES_CURRICULUM_COURSES.id, TYPES_CURRICULUM_COURSES.name
    FROM TYPES_CURRICULUM_COURSES;
END //

--------------------------------------------------------------------------
-------------------------- DEPARTMENTS -----------------------------------
--------------------------------------------------------------------------

-- Obtiene todos los departamentos
CREATE PROCEDURE GetAllDepartments()
BEGIN
    SELECT * FROM DEPARTMENTS;
END //

-- Elimina un departamento por su ID
CREATE PROCEDURE DeleteDepartmentByID(IN dept_id INT)
BEGIN
    DELETE FROM DEPARTMENTS WHERE id = dept_id;
END //

-- Inserta un nuevo departamento
CREATE PROCEDURE InsertDepartment(IN dept_name VARCHAR(255))
BEGIN
    INSERT INTO DEPARTMENTS (name) VALUES (dept_name);
END //

-- Actualiza un departamento por su ID
CREATE PROCEDURE UpdateDepartmentByID(
    IN p_department_id INT,
    IN p_new_name VARCHAR(255)
)
BEGIN
    -- Verifica si el departamento con el ID dado existe
    IF EXISTS (SELECT 1 FROM DEPARTMENTS WHERE id = p_department_id) THEN
        -- Actualiza el nombre del departamento
        UPDATE DEPARTMENTS
        SET name = p_new_name
        WHERE id = p_department_id;
    ELSE
        -- Lanza un error si el departamento no existe
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'El departamento con el ID proporcionado no existe.';
    END IF; 
END //

--------------------------------------------------------------------------
-------------------------- CURRICULUM_COURSES ----------------------------
--------------------------------------------------------------------------

-- Obtiene todos los cursos del currículum
CREATE PROCEDURE GetAllCurriculumCourses()
BEGIN
    SELECT id, name, id_type_curriculum_course FROM CURRICULUM_COURSES;
END //

-- Inserta un nuevo curso del currículum
CREATE PROCEDURE InsertCurriculumCourse(
    IN course_name VARCHAR(255),
    IN p_id_type_curriculum_course INT
)
BEGIN
    INSERT INTO CURRICULUM_COURSES (name, id_type_curriculum_course) VALUES (course_name, p_id_type_curriculum_course);
END //

-- Elimina un curso del currículum por su ID
CREATE PROCEDURE DeleteCurriculumCourseById(
    IN course_id INT
)
BEGIN
    DELETE FROM CURRICULUM_COURSES WHERE id = course_id;
END //

--------------------------------------------------------------------------
-------------------------- SUBJECTS --------------------------------------
--------------------------------------------------------------------------

-- Obtiene todos los cursos del currículum
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

END //

-- Inserta un nuevo curso del currículum
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

END //

-- Elimina un curso del currículum por su ID
CREATE PROCEDURE DeleteSubjectById (IN subject_id INT) BEGIN
DELETE FROM SUBJECTS
WHERE
    id = subject_id;

END //

-- Actualiza un curso del currículum por su ID
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

END //

--------------------------------------------------------------------------
-------------------------- WORKSHOPS -------------------------------------
--------------------------------------------------------------------------

-- Obtiene todos los talleres
CREATE PROCEDURE GetAllWorkshops()
BEGIN
    SELECT * FROM WORKSHOPS;
END //

-- Obtiene todos los talleres del semestre actual
CREATE PROCEDURE GetWorkshopsByCurrentlySemester(IN p_year INT, IN p_semester ENUM('1', '2'))
BEGIN
    SELECT * 
    FROM WORKSHOPS
    WHERE year = p_year AND semester = p_semester;
END //

-- Obtiene todos los talleres disponibles
CREATE PROCEDURE GetWorkshopsByAvailable(IN p_available BOOLEAN)
BEGIN
    SELECT * 
    FROM WORKSHOPS
    WHERE available = p_available;
END //

-- Inserta un nuevo taller
CREATE PROCEDURE InsertWorkshop(
    IN p_name VARCHAR(255),
    IN p_semester ENUM('1', '2'),
    IN p_year INT,
    IN p_professor VARCHAR(255),
    IN p_initial_date TIMESTAMP,
    IN p_inscription_deadline TIMESTAMP,
    IN p_file_data LONGBLOB
)
BEGIN
    INSERT INTO WORKSHOPS (name, semester, year, professor, initial_date,inscription_deadline, file_data)
    VALUES (p_name, p_semester, p_year, p_professor, p_initial_date,p_inscription_deadline, p_file_data);
END //

-- Actualiza el estado de un taller
CREATE PROCEDURE UpdateWorkshopAvailable(
    IN p_id INT,
    IN p_available BOOLEAN
)
BEGIN
    UPDATE WORKSHOPS
    SET available = p_available
    WHERE id = p_id;
END //

-- Obtiene todos los talleres completados por un estudiante
CREATE PROCEDURE GetCompletedWorkshopsByStudent(
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
        WORKSHOPS.inscription_deadline,
        WORKSHOPS.file_data,
        WORKSHOPS.available,
        WORKSHOPS.state
    FROM 
        WORKSHOPS
    JOIN 
        WORKSHOPS_INSCRIPTIONS ON WORKSHOPS.id = WORKSHOPS_INSCRIPTIONS.id_workshop
    WHERE 
        WORKSHOPS_INSCRIPTIONS.id_student = student_id
        AND WORKSHOPS.available = FALSE;
END //

-- Obtiene todos los talleres disponibles no inscritos por un estudiante
CREATE PROCEDURE GetAvailableWorkshopsNotEnrolledByStudent(
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
        WORKSHOPS.inscription_deadline,
        WORKSHOPS.file_data,
        WORKSHOPS.available,
        WORKSHOPS.state
    FROM 
        WORKSHOPS
    WHERE 
        WORKSHOPS.available = TRUE
        AND WORKSHOPS.id NOT IN (
            SELECT 
                WORKSHOPS_INSCRIPTIONS.id_workshop
            FROM 
                WORKSHOPS_INSCRIPTIONS
            WHERE 
                WORKSHOPS_INSCRIPTIONS.id_student = student_id
        );
END //

-- Obtiene todos los talleres disponibles inscritos por un estudiante
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
        WORKSHOPS.inscription_deadline,
        WORKSHOPS.file_data,
        WORKSHOPS.available,
        WORKSHOPS.state
    FROM 
        WORKSHOPS
    JOIN 
        WORKSHOPS_INSCRIPTIONS ON WORKSHOPS.id = WORKSHOPS_INSCRIPTIONS.id_workshop
    WHERE 
        WORKSHOPS_INSCRIPTIONS.id_student = student_id
        AND WORKSHOPS.available = TRUE;
END //

--------------------------------------------------------------------------
-------------------------- REQUESTS --------------------------------------
--------------------------------------------------------------------------

-- Obtiene todos los requests procesados
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
END //

-- Obtiene un request por ID
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

END //

-- Inserta un request
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
END //

-- Obtiene todos los requests por RUT de estudiante
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

END //

-- Obtiene todos los requests por Rol de estudiante
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

END //

-- Obtiene todos los requests por rango de fecha de creacion
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

END //

-- Obtiene todos los requests por campus de estudiante
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

END //

-- Obtiene todos los requests por estado
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
END //

-- Actualiza un request
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
END //

-- Obtiene todos los requests filtrados
CREATE PROCEDURE GetFilteredRequests (
    IN p_first_name VARCHAR(255),    
    IN p_rut_student VARCHAR(12),    
    IN p_rol_student VARCHAR(10),    
    IN p_date_lower_bound DATE,      
    IN p_date_upper_bound DATE       
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
END //

-------------------------------------------------------------------
---------------------- CONVALIDACIONES ----------
-------------------------------------------------------------------

-- Obtiene todas las convalidaciones por id de request
CREATE PROCEDURE GetConvalidationsByRequestId (IN request_id INT)
BEGIN
    SELECT
        CONVALIDATIONS.id,
        CONVALIDATIONS.id_request,
        CONVALIDATIONS.state,
        CONVALIDATIONS.id_convalidation_type,
        TYPES_CONVALIDATIONS.name AS convalidation_type,
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
        TYPES_CONVALIDATIONS ON CONVALIDATIONS.id_convalidation_type = TYPES_CONVALIDATIONS.id
    LEFT JOIN 
        CURRICULUM_COURSES ON CONVALIDATIONS.id_curriculum_course = CURRICULUM_COURSES.id
    LEFT JOIN 
        SUBJECTS ON CONVALIDATIONS.id_subject_to_convalidate = SUBJECTS.id
    LEFT JOIN 
        WORKSHOPS ON CONVALIDATIONS.id_workshop_to_convalidate = WORKSHOPS.id
    WHERE
        CONVALIDATIONS.id_request = request_id;
END //

-- Inserta una convalidacion
CREATE PROCEDURE InsertConvalidation (
    IN id_request INT,
    IN id_convalidation_type INT,
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
        id_curriculum_course,
        id_subject_to_convalidate,
        id_workshop_to_convalidate,
        certified_course_name,
        personal_project_name,
        file_data,
        file_name
    );

END //

-- Actualiza una convalidacion
CREATE PROCEDURE UpdateConvalidation(
    IN p_id_convalidation INT,
    IN p_state ENUM('Enviada', 'Rechazada', 'Aprobada por DI', 'En espera de DE', 'Aprobada por DE')
)
BEGIN
    UPDATE CONVALIDATIONS
    SET state = p_state
    WHERE id = p_id_convalidation;
END //

-------------------------------------------------------------------
---------------------- WORKSHOPS INSCRIPTIONS ---------------------
-------------------------------------------------------------------

-- Obtiene las inscripciones de un taller especifico
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
END //



-----------------------------------------------------------------------------
-------------------------- WORKSHOPS GRADES ---------------------------------
-----------------------------------------------------------------------------

-- Obtiene la calificacion de un estudiante en un taller
CREATE PROCEDURE GetWorkshopGradeByStudentID(IN p_id_student INT)
BEGIN
    SELECT *
    FROM WORKSHOPS_GRADES
    WHERE id_student = p_id_student;
END //

-- Obtiene la calificacion de un taller
CREATE PROCEDURE GetWorkshopGradeByWorkshopID(IN p_id_workshop INT)
BEGIN
    SELECT *
    FROM WORKSHOPS_GRADES
    WHERE id_workshop = p_id_workshop;
END //

-- Inserta una calificación de un taller
CREATE PROCEDURE InsertWorkshopGrade(
    IN p_id_student INT,
    IN p_id_workshop INT,
    IN p_grade INT
)
BEGIN
    INSERT INTO WORKSHOPS_GRADES (id_student, id_workshop, grade)
    VALUES (p_id_student, p_id_workshop, p_grade);
END //

-- Mensaje de confirmación
SELECT "Procedimientos insertados correctamente" AS message //

-- Restaurar el delimitador por defecto
DELIMITER ; 