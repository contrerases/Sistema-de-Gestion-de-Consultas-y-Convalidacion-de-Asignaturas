CREATE PROCEDURE GetAllCurriculumCourses()
BEGIN
    SELECT id, name, id_type_curriculum_course FROM CURRICULUM_COURSES;
END

CREATE PROCEDURE InsertCurriculumCourse(
    IN course_name VARCHAR(255),
    IN p_id_type_curriculum_course INT
)
BEGIN
    INSERT INTO CURRICULUM_COURSES (name, id_type_curriculum_course) VALUES (course_name, p_id_type_curriculum_course);
END

CREATE PROCEDURE DeleteCurriculumCourseById(
    IN course_id INT
)
BEGIN
    DELETE FROM CURRICULUM_COURSES WHERE id = course_id;
END