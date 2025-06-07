-- Convalidaciones realizadas
CREATE TABLE IF NOT EXISTS CONVALIDATIONS (
    id INT NOT NULL AUTO_INCREMENT,
    id_request INT NOT NULL,
    id_convalidation_type INT NOT NULL,
    state ENUM(
        'Enviada',
        'Rechazada',
        'Aprobada por DI',
        'En espera de DE',
        'Aprobada por DE'
    ) NOT NULL DEFAULT 'Enviada',
    id_curriculum_course INT NOT NULL,
    id_subject_to_convalidate INT NULL,
    id_workshop_to_convalidate INT NULL,
    certified_course_name VARCHAR(255) NULL,
    personal_project_name VARCHAR(255) NULL,
    file_data LONGBLOB DEFAULT NULL,
    file_name VARCHAR(255) DEFAULT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (id_request) REFERENCES REQUESTS (id),
    FOREIGN KEY (id_convalidation_type) REFERENCES TYPES_CONVALIDATIONS (id),
    FOREIGN KEY (id_curriculum_course) REFERENCES CURRICULUM_COURSES (id),
    CONSTRAINT fk_subject FOREIGN KEY (id_subject_to_convalidate) REFERENCES SUBJECTS (id),
    CONSTRAINT fk_workshop FOREIGN KEY (id_workshop_to_convalidate) REFERENCES WORKSHOPS (id),
    CONSTRAINT chk_convalidation_type CHECK (
        (id_subject_to_convalidate IS NOT NULL AND id_workshop_to_convalidate IS NULL AND certified_course_name IS NULL AND personal_project_name IS NULL) OR
        (id_subject_to_convalidate IS NULL AND id_workshop_to_convalidate IS NOT NULL AND certified_course_name IS NULL AND personal_project_name IS NULL) OR
        (id_subject_to_convalidate IS NULL AND id_workshop_to_convalidate IS NULL AND certified_course_name IS NOT NULL AND personal_project_name IS NULL) OR
        (id_subject_to_convalidate IS NULL AND id_workshop_to_convalidate IS NULL AND certified_course_name IS NULL AND personal_project_name IS NOT NULL)
    ),
    INDEX (id_request)
);
