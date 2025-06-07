-- Inscripciones a talleres
CREATE TABLE IF NOT EXISTS WORKSHOPS_INSCRIPTIONS (
    id INT AUTO_INCREMENT NOT NULL,
    id_student INT NOT NULL,
    id_workshop INT NOT NULL,
    id_curriculum_course INT NOT NULL,
    is_convalidated BOOLEAN NOT NULL DEFAULT FALSE,
    PRIMARY KEY (id),
    FOREIGN KEY (id_student) REFERENCES STUDENTS (id),
    FOREIGN KEY (id_workshop) REFERENCES WORKSHOPS (id),
    FOREIGN KEY (id_curriculum_course) REFERENCES CURRICULUM_COURSES (id),
    CONSTRAINT unique_workshop_inscription UNIQUE (id_student, id_workshop)
);
