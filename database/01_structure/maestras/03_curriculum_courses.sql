-- Cursos del plan de estudios
CREATE TABLE IF NOT EXISTS CURRICULUM_COURSES (
    id INT NOT NULL AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL UNIQUE, -- libre 1 .. n , Electivo 1 ... n, Electivo Informatica 1 ... n
    id_type_curriculum_course INT NOT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (id_type_curriculum_course) REFERENCES TYPES_CURRICULUM_COURSES (id)
);
