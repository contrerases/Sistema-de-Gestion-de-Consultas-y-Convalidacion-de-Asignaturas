

CREATE PROCEDURE GetByIdWorkshop(IN p_id_workshop INT)
BEGIN
    SELECT *
    FROM WORKSHOPS_INSCRIPTIONS
    WHERE id_workshop = p_id_workshop;
END

CREATE PROCEDURE GetByIdStudent(IN p_id_student INT)
BEGIN
    SELECT *
    FROM WORKSHOPS_INSCRIPTIONS
    WHERE id_student = p_id_student;
END

CREATE PROCEDURE InsertWorkshopInscription(
    IN p_id_student INT,
    IN p_id_workshop INT,
    IN p_id_curriculum_course INT,
    IN p_is_convalidated BOOLEAN
)
BEGIN
    INSERT INTO WORKSHOPS_INSCRIPTIONS (id_student, id_workshop, id_curriculum_course, is_convalidated)
    VALUES (p_id_student, p_id_workshop, p_id_curriculum_course, p_is_convalidated);
END