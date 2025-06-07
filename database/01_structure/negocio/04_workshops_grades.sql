-- Calificaciones de talleres
CREATE TABLE IF NOT EXISTS WORKSHOPS_GRADES (
    id INT AUTO_INCREMENT NOT NULL,
    id_student INT NOT NULL,
    id_workshop INT NOT NULL,
    grade INT NOT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (id_student) REFERENCES STUDENTS (id),
    FOREIGN KEY (id_workshop) REFERENCES WORKSHOPS (id),
    CONSTRAINT chk_grade CHECK (grade BETWEEN 0 AND 100)
);
