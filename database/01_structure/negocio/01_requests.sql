-- Solicitudes de convalidación
CREATE TABLE IF NOT EXISTS REQUESTS (
    id INT NOT NULL AUTO_INCREMENT,
    id_student INT NOT NULL,
    creation_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    revision_date TIMESTAMP,
    comments TEXT DEFAULT NULL,
    id_user_approves INT DEFAULT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (id_student) REFERENCES STUDENTS (id),
    FOREIGN KEY (id_user_approves) REFERENCES ADMINISTRATORS (id)
);
