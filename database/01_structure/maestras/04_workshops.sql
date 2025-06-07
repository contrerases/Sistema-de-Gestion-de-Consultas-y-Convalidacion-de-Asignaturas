-- Talleres ofrecidos
CREATE TABLE IF NOT EXISTS WORKSHOPS (
    id INT AUTO_INCREMENT NOT NULL,
    name VARCHAR(255) NOT NULL UNIQUE,
    semester ENUM('1', '2') NOT NULL,
    year INT NOT NULL,
    professor VARCHAR(255) NOT NULL,
    initial_date TIMESTAMP NOT NULL,
    inscription_deadline TIMESTAMP NOT NULL,
    file_data LONGBLOB DEFAULT NULL,
    available BOOLEAN NOT NULL DEFAULT TRUE,
    state VARCHAR(255) NOT NULL DEFAULT 'Inscripcion',
    PRIMARY KEY (id)
);
