CREATE PROCEDURE GetWorkshopGradeByStudentID(IN p_id_student INT)
BEGIN
    SELECT *
    FROM WORKSHOPS_GRADES
    WHERE id_student = p_id_student;
END

CREATE PROCEDURE GetWorkshopGradeByWorkshopID(IN p_id_workshop INT)
BEGIN
    SELECT *
    FROM WORKSHOPS_GRADES
    WHERE id_workshop = p_id_workshop;
END

CREATE PROCEDURE InsertWorkshopGrade(
    IN p_id_student INT,
    IN p_id_workshop INT,
    IN p_grade INT
)
BEGIN
    INSERT INTO WORKSHOPS_GRADES (id_student, id_workshop, grade)
    VALUES (p_id_student, p_id_workshop, p_grade);
END 